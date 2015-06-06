async = require 'async'
moment = require 'moment'
request = require 'request' # https://github.com/request/request
cheerio = require 'cheerio' # https://github.com/cheeriojs/cheerio

module.exports = 
	crawl: (hut, cbExports)->
		
		capacityStatus = []
		capacity = hut.capacity

		urlAfterDraw = ''
		urlBeforeDraw = ''
		selectorRemaining = ''
		ddlLocation = 0
		switch hut.nameZh
			when '排雲山莊' 
				urlAfterDraw = 'https://mountain.ysnp.gov.tw/chinese/Location_Detail.aspx?pg=01&w=1&n=1005&s=1'
				urlBeforeDraw = 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003'
				selectorRemaining = 'span.style11 font'
				ddlLocation = 1
			when '圓峰山屋', '圓峰營地'
				urlAfterDraw = 'https://mountain.ysnp.gov.tw/chinese/Location_Detail.aspx?pg=01&w=1&n=1005&s=136'
				urlBeforeDraw = 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003'
				selectorRemaining = 'span.style12 font'
				ddlLocation = 2

		async.waterfall([
			(cb) ->
				request urlAfterDraw, (err, res, body) ->
					$ = cheerio.load body
					parser $, () -> 
						cb null, $
			, ($, cb) ->
				request(
					'method': 'POST'
					'url': urlAfterDraw
					'form':
						'__EVENTTARGET': 'ctl00$ContentPlaceHolder1$CalendarReport'
						'__EVENTARGUMENT': $('table#ctl00_ContentPlaceHolder1_CalendarReport table tr td:nth-child(3) a').attr('href').substring(68, 68+5)
						'__VIEWSTATE': $('#__VIEWSTATE').val()
						'__VIEWSTATEGENERATOR': $('#__VIEWSTATEGENERATOR').val()
						'__EVENTVALIDATION': $('#__EVENTVALIDATION').val()
				, (err, res, body) ->
					parser cheerio.load(body), () -> 
						cb null
				)
			# , (cb) ->
			# 	async.eachSeries(
			# 		[0..4]
			# 		, (itmes, eachSerialFinished) ->
			# 			request urlBeforeDraw, (err, res, body) ->
			# 				$ = cheerio.load body
			# 				date = moment().add(7 + capacityStatus.length,'d')
			# 				request({
			# 					'method': 'POST'
			# 					'url': urlBeforeDraw
			# 					'form':
			# 						'ctl00_ContentPlaceHolder1_ToolkitScriptManager1_HiddenField': ''			
			# 						'__EVENTTARGET': ''
			# 						'__EVENTARGUMENT': ''
			# 						'__VIEWSTATE': $('#__VIEWSTATE').val()
			# 						'__VIEWSTATEGENERATOR': $('#__VIEWSTATEGENERATOR').val()
			# 						'__VIEWSTATEENCRYPTED': $('#__VIEWSTATEENCRYPTED').val()
			# 						'__EVENTVALIDATION': $('#__EVENTVALIDATION').val()
			# 						'ctl00$ContentPlaceHolder1$txtSDate': date.format('YYYY/MM/DD')
			# 						'ctl00$ContentPlaceHolder1$ddlLocation': ddlLocation
			# 						'ctl00$ContentPlaceHolder1$btnSearch.x': 6
			# 						'ctl00$ContentPlaceHolder1$btnSearch.y': 19
			# 						'ctl00$ContentPlaceHolder1$gvIndex$ctl13$ddlPager': 1
			# 				}, (err, res, body) ->
			# 					$ = cheerio.load body
			# 					applying = $('#ctl00_ContentPlaceHolder1_lblPeople').text()
			# 					capacityStatus.push
			# 						'date': date.format()
			# 						'remaining': 92
			# 						'applying': applying
			# 					eachSerialFinished()
			# 				)
			# 		, (err) ->
			# 			if err then console.log err else cb null
			# 	)
		], (err, result) ->
			# console.log capacityStatus
			# console.log 'time: ' + moment().diff(timeStartCrawling, 'seconds') + 's'
			cbExports null, capacityStatus
		)

		parser = ($, done) ->
			async.parallel({
				remainings: (cb) ->
					remainings = []
					$(selectorRemaining).each (i) ->
						remainings.push capacity - $(this).text()
					cb null, remainings
				, applyings: (cb) ->
					applyings = []
					$('span.style14 font').each (i) ->
						applyings.push $(this).text()
					cb null, applyings
			}, (err, results) ->
				for remaining, i in results.remainings
					capacityStatus.push
						'date': moment().add(7 + capacityStatus.length, 'day').format()
						'remaining': remaining
						'applying': results.applyings[i]
				done()
			)



			
		
		
		




