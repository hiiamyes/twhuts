async = require 'async'
jsdom = require 'jsdom'
jsdomScripts = ['http://code.jquery.com/jquery.js']

module.exports = {
    fire: () ->
        console.log 'comic crawling'

        for 2...190
            url = 'http://8yyls.com/47502/' + 
            jsdom.env(
                url
                ,jsdomScripts
                ,(err, window) ->
                    window.$('img.imagesizer alignnone size-full wp-image-87').



            )
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
}