request = require 'request' # https://github.com/request/request
cheerio = require 'cheerio' # https://github.com/cheeriojs/cheerio	
async = require 'async'

async.waterfall([
	(cb) ->
		request 'http://recreation.forest.gov.tw/index.aspx', (err, res, body) ->
			$ = cheerio.load body
			# console.log 'open homepage: ' + res.statusCode
			# console.log res.headers
			cb null, $('#__VIEWSTATE').val(), $('#__EVENTVALIDATION').val()
	
	,(viewstate, eventvalidation, cb) ->
		request(
			{
				'method': 'POST'
				'url': 'http://recreation.forest.gov.tw/index.aspx'
				'headers':
					'Connection': 'keep-alive'
				'form':
					'__VIEWSTATE': viewstate
					'__EVENTVALIDATION': eventvalidation
					'ctl00$ContentPlaceHolder1$ID_TextBox': 'hut.crawler.tw@gmail.com'
					'ctl00$ContentPlaceHolder1$Pass_TextBox': 'iamahutcrawler1'
					'ctl00$ContentPlaceHolder1$btn_login': '登入'
			}, (err, res, body) ->
				# console.log 'login: ' + res.statusCode
				# console.log res.headers
				# cookie = res.headers['set-cookie'][0].split(';')[0] + ';' + res.headers['set-cookie'][1].split(';')[0]
				cookie = res.headers['set-cookie'][0].split(';')[0]
				cb null, cookie
		)
	
	,(cookie, cb) ->
		request(
			{
				'url': 'http://recreation.forest.gov.tw/askformonhouse/AskForPaperAddNew.aspx?mode=0&AskSID=&houseid=C'
				'headers':
					'Connection': 'keep-alive'
					'Cookie': cookie
			}, (err, res, body) ->
				# console.log 'get hut: ' + res.statusCode
				# console.log res.headers
				$ = cheerio.load body
				parser $
				# console.log $('#eventscalendar_ctl00_label2').text().split(' ')[0]
				cb null, cookie, $('#__VIEWSTATE').val(), $('#__EVENTVALIDATION').val()
		)
	,(cookie, viewstate, eventvalidation, cb) ->
		request(
			{
				'method': 'POST'
				'url': 'http://recreation.forest.gov.tw/askformonhouse/AskForPaperAddNew.aspx?mode=0&AskSID=&houseid=C'
				'headers':
					'Cookie': cookie
				'form':
					'__VIEWSTATE': viewstate
					'__EVENTVALIDATION': eventvalidation
					'__EVENTTARGET': 'eventscalendar$ctl00$NextMonth'
					'__VIEWSTATEENCRYPTED': ''
			}, (err, res, body) ->
				# console.log 'post hut: ' + res.statusCode
				# console.log res.headers
				$ = cheerio.load body
				parser $
				# console.log $('#eventscalendar_ctl00_label2').text().split(' ')[0]
				cb null, 'done'
		)
], (err, result) ->
	console.log result
)

parser = ($) ->
	# Check the month
	monthZH = $('#eventscalendar_ctl00_label2').text().split(' ')[0]
	month = 0
	switch monthZH
		when '一月' then month = 1
		when '二月' then month = 2
		when '三月' then month = 3
		when '四月' then month = 4
		when '五月' then month = 5
		when '六月' then month = 6
		when '七月' then month = 7
		when '八月' then month = 8
		when '九月' then month = 9
		when '十月' then month = 10
		when '十一月' then month = 11
		when '十二月' then month = 12    

	# Check days one by one
	capacityStatus = []
	dayPre = 0
	$('.dayNumber').each (i) ->
		# Calculate the date
		day = parseInt $(this).text()
		if i is 0 and day isnt 1 then month-- else 
			if day < dayPre then month++
		dayPre = day

		# Record if there is data
		if $(this).parent().children().length > 1
			date = new Date()
			date.setMonth(month - 1)
			date.setDate(day)
			remaining = $(this).parent().find('#eventscalendar_Label1_0').html().split('<br>')[1].split(':')[1]
			applying = $(this).parent().find('#eventscalendar_Label1_0').html().split('<br>')[2].split(':')[1]
			capacityStatus.push
				'date': date,
				'remaining': remaining,
				'applying': applying,
				'waiting': null

	console.log capacityStatus

			# collectionHuts.updateOne(
			#     {'nameZh': '檜谷山莊'}  
			#     ,$set:
			#         'capacityStatuses':
			#             'dateCrawl': moment().format(),
			#             'status': capacityStatus
			#     ,(err, r) ->    
			#         console.log if err isnt null then err else 'success crawling ' + '檜谷'
			# )

