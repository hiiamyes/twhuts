// Generated by CoffeeScript 1.9.2
(function() {
  var app;

  app = angular.module('hutCrawler', ['ngRoute']);

  app.config([
    '$routeProvider', function($routeProvider) {
      return $routeProvider.when('/huts', {
        templateUrl: 'views/huts'
      }).when('/about', {
        templateUrl: 'views/about'
      }).when('/question', {
        templateUrl: 'views/question'
      }).when('/contact', {
        templateUrl: 'views/contact'
      }).otherwise({
        redirectTo: '/huts'
      });
    }
  ]);

  app.controller('hutCrawlerCtrl', [
    '$scope', '$http', function($scope, $http) {
      $scope.ggData = [];
      $scope.isLoading = true;
      $scope.hutGroups = [];
      $scope.topBarHutNames = [];
      $scope.hutNameZhSelected = '';
      $scope.titleBarNameSelected = '台灣山屋餘額查詢';
      $scope.calendarTitles = [];
      $scope.adminColor = {
        '0': 'adminColorEven',
        '1': 'adminColorOdd'
      };
      $scope.titleBar = [
        {
          url: '#/contact',
          name: '聯絡我'
        }, {
          url: '#/question',
          name: '常見問題'
        }, {
          url: '#/huts',
          name: '台灣山屋餘額查詢'
        }, {
          url: '#/about',
          name: '關於'
        }
      ];
      $http.get('/api/hut').success(function(result, statusCode) {
        $scope.isLoading = false;
        $scope.hutGroups = result.hutGroups;
        return $scope.huts = result.huts;
      }).error(function(e) {
        return console.log(e);
      });
      $scope.hutNameClicked = function(hutNameZh) {
        var day, hut, hutApplicableAll, hutApplicableInOneWeek, istatus, j, k, l, len, len1, ref, ref1, ref2, results, status;
        $scope.ggData = [];
        $scope.calendarTitles = ['日', '一', '二', '三', '四', '五', '六'];
        $scope.hutNameZhSelected = hutNameZh;
        hutApplicableAll = [];
        hutApplicableInOneWeek = [];
        ref = $scope.huts;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          hut = ref[j];
          if (hut.nameZh === hutNameZh) {
            ref1 = hut.capacityStatuses.status;
            for (istatus = k = 0, len1 = ref1.length; k < len1; istatus = ++k) {
              status = ref1[istatus];
              $scope.ggData.push({
                date: status.date,
                remaining: parseInt(status.remaining),
                applying: parseInt(status.applying)
              });
              day = new Date(status.date).getDay();
              if (istatus === 0 && day !== 0) {
                for (l = 0, ref2 = day; 0 <= ref2 ? l < ref2 : l > ref2; 0 <= ref2 ? l++ : l--) {
                  hutApplicableInOneWeek.push({});
                }
              }
              hutApplicableInOneWeek.push(status);
              if (istatus === hut.capacityStatuses.status.length - 1 || day === 6) {
                hutApplicableAll.push(hutApplicableInOneWeek);
                hutApplicableInOneWeek = [];
              }
            }
            $scope.hutApplicableAll = hutApplicableAll;
            break;
          } else {
            results.push(void 0);
          }
        }
        return results;
      };
      return $scope.titleBarNameClicked = function(titleBarName) {
        return $scope.titleBarNameSelected = titleBarName;
      };
    }
  ]);

  app.directive('barChart', function() {
    return {
      restrict: 'E',
      scope: {
        data: '=data'
      },
      link: function(scope, element, attrs) {
        var heightChart, padding, widthBar;
        padding = 40;
        widthBar = 40;
        heightChart = 300;
        return scope.$watch('data', function(g) {
          var chartGroup, format, sizeData, svg, y;
          sizeData = scope.data.length;
          if (sizeData !== 0) {
            d3.select(element[0]).selectAll('*').remove();
            svg = d3.select(element[0]).append('svg').attr('width', sizeData * widthBar + padding * 2).attr('height', heightChart + padding * 2);
            chartGroup = svg.append('g').attr('width', sizeData * widthBar).attr('height', heightChart).attr('transform', 'translate(' + padding + ',' + padding + ')');
            y = d3.scale.linear().range([heightChart, 0]).domain([
              0, d3.max(scope.data, function(d) {
                return d.remaining;
              })
            ]);
            chartGroup.append('g').selectAll('rect').data(scope.data).enter().append('rect').attr('x', function(d, i) {
              return i * widthBar + widthBar / 4;
            }).attr('y', function(d) {
              return y(d.remaining);
            }).attr('width', widthBar / 2).attr('height', function(d) {
              return heightChart - y(d.remaining);
            }).attr('fill', '#263238');
            chartGroup.append('g').selectAll('text').data(scope.data).enter().append('text').text(function(d) {
              if (d.remaining !== 0) {
                return d.remaining;
              } else {
                return '';
              }
            }).attr('x', function(d, i) {
              return i * widthBar + widthBar / 2;
            }).attr('y', function(d) {
              return y(d.remaining) - 5;
            }).attr('text-anchor', 'middle').attr('fill', '#263238').attr('font-size', 11);
            format = d3.time.format('%_m/%_d');
            return chartGroup.append('g').selectAll('text').data(scope.data).enter().append('text').text(function(d) {
              return format(new Date(d.date));
            }).attr('x', function(d, i) {
              return i * widthBar + widthBar / 2;
            }).attr('y', function(d) {
              return heightChart + 20;
            }).attr('text-anchor', 'middle').attr('fill', function(d) {
              switch (new Date(d.date).getDay()) {
                case 0:
                case 6:
                  return '#E53935';
                default:
                  return '#263238';
              }
            }).attr('font-size', 11);
          }
        }, true);
      }
    };
  });

}).call(this);
