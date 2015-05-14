app = angular.module 'hutCrawler', []

app.controller('hutCrawlerCtrl', ['$scope', '$http', ($scope, $http) ->

    $http
        .get '/api/hut'
        .success (huts) ->
            $scope.huts = huts
        .error (e) ->
            console.log e

    $scope.hutNameClicked = (hutName) ->
        hutApplicableAll = []
        hutApplicableInOneWeek = []
        for hut in $scope.huts
            if hut.nameZh is hutName
                for status, istatus in hut.capacityStatuses.status
                    day = new Date(status.date).getDay()

                    # Need some days to make up the 1st week if the 1st staus if not Sunday.
                    if istatus is 0 and day isnt 0
                        hutApplicableInOneWeek.push {} for [0...day]

                    hutApplicableInOneWeek.push status

                    if istatus is hut.capacityStatuses.status.length - 1 or day is 6
                        hutApplicableAll.push hutApplicableInOneWeek
                        hutApplicableInOneWeek = []

                $scope.hutApplicableAll = hutApplicableAll
                break
])
