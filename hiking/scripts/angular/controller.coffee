app = angular.module 'hutCrawler', []

app.controller('hutCrawlerCtrl', ['$scope', '$http', ($scope, $http) ->

    $scope.hutGroups = []
    $scope.topBarHutNames = []
    $scope.hutNameZhSelected = ''

    $http
        .get '/api/hut'
        .success (result, statusCode) ->
            # console.log result
            $scope.hutGroups = result.hutGroups
            $scope.huts = result.huts
        .error (e) ->
            console.log e

    # $scope.adminClicked = (indexAdmin) ->
    #     $scope.topBarHutNames = $scope.hutNames[indexAdmin].nameZh
    #     $scope.selectedIndexAdmin = indexAdmin
    #     $scope.selectedIndexHut = -1

    $scope.hutNameClicked = (hutNameZh) ->
        $scope.hutNameZhSelected = hutNameZh        
        hutApplicableAll = []
        hutApplicableInOneWeek = []
        for hut in $scope.huts
            if hut.nameZh is hutNameZh
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
