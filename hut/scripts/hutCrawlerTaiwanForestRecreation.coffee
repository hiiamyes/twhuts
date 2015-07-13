async = require 'async'
moment = require 'moment'
request = require 'request' # https://github.com/request/request
cheerio = require 'cheerio' # https://github.com/cheeriojs/cheerio

module.exports = 
	crawl: (hut, cb)->
		capacityStatus = []
		async.waterfall([
			(cb) ->
				request 'http://recreation.forest.gov.tw/index.aspx', (err, res, body) ->
					if err then cb 'err', null
					else if res.statusCode isnt 200 then cb 'err', null
					else
						$ = cheerio.load body
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
						if err then cb 'err', null
						else if res.statusCode isnt 302 then cb 'err', null
						else
							cookie = res.headers['set-cookie'][0].split(';')[0]
							cb null, cookie
				)
			,(cookie, cb) ->
				request(
					{
						'url': hut.url
						'headers':
							'Connection': 'keep-alive'
							'Cookie': cookie
					}, (err, res, body) ->
						if err then cb 'err', null
						else if res.statusCode isnt 200 then cb 'err', null
						else
							$ThisMonth = cheerio.load body
							cb null, cookie, $ThisMonth, $ThisMonth('#__VIEWSTATE').val(), $ThisMonth('#__EVENTVALIDATION').val()
				)
			,(cookie, $ThisMonth, viewstate, eventvalidation, cb) ->
				request(
					{
						'method': 'POST'
						'url': hut.url
						'headers':
							'Cookie': cookie
						'form':
							'__VIEWSTATE': viewstate
							'__EVENTVALIDATION': eventvalidation
							'__EVENTTARGET': 'eventscalendar$ctl00$NextMonth'
							'__VIEWSTATEENCRYPTED': ''
					}, (err, res, body) ->
						if err then cb 'err', null
						else if res.statusCode isnt 200 then cb 'err', null
						else
							$NextMonth = cheerio.load body
							capacityStatus = parser $ThisMonth, $NextMonth
							cb null, 'done'
				)
		], (err, result) ->
			if err then cb 'fail crawling ' + hut.nameZh, null
			else
				cb null, capacityStatus
		)

parser = ($ThisMonth, $NextMonth) ->
	# Check the month
	monthZHThisMonth = $ThisMonth('#eventscalendar_ctl00_label2').text().split(' ')[0]
	monthThisMonth = 0
	switch monthZHThisMonth
		when '一月' then monthThisMonth = 1
		when '二月' then monthThisMonth = 2
		when '三月' then monthThisMonth = 3
		when '四月' then monthThisMonth = 4
		when '五月' then monthThisMonth = 5
		when '六月' then monthThisMonth = 6
		when '七月' then monthThisMonth = 7
		when '八月' then monthThisMonth = 8
		when '九月' then monthThisMonth = 9
		when '十月' then monthThisMonth = 10
		when '十一月' then monthThisMonth = 11
		when '十二月' then monthThisMonth = 12    

	# Check days one by one
	capacityStatus = []
	dayPre = 0
	month = monthThisMonth
	$ThisMonth('.dayNumber').each (i) ->
		if capacityStatus.length > 38 then return false
		else
			# Calculate the date
			day = parseInt $ThisMonth(this).text()
			if i is 0 and day isnt 1 then month-- else # ex: 4/29 4/30 5/1 5/2
				if day < dayPre then month++ # ex: 5/31 6/1 6/2 6/3
			dayPre = day
			push capacityStatus, $ThisMonth(this), month, day, capacityStatus.length <= 22

	monthCheck = month
	dayCheck = dayPre
	month = monthThisMonth + 1
	pass = false
	$NextMonth('.dayNumber').each (i) ->
		if capacityStatus.length > 38 then return false
		else
			# Calculate the date
			day = parseInt $NextMonth(this).text()
			if i is 0 and day isnt 1 then month-- else 
				if day < dayPre then month++
			dayPre = day
			if not pass and month is monthCheck and day is dayCheck then pass = true
			else if pass
				push capacityStatus, $NextMonth(this), month, day, capacityStatus.length <= 22

	capacityStatus

push = (capacityStatus, ele, month, day, isDrawn) ->
	if ele.parent().children().length > 1
		date = moment().month(month-1).date(day).format()
		try
			remaining = ele.parent().find('#eventscalendar_Label1_0').html().split('<br>')[1].split(':')[1]
			applying = ele.parent().find('#eventscalendar_Label1_0').html().split('<br>')[2].split(':')[1]
			capacityStatus.push
				'date': date
				'remaining': remaining
				'applying': applying
				'isDrawn': isDrawn
		catch e
			capacityStatus.push
				'date': date
				'remaining': 0
				'applying': 0
				'isDrawn': isDrawn

			