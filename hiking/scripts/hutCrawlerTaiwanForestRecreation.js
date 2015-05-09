// Generated by CoffeeScript 1.9.2
(function() {
  var async, cheerio, moment, parser, push, request;

  async = require('async');

  moment = require('moment');

  request = require('request');

  cheerio = require('cheerio');

  module.exports = {
    crawl: function(url, cb) {
      var capacityStatus;
      capacityStatus = [];
      return async.waterfall([
        function(cb) {
          return request('http://recreation.forest.gov.tw/index.aspx', function(err, res, body) {
            var $;
            $ = cheerio.load(body);
            return cb(null, $('#__VIEWSTATE').val(), $('#__EVENTVALIDATION').val());
          });
        }, function(viewstate, eventvalidation, cb) {
          return request({
            'method': 'POST',
            'url': 'http://recreation.forest.gov.tw/index.aspx',
            'headers': {
              'Connection': 'keep-alive'
            },
            'form': {
              '__VIEWSTATE': viewstate,
              '__EVENTVALIDATION': eventvalidation,
              'ctl00$ContentPlaceHolder1$ID_TextBox': 'hut.crawler.tw@gmail.com',
              'ctl00$ContentPlaceHolder1$Pass_TextBox': 'iamahutcrawler1',
              'ctl00$ContentPlaceHolder1$btn_login': '登入'
            }
          }, function(err, res, body) {
            var cookie;
            cookie = res.headers['set-cookie'][0].split(';')[0];
            return cb(null, cookie);
          });
        }, function(cookie, cb) {
          return request({
            'url': url,
            'headers': {
              'Connection': 'keep-alive',
              'Cookie': cookie
            }
          }, function(err, res, body) {
            var $ThisMonth;
            $ThisMonth = cheerio.load(body);
            return cb(null, cookie, $ThisMonth, $ThisMonth('#__VIEWSTATE').val(), $ThisMonth('#__EVENTVALIDATION').val());
          });
        }, function(cookie, $ThisMonth, viewstate, eventvalidation, cb) {
          return request({
            'method': 'POST',
            'url': url,
            'headers': {
              'Cookie': cookie
            },
            'form': {
              '__VIEWSTATE': viewstate,
              '__EVENTVALIDATION': eventvalidation,
              '__EVENTTARGET': 'eventscalendar$ctl00$NextMonth',
              '__VIEWSTATEENCRYPTED': ''
            }
          }, function(err, res, body) {
            var $NextMonth;
            $NextMonth = cheerio.load(body);
            capacityStatus = parser($ThisMonth, $NextMonth);
            return cb(null, 'done');
          });
        }
      ], function(err, result) {
        return cb(null, capacityStatus);
      });
    }
  };

  parser = function($ThisMonth, $NextMonth) {
    var capacityStatus, dayCheck, dayPre, month, monthCheck, monthThisMonth, monthZHThisMonth, pass;
    monthZHThisMonth = $ThisMonth('#eventscalendar_ctl00_label2').text().split(' ')[0];
    monthThisMonth = 0;
    switch (monthZHThisMonth) {
      case '一月':
        monthThisMonth = 1;
        break;
      case '二月':
        monthThisMonth = 2;
        break;
      case '三月':
        monthThisMonth = 3;
        break;
      case '四月':
        monthThisMonth = 4;
        break;
      case '五月':
        monthThisMonth = 5;
        break;
      case '六月':
        monthThisMonth = 6;
        break;
      case '七月':
        monthThisMonth = 7;
        break;
      case '八月':
        monthThisMonth = 8;
        break;
      case '九月':
        monthThisMonth = 9;
        break;
      case '十月':
        monthThisMonth = 10;
        break;
      case '十一月':
        monthThisMonth = 11;
        break;
      case '十二月':
        monthThisMonth = 12;
    }
    capacityStatus = [];
    dayPre = 0;
    month = monthThisMonth;
    $ThisMonth('.dayNumber').each(function(i) {
      var day;
      day = parseInt($ThisMonth(this).text());
      if (i === 0 && day !== 1) {
        month--;
      } else {
        if (day < dayPre) {
          month++;
        }
      }
      dayPre = day;
      return push(capacityStatus, $ThisMonth(this), month, day);
    });
    monthCheck = month;
    dayCheck = dayPre;
    month = monthThisMonth + 1;
    pass = false;
    $NextMonth('.dayNumber').each(function(i) {
      var day;
      day = parseInt($NextMonth(this).text());
      if (i === 0 && day !== 1) {
        month--;
      } else {
        if (day < dayPre) {
          month++;
        }
      }
      dayPre = day;
      if (!pass && month === monthCheck && day === dayCheck) {
        return pass = true;
      } else if (pass) {
        return push(capacityStatus, $NextMonth(this), month, day);
      }
    });
    return capacityStatus;
  };

  push = function(capacityStatus, ele, month, day) {
    var applying, date, e, remaining;
    if (ele.parent().children().length > 1) {
      date = moment().month(month - 1).date(day).format();
      try {
        remaining = ele.parent().find('#eventscalendar_Label1_0').html().split('<br>')[1].split(':')[1];
        applying = ele.parent().find('#eventscalendar_Label1_0').html().split('<br>')[2].split(':')[1];
        return capacityStatus.push({
          'date': date,
          'remaining': remaining,
          'applying': applying,
          'waiting': null
        });
      } catch (_error) {
        e = _error;
        return capacityStatus.push({
          'date': date,
          'remaining': 0,
          'applying': 0,
          'waiting': null
        });
      }
    }
  };

}).call(this);