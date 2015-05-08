async = require 'async'
moment = require 'moment'
request = require 'request' # https://github.com/request/request
cheerio = require 'cheerio' # https://github.com/cheeriojs/cheerio

console.log moment().add(7, 'd').format()

url = 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003'

request url, (err, res, body) ->
	# console.log res.statusCode
	cookie = res.headers['set-cookie'][0].split(';')[0]
	$ = cheerio.load body

	a = request({
		'method': 'POST'
		'url': url
		'headers':
			'Cookie': cookie
		'form':
			'ctl00_ContentPlaceHolder1_ToolkitScriptManager1_HiddenField': ''
			# '__EVENTTARGET': $('#__EVENTTARGET').val()
			'__EVENTTARGET': 'ctl00$ContentPlaceHolder1$gvIndex$ctl13$txtPageSize'
			'__EVENTARGUMENT': $('#__EVENTARGUMENT').val()
			'__VIEWSTATE': $('#__VIEWSTATE').val()
			'__VIEWSTATEGENERATOR': $('#__VIEWSTATEGENERATOR').val()
			'__VIEWSTATEENCRYPTED': $('#__VIEWSTATEENCRYPTED').val()
			'__EVENTVALIDATION': $('#__EVENTVALIDATION').val()
			'ctl00$ContentPlaceHolder1$txtSDate': '2015/05/16'
			'ctl00$ContentPlaceHolder1$ddlLocation': 1
			'ctl00$ContentPlaceHolder1$btnSearch.x': 32
			'ctl00$ContentPlaceHolder1$btnSearch.y': 5
			'ctl00$ContentPlaceHolder1$gvIndex$ctl23$txtPageSize': 50
	}, (err, res, body) ->
		console.log res.statusCode
		# console.log res.headers
		$ = cheerio.load body
		# console.log $('#ctl00_ContentPlaceHolder1_divRemark').length
		# console.log $('#ctl00_ContentPlaceHolder1_lblDay').text()
		console.log $('#ctl00_ContentPlaceHolder1_gvIndex tr').length - 3
	)

# async.waterfall([
# 	(cb) ->
# 		request 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003', (err, res, body) ->
# 			console.log res.statusCode
# 			console.log res.headers
# 			$ = cheerio.load body
# 			cb null, $('#__VIEWSTATE').val(), $('#__EVENTVALIDATION').val()
# 	,(viewstate, eventvalidation, cb) ->
# 		request(
# 			{
# 				'method': 'POST'
# 				'url': 'http://recreation.forest.gov.tw/index.aspx'
# 				'headers':
# 					'Connection': 'keep-alive'
# 				'form':
# 					'__VIEWSTATE': viewstate
# 					'__EVENTVALIDATION': eventvalidation
# 					'ctl00$ContentPlaceHolder1$ID_TextBox': 'hut.crawler.tw@gmail.com'
# 					'ctl00$ContentPlaceHolder1$Pass_TextBox': 'iamahutcrawler1'
# 					'ctl00$ContentPlaceHolder1$btn_login': '登入'
# 			}, (err, res, body) ->
# 				# console.log res.statusCode
# 				cookie = res.headers['set-cookie'][0].split(';')[0]
# 				cb null, cookie
# 		)
# 	,(cookie, cb) ->
# 		request(
# 			{
# 				'url': url
# 				'headers':
# 					'Connection': 'keep-alive'
# 					'Cookie': cookie
# 			}, (err, res, body) ->
# 				# console.log res.statusCode
# 				$ThisMonth = cheerio.load body
# 				cb null, cookie, $ThisMonth, $ThisMonth('#__VIEWSTATE').val(), $ThisMonth('#__EVENTVALIDATION').val()
# 		)
# 	,(cookie, $ThisMonth, viewstate, eventvalidation, cb) ->
# 		request(
# 			{
# 				'method': 'POST'
# 				'url': 'http://recreation.forest.gov.tw/askformonhouse/AskForPaperAddNew.aspx?mode=0&AskSID=&houseid=C'
# 				'headers':
# 					'Cookie': cookie
# 				'form':
# 					'__VIEWSTATE': viewstate
# 					'__EVENTVALIDATION': eventvalidation
# 					'__EVENTTARGET': 'eventscalendar$ctl00$NextMonth'
# 					'__VIEWSTATEENCRYPTED': ''
# 			}, (err, res, body) ->
# 				console.log res.statusCode
# 				$NextMonth = cheerio.load body
# 				capacityStatus = parser $ThisMonth, $NextMonth
# 				cb null, 'done'
# 		)
# ], (err, result) ->
# 	console.log result
# 	cb null, capacityStatus
# )
# 			