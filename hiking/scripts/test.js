var page = require('webpage').create();
page.open('http://permits2.taroko.gov.tw/2013_taroko/process.php?stype=%E6%9F%A5%E8%A9%A2%E5%B1%B1%E5%B1%8B%E7%8B%80%E6%85%8B&t=3H_tYpe&code=UTF8', function(status) {
    // console.log('status: ' + status);
    // if (status === "success") {
    //     page.render('example.png');
    // }
    // phantom.exit();
    page.evaluate(function() {
        var element = document.querySelector('#id');
        element.selectedIndex = 3;
        var event = document.createEvent('MouseEvents');
        event.initMouseEvent('onClick', true, true, window, 1, 0, 0);
        element.dispatchEvent(event);
    });

    // page.evaluate(function() {
    //     document.querySelector('#id').selectedIndex = 1;
    //     return true;
    // });


    page.render('gg.png');
});
