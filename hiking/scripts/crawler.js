var async = require('async');
var jsdom = require('jsdom');

var RECRAWLTIME = 1 * 60 * 1000; // 1min

module.exports = {
    crawl: function(MongoClient, mongoServerUrl) {
        var crawlOnce = function() {
            console.log('gg crawler is starting');
            MongoClient.connect(mongoServerUrl, function(err, db) {
                var huts = db.collection('huts');
                huts.find().toArray(function(err, docs) {
                    async.each(docs, function(hut) {
                        if (hut.admin == '雪霸國家公園') {
                            jsdom.env(
                                hut.url, ["http://code.jquery.com/jquery.js"],
                                function(errors, window) {
                                    var hutStatus = [];
                                    var $ = window.$;
                                    $("table.TABLE2 tr").each(function(i) {
                                        if (i >= 2 && $(this).find('td:nth-child(1)').text() != '') {
                                            hutStatus.push({
                                                'date': new Date($(this).find('td:nth-child(1)').text()),
                                                'remaining': $(this).find('td:nth-child(4)').text()
                                            });
                                        };
                                    });

                                    huts.updateOne({
                                        'nameZh': hut.nameZh
                                    }, {
                                        $set: {
                                            'status': hutStatus
                                        }
                                    }, function(err, r) {
                                        if (err == null) {
                                            console.log('success');
                                        } else {
                                            console.log(err);
                                        };
                                    });
                                }
                            );
                        } else if (hut.admin == '太魯閣國家公園') {
                            jsdom.env(
                                hut.url, ["http://code.jquery.com/jquery.js"],
                                function(errors, window) {
                                    var hutStatus = [];
                                    var $ = window.$;
                                    $("table tr").each(function(i) {
                                        if (i >= 2) {
                                            hutStatus.push({
                                                'date': new Date($(this).find('td:nth-child(1)').text()),
                                                'remaining': $(this).find('td:nth-child(4)').text()
                                            });
                                        };
                                    });

                                    huts.updateOne({
                                        'nameZh': hut.nameZh
                                    }, {
                                        $set: {
                                            'status': hutStatus
                                        }
                                    }, function(err, r) {
                                        if (err == null) {
                                            console.log('success');
                                        } else {
                                            console.log(err);
                                        };
                                    });
                                }
                            );
                        };
                    }, function(err) {
                        if (err) {
                            console.log('A file failed to process');
                        } else {
                            console.log('All files have been processed successfully');
                        }
                    });
                });
            });
        }
        setTimeout(crawlOnce, RECRAWLTIME);
        crawlOnce();
    }
};
