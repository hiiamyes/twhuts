async = require 'async'
jsdom = require 'jsdom'
moment = require 'moment'

collectionName = 'huts'
reCrawlTime = 1 * 60 * 60 * 1000; # 1hr
jsdomScripts = ['http://code.jquery.com/jquery.js']

module.exports = {
    crawl: (MongoClient, mongoServerUrl) ->
        do crawlOnce = () ->
            console.log 'huts crawling'
            dateCrawl = moment().format()

            MongoClient.connect mongoServerUrl, (err, db) ->
                huts = db.collection collectionName;
                huts.find().toArray (err, docs) ->
                    async.each(
                        docs
                        ,(hut) ->
                            jsdom.env(
                                hut.url
                                ,jsdomScripts
                                ,(err, window) ->
                                    $ = window.$
                                    capacityStatus = []
                                    switch hut.admin
                                        when '雪霸國家公園' then capacityStatus = sheiPaParser($)
                                        when '太魯閣國家公園' then capacityStatus = tarokoParser($)

                                    huts.updateOne(
                                        {'nameZh': hut.nameZh}  
                                        ,$set:
                                            'capacityStatuses':
                                                'dateCrawl': dateCrawl,
                                                'status': capacityStatus                                        
                                        ,(err, r) ->
                                            console.log if err isnt null then err else 'success crawling ' + hut.nameZh
                                    )
                            )                                   
                        ,(err) ->
                            console.log 'gg'
                    )

            setTimeout crawlOnce, reCrawlTime
}

sheiPaParser = ($) ->
    capacityStatus = []
    $('table.TABLE2 tr').each (i) ->
        if i>=2 and $(this).find('td:nth-child(1)').text() isnt ''
            capacityStatus.push
                'date': new Date($(this).find('td:nth-child(1)').text()),
                'remaining': $(this).find('td:nth-child(4)').text(),
                'applying': $(this).find('td:nth-child(5)').text(),
                'waiting': $(this).find('td:nth-child(6)').text()            
    capacityStatus

tarokoParser = ($) ->
    capacityStatus = []
    $('table tr').each (i) ->
        if i>=2
            applyingString = $(this).find('td:nth-child(2)').text();
            applying = if applyingString is '------' then 0 else applyingString.split('隊')[1].split('人')[0]
            capacityStatus.push
                'date': new Date($(this).find('td:nth-child(1)').text()),
                'remaining': $(this).find('td:nth-child(4)').text(),
                'applying': applying,
                'waiting': null            
    capacityStatus
