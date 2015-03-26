var express = require('express');

var app = express();

app.set('view engine', 'jade');
app.set('views', __dirname + '/views');
app.use(express.static(__dirname + '/'));

//
app.get('/', function(req, res) {
    res.render('index');
})
app.get('/hiking', function(req, res) {
    res.render('hiking');
})
app.get('/', function(req, res) {
    res.render('index');
})

//
var port = Number(process.env.PORT || 8080);
app.listen(port, function() {
    console.log("Listening on " + port);
});
