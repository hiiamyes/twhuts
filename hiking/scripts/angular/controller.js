var app = angular.module('hutCrawler', []);

app.controller('hutCrawlerCtrl', ['$scope', '$http', function($scope, $http) {

    $http.get('/api/hut')
        .success(function(huts) {
            $scope.huts = huts;
        })
        .error(function(e) {
            console.log(e);
        });

    $scope.hutNameClicked = function(hutName) {
        var hutApplicableAll = [];
        var hutApplicableInOneWeek = [];
        for (var i = 0; i < $scope.huts.length; i++) {
            var hut = $scope.huts[i];
            if (hut.nameZh == hutName) {
                for (var i = 0; i < hut.status.length; i++) {
                    var status = hut.status[i]
                    var date = new Date(status.date);
                    var day = date.getDay();
                    // supply days in 1st week
                    if (i == 0 && day != 0) {
                        for (var dayIndex = 0; dayIndex < day; dayIndex++) {
                            hutApplicableInOneWeek.push({});
                        };
                    };

                    //
                    hutApplicableInOneWeek.push(status);
                    if (i == hut.status.length - 1 || day == 6) {
                        hutApplicableAll.push(hutApplicableInOneWeek);
                        hutApplicableInOneWeek = [];
                    };
                };
                $scope.hutApplicableAll = hutApplicableAll;
                break;
            };
        };
    }

}]);
