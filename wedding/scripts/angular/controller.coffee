app = angular.module 'wedding', ['ngRoute', 'ngMaterial']

app.config(['$routeProvider',
	($routeProvider) ->
		$routeProvider.
			when('/wedding',
				templateUrl: 'views/index'
			).
			# when('/changelog',
			# 	templateUrl: 'views/changelog'
			# ).
			otherwise(
				redirectTo: '/index'
			)
])

app.controller('weddingCtrl', ['$scope', '$http', ($scope, $http) ->
	$scope.gggg = ->
		console.log 'gggg'
		$http
			.get '../api/sendEmail'			
])
