async = require 'async'
moment = require 'moment'
request = require 'request' # https://github.com/request/request
cheerio = require 'cheerio' # https://github.com/cheeriojs/cheerio

hutCrawlerTaiwanForestRecreation = require './hutCrawlerTaiwanForestRecreation.js'
hutCrawlerYushan = require './hutCrawlerYushan.js'
hutCrawlerTianchi = require './hutCrawlerTianchi.js'

reCrawlTime = 1 * 60 * 60 * 1000; # 1hr

module.exports = {
	crawl: (MongoClient, mongoServerUrl, collectionName) ->
		do crawlOnce = () ->
			console.log 'huts crawling start'            
			
			timeStartCrawling = moment()

			MongoClient.connect mongoServerUrl, (err, db) ->
				collection = db.collection collectionName;
				collection.find().toArray (err, docs) ->
					async.each(
						docs
						,(hut, cbAsync) ->
							async.waterfall([
								(cb) ->
									switch hut.admin
										when '台灣山林悠遊網' then hutCrawlerTaiwanForestRecreation.crawl hut, cb
										when '雪霸國家公園' then hutCrawlerSheiPa hut, cb
										when '太魯閣國家公園' then hutCrawlerTaroko hut, cb
										when '玉山國家公園' then hutCrawlerYushan.crawl hut, cb
										when '南投林區管理處' then hutCrawlerTianchi.crawl hut, cb
								,(capacityStatus, cb) ->
									if capacityStatus is []
										cb null, 'done'
									else
										collection.updateOne(
											{'nameZh': hut.nameZh}  
											,$set:
												'capacityStatuses':
													'dateCrawl': moment().format()
													'status': capacityStatus                                        
											,(err, r) ->
												console.log if err isnt null then err else 'success crawling ' + hut.nameZh
												cb null, 'done'                                           
										)
							], (err, result) ->
								console.log err if err?
								cbAsync()
							)
						,(err) ->
							console.log if err? then err else 'huts crawling done'
							console.log moment().format() + ': '+ moment().diff(timeStartCrawling, 'seconds') + 's'
					)
			setTimeout crawlOnce, reCrawlTime
}

hutCrawlerSheiPa = (hut, cb) ->
	request hut.url, (err, res, body) ->
		if err then cb 'fail crawling ' + hut.nameZh, null
		else if res.statusCode isnt 200 then cb 'fail crawling ' + hut.nameZh, null
		else    
			capacityStatus = []
			$ = cheerio.load body
			$('table.TABLE2 tr').each (i) ->
				if i >= 2 and $(this).find('td:nth-child(1)').text() isnt ''
					applying = parseInt($(this).find('td:nth-child(5)').text())
					waiting = parseInt($(this).find('td:nth-child(6)').text())
					capacityStatus.push
						'date': moment($(this).find('td:nth-child(1)').text(), 'YYYY-MM-DD').format()
						'remaining': $(this).find('td:nth-child(4)').text()
						'applying': applying + waiting
						'isDrawn': true
			cb null, capacityStatus

hutCrawlerTaroko = (hut, cb) ->
	request hut.url, (err, res, body) ->
		if err then cb 'fail crawling ' + hut.nameZh, null
		else if res.statusCode isnt 200 then cb 'fail crawling ' + hut.nameZh, null
		else
			capacityStatus = []
			$ = cheerio.load body
			$('table tr').each (i) ->
				if i > 7 && i < 33
					applyingString = $(this).find('td:nth-child(2)').text();
					applying = if applyingString is '------' then 0 else applyingString.split('隊')[1].split('人')[0]

					year = parseInt($(this).find('td:nth-child(1)').text().substring(0, 3)) + 1911
					month = $(this).find('td:nth-child(1)').text().substring(4, 6)
					day = $(this).find('td:nth-child(1)').text().substring(7, 9)

					capacityStatus.push
						'date': moment(year + ' ' + month + ' ' + day, 'YYYY MM DD').format()
						'remaining': $(this).find('td:nth-child(4)').text()
						'applying': applying
						'isDrawn': true
			cb null, capacityStatus

