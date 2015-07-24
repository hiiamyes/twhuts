app = angular.module 'wedding', ['ngRoute', 'ngMaterial']

app.config(['$routeProvider',
	($routeProvider) ->
		$routeProvider
			.when('/about', templateUrl: 'views/about')
			.when('/invitation', templateUrl: 'views/invitation')
			.when('/gallery', templateUrl: 'views/gallery')
			.otherwise(redirectTo: '/about')
])

app.config(($mdIconProvider) ->
	$mdIconProvider
       .iconSet 'social', 'img/icons/sets/social-icons.svg', 24
       .defaultIconSet 'img/icons/sets/core-icons.svg', 24
)

app.controller('weddingCtrl', ['$scope', '$http', ($scope, $http) ->
	$scope.nop = [1..7]
	# $scope.nopInfant = 
	# $scope.nopVeg = 
	$scope.gggg = ->
		console.log 'gggg'
		$http
			.get '../api/sendEmail'


	$http
		.post 'https://api.dropbox.com/1/media/auto', {access_token: 'cODRev6GYMsAAAAAAANhCkeM0IkNFxalmsoqqEwByvfAvr_MXV-66lpOkTZL8cxS'}
		.success (data, status, headers, config) ->
			console.log 'yaya'
		.error (data, status, headers, config) ->
			console.log 'gg'

])
