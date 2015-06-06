// Generated by CoffeeScript 1.9.2
(function() {
  var async, cheerio, moment, request;

  async = require('async');

  moment = require('moment');

  request = require('request');

  cheerio = require('cheerio');

  module.exports = {
    crawl: function(hut, cbExports) {
      var capacity, capacityStatus, ddlLocation, parser, selectorRemaining, urlAfterDraw, urlBeforeDraw;
      capacityStatus = [];
      capacity = hut.capacity;
      urlAfterDraw = '';
      urlBeforeDraw = '';
      selectorRemaining = '';
      ddlLocation = 0;
      switch (hut.nameZh) {
        case '排雲山莊':
          urlAfterDraw = 'https://mountain.ysnp.gov.tw/chinese/Location_Detail.aspx?pg=01&w=1&n=1005&s=1';
          urlBeforeDraw = 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003';
          selectorRemaining = 'span.style11 font';
          ddlLocation = 1;
          break;
        case '圓峰山屋':
          urlAfterDraw = 'https://mountain.ysnp.gov.tw/chinese/Location_Detail.aspx?pg=01&w=1&n=1005&s=136';
          urlBeforeDraw = 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003';
          selectorRemaining = 'span.style11 font';
          ddlLocation = 2;
          break;
        case '圓峰營地':
          urlAfterDraw = 'https://mountain.ysnp.gov.tw/chinese/Location_Detail.aspx?pg=01&w=1&n=1005&s=136';
          urlBeforeDraw = 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003';
          selectorRemaining = 'span.style12 font';
          ddlLocation = 2;
      }
      async.waterfall([
        function(cb) {
          return request(urlAfterDraw, function(err, res, body) {
            var $;
            $ = cheerio.load(body);
            return parser($, function() {
              return cb(null, $);
            });
          });
        }, function($, cb) {
          return request({
            'method': 'POST',
            'url': urlAfterDraw,
            'form': {
              '__EVENTTARGET': 'ctl00$ContentPlaceHolder1$CalendarReport',
              '__EVENTARGUMENT': $('table#ctl00_ContentPlaceHolder1_CalendarReport table tr td:nth-child(3) a').attr('href').substring(68, 68 + 5),
              '__VIEWSTATE': $('#__VIEWSTATE').val(),
              '__VIEWSTATEGENERATOR': $('#__VIEWSTATEGENERATOR').val(),
              '__EVENTVALIDATION': $('#__EVENTVALIDATION').val()
            }
          }, function(err, res, body) {
            return parser(cheerio.load(body), function() {
              return cb(null);
            });
          });
        }
      ], function(err, result) {
        return cbExports(null, capacityStatus);
      });
      return parser = function($, done) {
        var dateEnd, dateStart;
        dateStart = moment().add(7, 'day');
        dateEnd = moment().add(28, 'day');
        return async.parallel({
          remainings: function(cb) {
            var date, month, remainings, year, yearMonth;
            remainings = [];
            date = moment();
            yearMonth = $('#ctl00_ContentPlaceHolder1_CalendarReport tr:first-child td:nth-child(2)').text();
            year = yearMonth.split('年')[0];
            month = yearMonth.split('年')[1].split('月')[0];
            $('#ctl00_ContentPlaceHolder1_CalendarReport tr').each(function(i) {
              if (i >= 3 && i <= 7) {
                return $(this).find('td > a').each(function(i) {
                  var registered;
                  date = moment(year + ' ' + month + ' ' + $(this).text(), 'YYYY MM DD');
                  if (date.diff(dateStart, 'day') >= 0 && date.diff(dateEnd, 'day') <= 0) {
                    registered = $(this).parent('td').find(selectorRemaining).text();
                    if (registered === '') {
                      registered = 92;
                    }
                    return remainings.push(capacity - registered);
                  }
                });
              }
            });
            return cb(null, remainings);
          }
        }, function(err, results) {
          var i, j, len, ref, remaining;
          ref = results.remainings;
          for (i = j = 0, len = ref.length; j < len; i = ++j) {
            remaining = ref[i];
            capacityStatus.push({
              'date': moment().add(7 + capacityStatus.length, 'day').format(),
              'remaining': remaining
            });
          }
          return done();
        });
      };
    }
  };

}).call(this);
