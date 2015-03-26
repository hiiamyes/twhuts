var app = angular.module('hutCrawler', []);

app.controller('hutCrawlerCtrl', ['$scope', '$http', function($scope, $http) {

    console.log('gg');

    $http.get('https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=13')
        .success(function(result) {
            console.log(result);
        })
        .error(function(error) {
    		console.log(error);
        });

}]);
