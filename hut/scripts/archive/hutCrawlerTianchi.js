// Generated by CoffeeScript 1.9.2
(function() {
  var async, cheerio, moment, parser, request;

  async = require('async');

  moment = require('moment');

  request = require('request');

  cheerio = require('cheerio');

  parser = function(date, cb) {
    var capacityStatus, day, month, url, year;
    capacityStatus = [];
    year = date.year();
    month = ('0' + (date.month() + 1)).slice(-2);
    day = date.date();
    url = 'http://tconline.forest.gov.tw/order/?year=' + year + '&month=' + month;
    return request(url, function(err, res, body) {
      var $;
      $ = cheerio.load(body);
      $('.in_calendar_date').each(function(i) {
        var applying, remaining, status;
        status = $(this).closest('table').find('td').eq(1).text();
        if (status.indexOf('剩餘床位') === -1) {
          return capacityStatus.push({
            'date': moment().year(year).month(date.month()).date(i + 1).format(),
            'remaining': 0,
            'applying': 0
          });
        } else {
          remaining = $(this).closest('table').find('td').eq(1).text().split('剩餘床位:')[1].split('目前報名')[0];
          applying = $(this).closest('table').find('td').eq(1).text().split('目前報名:')[1];
          return capacityStatus.push({
            'date': moment().year(year).month(month - 1).date(i + 1).format(),
            'remaining': remaining,
            'applying': applying
          });
        }
      });
      return cb(null, capacityStatus);
    });
  };

  async.parallel({
    thisMonth: function(cb) {
      var date;
      date = moment().add(7, 'd');
      return parser(date, cb);
    },
    nextMonth: function(cb) {
      var date;
      date = moment().add(7, 'd').add(1, 'M');
      return parser(date, cb);
    },
    thirdMonth: function(cb) {
      var date;
      date = moment().add(7, 'd').add(2, 'M');
      return parser(date, cb);
    }
  }, function(err, results) {
    var capacityStatus, dateDiff, j, k, l, len, len1, len2, ref, ref1, ref2, result;
    capacityStatus = [];
    ref = results.thisMonth;
    for (j = 0, len = ref.length; j < len; j++) {
      result = ref[j];
      dateDiff = moment(result.date).diff(moment(), 'd');
      if (dateDiff >= 6 && dateDiff <= 44) {
        capacityStatus.push(result);
      }
    }
    ref1 = results.nextMonth;
    for (k = 0, len1 = ref1.length; k < len1; k++) {
      result = ref1[k];
      dateDiff = moment(result.date).diff(moment(), 'd');
      if (dateDiff >= 6 && dateDiff <= 44) {
        capacityStatus.push(result);
      }
    }
    ref2 = results.thirdMonth;
    for (l = 0, len2 = ref2.length; l < len2; l++) {
      result = ref2[l];
      dateDiff = moment(result.date).diff(moment(), 'd');
      if (dateDiff >= 6 && dateDiff <= 44) {
        capacityStatus.push(result);
      }
    }
    return console.log(capacityStatus);
  });

}).call(this);
