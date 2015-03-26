var app = angular.module('hutCrawler', []);

// app.config(function($httpProvider) {
//     //Enable cross domain calls
//     $httpProvider.defaults.useXDomain = true;
//     //Remove the header used to identify ajax call that would prevent CORS from working
//     delete $httpProvider.defaults.headers.common['X-Requested-With'];
// });

app.controller('hutCrawlerCtrl', ['$scope', '$http', function($scope, $http) {

    console.log('gg');

    // $http.defaults.useXDomain = true;
    $http.get('https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=13')
        .success(function(result) {
            console.log(result);
        })
        .error(function(error) {
            console.log(error);
        });

}]);
