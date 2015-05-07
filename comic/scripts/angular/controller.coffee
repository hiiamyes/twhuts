app = angular.module 'gg', []

app.controller('ggCtrl', ['$scope', ($scope) ->

    pages = []
    for i in [1..190]
        page = '000' + i
        page = page.substr -3, 3
        pages.push 'http://99770.co/wp-content/uploads/a04cj84wj6uq04/1671/002//' + page + '.jpg'
    
    $scope.pages = pages
])
