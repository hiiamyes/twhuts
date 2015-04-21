// express
var express = require('express');
var app = express();
app.set('view engine', 'jade');
app.set('views', __dirname + '/');
app.use(express.static(__dirname + '/'));

// db
var MongoClient = require('mongodb').MongoClient;
var mongoServerUrl = 'mongodb://yes:yes@ds035280.mongolab.com:35280/hiking';

// crawler
var crawler = require('./hiking/scripts/crawler.js');
crawler.crawl(MongoClient, mongoServerUrl);

// routing
app.get('/', function(req, res) {
    res.render('index');
})
app.get('/hiking', function(req, res) {
    res.render('hiking/views/index');
})

// api
app.get('/api/hut', function(req, res) {
    MongoClient.connect(mongoServerUrl, function(err, db) {
        db.collection('huts').find().toArray(function(err, docs) {
            res.send(docs);
        });
    });
});

// porting
var port = Number(process.env.PORT || 8080);
app.listen(port, function() {
    console.log("Listening on " + port);
});
