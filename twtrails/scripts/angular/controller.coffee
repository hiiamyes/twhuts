app = angular.module 'twtrails', ['ngRoute']

app.config(['$routeProvider',
	($routeProvider) ->
		$routeProvider.
			when('/twtrails',
				templateUrl: 'views/index'
			).
			# when('/changelog',
			# 	templateUrl: 'views/changelog'
			# ).
			otherwise(
				redirectTo: '/index'
			)
])

app.controller('twtrailsCtrl', ['$scope', '$http', ($scope, $http, $sce) ->
	$http
		.get '../api/trail'
		.success (result, statusCode) ->
			console.log 'ya'
			console.log result
			$scope.points = result[0].points
		.error (e) ->
			console.log e
])
