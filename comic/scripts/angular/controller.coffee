app = angular.module 'comicCrawler', []

app.controller('comicCrawlerCtrl', ['$scope', ($scope) ->

    $scope.pages = []

    $scope.urlSubmitted = () ->
    	parser()

   	parser = () ->
   		# console.log $scope.url
   		pages = []
    	for i in [1..25]
        	page = '000' + i
        	page = page.substr -3, 3
        	pages.push $scope.url.replace('http://', 'https://') + page + '.jpg'
        	console.log $scope.url + page + '.jpg'

    	$scope.pages = pages
])
