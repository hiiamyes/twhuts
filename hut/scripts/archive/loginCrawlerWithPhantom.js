var page = require('webpage').create();
var url = 'http://recreation.forest.gov.tw/personal/Personal_index.aspx';
var urlHut = 'http://recreation.forest.gov.tw/askformonhouse/AskForPaperAddNew.aspx?mode=0&AskSID=&houseid=C';

var isLoginFinished = false;

page.open(url, function(status) {
    page.evaluate(function() {
        document.getElementById('ContentPlaceHolder1_ID_TextBox').value = 'joshuayes@gmail.com';
        document.getElementById('ContentPlaceHolder1_Pass_TextBox').value = 'jojo782011';
        document.getElementById('ContentPlaceHolder1_login_button').click();
    });

    page.onLoadFinished = function() {
        if (!isLoginFinished) {
            page.open(urlHut, function(status) {
                page.includeJs('https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js', function() {
                    var resultCrawled = page.evaluate(function() {
                        return $('#eventscalendar_ctl00_label2').text();
                    });
                    console.log('resultCrawled: ' + resultCrawled);
                    phantom.exit()
                });
            });
        }
        isLoginFinished = true;
    };

});
