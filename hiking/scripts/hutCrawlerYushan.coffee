async = require 'async'
moment = require 'moment'
request = require 'request' # https://github.com/request/request
cheerio = require 'cheerio' # https://github.com/cheeriojs/cheerio

url = 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003'

timeStartCrawling = moment()

async.map(
	[7..10]
	, (item, cb) ->
		request url, (err, res, body) ->
			# console.log res.statusCode
			cookie = res.headers['set-cookie'][0].split(';')[0]
			$ = cheerio.load body

			date = moment().add(item,'d').format('YYYY/MM/DD')

			request({
				'method': 'POST'
				'url': url
				'headers':
					'Cookie': cookie
				'form':
					'ctl00_ContentPlaceHolder1_ToolkitScriptManager1_HiddenField': ''			
					'__EVENTTARGET': 'ctl00$ContentPlaceHolder1$gvIndex$ctl13$txtPageSize'
					'__EVENTARGUMENT': ''
					'__VIEWSTATE': $('#__VIEWSTATE').val()
					'__VIEWSTATEGENERATOR': $('#__VIEWSTATEGENERATOR').val()
					'__VIEWSTATEENCRYPTED': $('#__VIEWSTATEENCRYPTED').val()
					'__EVENTVALIDATION': $('#__EVENTVALIDATION').val()
					'ctl00$ContentPlaceHolder1$txtSDate': date
					'ctl00$ContentPlaceHolder1$ddlLocation': 1
					'ctl00$ContentPlaceHolder1$btnSearch.x': 6
					'ctl00$ContentPlaceHolder1$btnSearch.y': 19
					'ctl00$ContentPlaceHolder1$gvIndex$ctl13$ddlPager': 1
					'ctl00$ContentPlaceHolder1$gvIndex$ctl13$txtPageSize': 100
			}, (err, res, body) ->
				# console.log res.statusCode
				$ = cheerio.load body

				# calculate the applying status
				# ref: https://mountain.ysnp.gov.tw/chinese/CP_how_Paiyun_LazyPack.aspx?pg=03&w=1&n=3007                    
				remaining = 92
				applying = 0
				waiting = 0
				$('table#ctl00_ContentPlaceHolder1_gvIndex table.text_12pt tr').each (i) ->
					if i > 0
						nPeople = parseInt($(this).find('td:nth-child(5) span').text())
						status = $(this).find('td:nth-child(9) div').text()
						if status.indexOf('核准入園') isnt -1 then remaining-=nPeople
						else if status.indexOf('排隊預約') isnt -1 or status.indexOf('備取') isnt -1 then waiting+=nPeople
						else applying+=nPeople

				cb null, remaining + '/' + applying + '/' + waiting
			)
	, (err, results) ->
		console.log results
		console.log 'time: ' + moment().diff(timeStartCrawling, 'seconds') + 's'
)

