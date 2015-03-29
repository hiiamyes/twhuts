var express = require('express');
var app = express();
app.set('view engine', 'jade');
app.set('views', __dirname + '/');
app.use(express.static(__dirname + '/'));

var async = require('async');

var jsdom = require('jsdom');

// db
var MongoClient = require('mongodb').MongoClient;
var mongoServerUrl = 'mongodb://yes:yes@ds035280.mongolab.com:35280/hiking';

// 
MongoClient.connect(mongoServerUrl, function(err, db) {

    var huts = db.collection('huts');

    huts.find().toArray(function(err, docs) {
        async.each(docs, function(hut) {
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
        }, function(err) {
            if (err) {
                console.log('A file failed to process');
            } else {
                console.log('All files have been processed successfully');
            }
        });
    });
});

//
app.get('/', function(req, res) {
    res.render('index');
})
app.get('/hiking', function(req, res) {
    res.render('hiking/views/index');
})

app.get('/api/hut', function(req, res) {
    MongoClient.connect(mongoServerUrl, function(err, db) {
        db.collection('huts').find().toArray(function(err, docs) {
            res.send(docs);
        });
    });
    // jsdom.env(
    //     'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=4', ["http://code.jquery.com/jquery.js"],
    //     function(errors, window) {
    //         var huts = [];
    //         var $ = window.$;
    //         $("table.TABLE2 tr").each(function(i) {
    //             if (i >= 2 && $(this).find('td:nth-child(1)').text() != null) {
    //                 huts.push({
    //                     'date': new Date($(this).find('td:nth-child(1)').text()),
    //                     'remaining': $(this).find('td:nth-child(4)').text()
    //                 });
    //             };
    //         });
    //         res.send(huts);
    //     }
    // );
});

//
var port = Number(process.env.PORT || 8080);
app.listen(port, function() {
    console.log("Listening on " + port);
});

// setInterval(function() {
//     console.log('gg');
// }, 1000);
