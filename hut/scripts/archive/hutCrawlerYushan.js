// Generated by CoffeeScript 1.9.2
(function() {
  var async, capacity, capacityStatus, cheerio, ddlLocation, moment, parser, request, selectorRemaining, timeStartCrawling, urlAfterDraw, urlBeforeDraw;

  async = require('async');

  moment = require('moment');

  request = require('request');

  cheerio = require('cheerio');

  switch (1) {
    case 1:
      urlAfterDraw = 'https://mountain.ysnp.gov.tw/chinese/Location_Detail.aspx?pg=01&w=1&n=1005&s=1';
      urlBeforeDraw = 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003';
      selectorRemaining = 'span.style11 font';
      ddlLocation = 1;
      capacity = 92;
      break;
    case 2:
      urlAfterDraw = 'https://mountain.ysnp.gov.tw/chinese/Location_Detail.aspx?pg=01&w=1&n=1005&s=136';
      urlBeforeDraw = 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003';
      selectorRemaining = 'span.style11 font';
      ddlLocation = 136;
      break;
    case 3:
      urlAfterDraw = 'https://mountain.ysnp.gov.tw/chinese/Location_Detail.aspx?pg=01&w=1&n=1005&s=136';
      urlBeforeDraw = 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003';
      selectorRemaining = 'span.style12 font';
      ddlLocation = 136;
  }

  urlAfterDraw = 'https://mountain.ysnp.gov.tw/chinese/Location_Detail.aspx?pg=01&w=1&n=1005&s=1';

  urlBeforeDraw = 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003';

  timeStartCrawling = moment();

  capacityStatus = [];

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
    }, function(cb) {
      return async.eachSeries([0, 1, 2, 3, 4], function(itmes, eachSerialFinished) {
        return request(urlBeforeDraw, function(err, res, body) {
          var $, date;
          $ = cheerio.load(body);
          date = moment().add(7 + capacityStatus.length, 'd');
          return request({
            'method': 'POST',
            'url': urlBeforeDraw,
            'form': {
              'ctl00_ContentPlaceHolder1_ToolkitScriptManager1_HiddenField': '',
              '__EVENTTARGET': '',
              '__EVENTARGUMENT': '',
              '__VIEWSTATE': $('#__VIEWSTATE').val(),
              '__VIEWSTATEGENERATOR': $('#__VIEWSTATEGENERATOR').val(),
              '__VIEWSTATEENCRYPTED': $('#__VIEWSTATEENCRYPTED').val(),
              '__EVENTVALIDATION': $('#__EVENTVALIDATION').val(),
              'ctl00$ContentPlaceHolder1$txtSDate': date.format('YYYY/MM/DD'),
              'ctl00$ContentPlaceHolder1$ddlLocation': ddlLocation,
              'ctl00$ContentPlaceHolder1$btnSearch.x': 6,
              'ctl00$ContentPlaceHolder1$btnSearch.y': 19,
              'ctl00$ContentPlaceHolder1$gvIndex$ctl13$ddlPager': 1
            }
          }, function(err, res, body) {
            var applying;
            $ = cheerio.load(body);
            applying = $('#ctl00_ContentPlaceHolder1_lblPeople').text();
            capacityStatus.push({
              'date': date.format(),
              'remaining': capacity,
              'applying': applying,
              'isDrawn': false
            });
            return eachSerialFinished();
          });
        });
      }, function(err) {
        if (err) {
          return console.log(err);
        } else {
          return cb(null);
        }
      });
    }
  ], function(err, result) {
    console.log(capacityStatus);
    return console.log('time: ' + moment().diff(timeStartCrawling, 'seconds') + 's');
  });

  parser = function($, done) {
    var month, year, yearMonth;
    yearMonth = $('#ctl00_ContentPlaceHolder1_CalendarReport tr:first-child td:nth-child(2)').text();
    year = yearMonth.split('年')[0];
    month = yearMonth.split('年')[1].split('月')[0];
    $('#ctl00_ContentPlaceHolder1_CalendarReport tr').each(function(i) {
      if (i >= 3 && i <= 7) {
        return $(this).find('td > a').each(function(i) {
          var applying, dateDiff, registered, today;
          today = moment().year(year).month(month - 1).date($(this).text());
          dateDiff = today.diff(moment(), 'd');
          if (dateDiff >= 7 && dateDiff <= 30) {
            registered = $(this).parent('td').find(selectorRemaining).text();
            applying = $(this).parent('td').find('span.style14 font').text();
            return capacityStatus.push({
              'date': today.format(),
              'remaining': registered === '' ? 0 : capacity - registered,
              'applying': applying === '' ? 0 : applying,
              'isDrawn': true
            });
          }
        });
      }
    });
    return done();
  };

}).call(this);
