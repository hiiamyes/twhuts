async = require 'async'
moment = require 'moment'
request = require 'request' # https://github.com/request/request
cheerio = require 'cheerio' # https://github.com/cheeriojs/cheerio

parser = (date, cb) ->
	capacityStatus = []
	year = date.year()
	month = ('0' + (date.month() + 1)).slice(-2)
	day = date.date()
	url = 'http://tconline.forest.gov.tw/order/?year=' + year + '&month=' + month
	request url, (err, res, body) ->
		$ = cheerio.load body
		$('.in_calendar_date').each (i) ->
			status = $(this).closest('table').find('td').eq(1).text()
			if status.indexOf('剩餘床位') is -1 
				capacityStatus.push
					'date': moment().year(year).month(date.month()).date(i+1).format()
					'remaining': 0
					'applying': 0
			else
				remaining = $(this).closest('table').find('td').eq(1).text().split('剩餘床位:')[1].split('目前報名')[0]
				applying = $(this).closest('table').find('td').eq(1).text().split('目前報名:')[1]
				capacityStatus.push 
					'date': moment().year(year).month(month-1).date(i+1).format()
					'remaining': remaining
					'applying': applying
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
	capacityStatus = []
	for result in results.thisMonth
		dateDiff = moment(result.date).diff(moment(),'d')
		if dateDiff >= 6 and dateDiff <= 44 then capacityStatus.push result
	for result in results.nextMonth
		dateDiff = moment(result.date).diff(moment(),'d')
		if dateDiff >= 6 and dateDiff <= 44 then capacityStatus.push result
	for result in results.thirdMonth
		dateDiff = moment(result.date).diff(moment(),'d')
		if dateDiff >= 6 and dateDiff <= 44 then capacityStatus.push result
	console.log capacityStatus
)




