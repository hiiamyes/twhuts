var express = require("express");
var app = express();
var router = express.Router();

var exec = require("child_process").exec;

var fs = require('fs');

app.use(express.static(__dirname + "/app"));

// app.get('/', function(req, res){
//   res.sendfile(__dirname+'/views/index.html');    
// });

router.get('/', function(req, res) {
    res.sendfile(__dirname + '/app/views/index.html');
});

router.get('/yes', function(req, res) {
    res.sendfile(__dirname + '/app/views/yes.html');
});

router.get('/api/reply', function(req, res) {
    var question = req.query['question'];
    console.log('question = ' + question);
    exec('ruby findEye.rb ' + question, function(err, stdout, stderr) {
        if (err) {
            console.log('server err = ' + err + ', stderr = ' + stderr);
            res.status(404).send('server err');
        } else {
            console.log('success');
            console.log('stdout = \n' + stdout);

            var replys = stdout.split('\n');
            var reply = {};
            reply['words'] = replys[0];
            reply['song_name'] = replys[1];
            reply['sentence'] = replys[2];            
            reply['youtube_url'] = replys[3];            
            reply['youtube_embed_url'] = 'http://www.youtube.com/embed/' + replys[3].split('v=')[1];

            console.log('reply =');
            console.log(reply);
            res.send(reply);

        };
    });
});

router.get('/api/doc',function(req, res){
    res.sendfile(__dirname+'/app/views/apidoc.html');
});

function getFileExtension(filename) {
    var i = filename.lastIndexOf('.');
    return (i < 0) ? '' : filename.substr(i + 1);
}


app.use('/', router);


var port = Number(process.env.PORT || 8080);
app.listen(port, function() {
    console.log("Listening on " + port);
});