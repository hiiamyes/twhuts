var phantom = require('phantom');

phantom.create(function(ph) {
    var url = 'http://recreation.forest.gov.tw/personal/Personal_index.aspx';
    var urlHut = 'http://recreation.forest.gov.tw/askformonhouse/AskForPaperAddNew.aspx?mode=0&AskSID=&houseid=C';
    var urlJQ = 'https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js';
    var countOnLoadFinished = 0;
    ph.createPage(function(page) {
        page.open(url, function(status) {
            console.log("login page opened: ", status);
            page.evaluate(function() {
                document.getElementById('ContentPlaceHolder1_ID_TextBox').value = 'joshuayes@gmail.com';
                document.getElementById('ContentPlaceHolder1_Pass_TextBox').value = 'jojo782011';
                document.getElementById('ContentPlaceHolder1_login_button').click();
            });

            page.set('onLoadFinished', function(success) {
                console.log('onLoadFinished: ' + countOnLoadFinished);
                switch (countOnLoadFinished) {
                    case 0:
                        page.open(urlHut, function(status) {
                            page.includeJs(urlJQ, function() {
                                page.evaluate(function() {
                                    var huts = [];
                                    $('[id=eventscalendar_Label1_0]').each(function(i) {
                                        var day = $(this).parents().eq(1);
                                        // var date = new Date(new Date().getFullYear() + '-' + new Date().getMonth() + 1 + '-' + parseInt(day.find('.dayNumber').text()));
                                        var date = new Date();
                                        var remaining = day.find('#eventscalendar_Label1_0').html().split('<br>')[1].split(':')[1];
                                        var applying = day.find('#eventscalendar_Label1_0').html().split('<br>')[2].split(':')[1];
                                        huts.push({
                                            'date': date,
                                            'remaining': remaining,
                                            'applying': applying
                                        });
                                    });
                                    return huts;
                                }, function(huts) {
                                    console.log(huts);
                                    page.evaluate(function() {
                                        document.getElementById('eventscalendar_ctl00_NextMonth').click();
                                    });
                                });
                            });
                        });
                        break;
                    case 2:
                        page.includeJs(urlJQ, function() {
                            page.evaluate(function() {
                                var huts = [];
                                $('[id=eventscalendar_Label1_0]').each(function(i) {
                                    var day = $(this).parents().eq(1);
                                    var date = day.find('.dayNumber').text();
                                    var remaining = day.find('#eventscalendar_Label1_0').html().split('<br>')[1].split(':')[1];
                                    var applying = day.find('#eventscalendar_Label1_0').html().split('<br>')[2].split(':')[1];
                                    huts.push({
                                        'date': date,
                                        'remaining': remaining,
                                        'applying': applying
                                    });
                                    huts.push(date);
                                });
                                return huts;
                            }, function(huts) {
                                console.log(huts);
                                ph.exit()
                            });
                        });
                        break;
                }
                countOnLoadFinished++;

            });

        });
    });
});
