var app = angular.module('hutCrawler', []);

app.controller('hutCrawlerCtrl', ['$scope', '$http', function($scope, $http) {

    $http.get('/api/hut')
        .success(function(huts) {
            var hutsApplicableAll = [];
            var hutsApplicableInOneWeek = [];
            for (var i = 0; i < huts.length; i++) {
                var hut = huts[i];
                hutsApplicableInOneWeek.push(hut);
                if (i == huts.length - 1 || new Date(hut.date).getDay() == 6) {
                    hutsApplicableAll.push(hutsApplicableInOneWeek);
                    hutsApplicableInOneWeek = [];
                };
            };
            console.log(hutsApplicableAll);

            $scope.hutsApplicableAll = hutsApplicableAll;
        })
        .error(function(e) {
            console.log(e);
        });

}]);
