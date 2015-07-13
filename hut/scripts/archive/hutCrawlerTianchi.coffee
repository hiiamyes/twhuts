async = require 'async'
moment = require 'moment'
request = require 'request' # https://github.com/request/request
cheerio = require 'cheerio' # https://github.com/cheeriojs/cheerio

timeStartCrawling = moment()

parser = (date, cb) ->
	capacityStatus = []
	
	year = date.year()
	month = ('0' + (date.month() + 1)).slice(-2)
	url = 'http://tconline.forest.gov.tw/order/?year=' + year + '&month=' + month

	request url, (err, res, body) ->
		if err then cb 'fail'
		else
			$ = cheerio.load body
			$('.in_calendar_date').each (i) ->
				
				status = $(this).closest('table').find('td').eq(1).clone()
				status.find('br').replaceWith(',')
				status = status.text().split(',')

				remaining = parseInt status[0].split(':')[1]
				
				today = moment().year(year).month(date.month()).date(i+1)
				dateDiff = today.diff(moment(),'d')

				if dateDiff >= 7 and dateDiff <= 45
					# Check the availability first by remaining
					if !Number.isInteger(remaining) 
						capacityStatus.push
							'date': today.format()
							'remaining': 0
							'applying': 0
							'isDrawn': dateDiff <= 29
					else
						applying = parseInt status[1].split(':')[1]
						isDrawn = status[2]
				
						capacityStatus.push 
							'date': today.format()
							'remaining': remaining
							'applying': applying
							'isDrawn': isDrawn is '已抽名單'
			cb null, capacityStatus

async.parallel({
	thisMonth: (cb) ->
		date = moment().add(7,'d')
		parser date, cb
	,nextMonth: (cb) ->
		date = moment().add(7,'d').add(1,'M')
		parser date, cb
	,thirdMonth: (cb) ->
		date = moment().add(7,'d').add(2,'M')
		parser date, cb
}, (err, results) ->
	if err then console.log 'fail crawling: 天池山莊'
	else
		capacityStatus = []
		capacityStatus.push result for result in results.thisMonth
		capacityStatus.push result for result in results.nextMonth
		capacityStatus.push result for result in results.thirdMonth
		console.log capacityStatus

	console.log 'time: ' + moment().diff(timeStartCrawling, 'seconds') + 's'
)	




