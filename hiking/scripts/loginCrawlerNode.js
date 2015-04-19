var phantom = require('phantom');

phantom.create(function(ph) {
    var url = 'http://recreation.forest.gov.tw/personal/Personal_index.aspx';
    var urlHut = 'http://recreation.forest.gov.tw/askformonhouse/AskForPaperAddNew.aspx?mode=0&AskSID=&houseid=C';
    var urlJQ = 'https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js';
    var isLoginFinished = false;
    ph.createPage(function(page) {
        page.open(url, function(status) {
            console.log("login page opened: ", status);
            page.evaluate(function() {
                document.getElementById('ContentPlaceHolder1_ID_TextBox').value = 'joshuayes@gmail.com';
                document.getElementById('ContentPlaceHolder1_Pass_TextBox').value = 'jojo782011';
                document.getElementById('ContentPlaceHolder1_login_button').click();
            });

            page.set('onLoadFinished', function(success) {
                if (!isLoginFinished) {
                    page.open(urlHut, function(status) {
                        page.includeJs(urlJQ, function() {
                            page.evaluate(function() {
                                return $('#eventscalendar_ctl00_label2').text();
                            }, function(result) {
                                console.log('result: ' + result);
                                ph.exit()
                            });
                        });
                    });
                }
                isLoginFinished = true;
            });
        });
    });
});
