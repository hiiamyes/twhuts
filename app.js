var express = require('express');
var app = express();
app.set('view engine', 'jade');
app.set('views', __dirname + '/');
app.use(express.static(__dirname + '/'));


var jsdom = require('jsdom');


//
app.get('/', function(req, res) {
    res.render('index');
})
app.get('/hiking', function(req, res) {
    res.render('hiking/views/index');
})

//
app.get('/api/hut', function(req, res) {
    jsdom.env(
        'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=4', ["http://code.jquery.com/jquery.js"],
        function(errors, window) {
            var huts = [];
            var $ = window.$;
            $("table.TABLE2 tr").each(function(i) {
                if (i >= 2 && i <= 23) {
                    huts.push({
                        'date': new Date($(this).find('td:nth-child(1)').text()),
                        'remaining': $(this).find('td:nth-child(4)').text()
                    });
                };
            });
            res.send(huts);
        }
    );
});



//
var port = Number(process.env.PORT || 8080);
app.listen(port, function() {
    console.log("Listening on " + port);
});
