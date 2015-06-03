app = angular.module 'hutCrawler', ['ngRoute']

app.config(['$routeProvider',
	($routeProvider) ->
		$routeProvider.
			when('/huts',
				templateUrl: 'views/huts'
			).
			when('/about',
				templateUrl: 'views/about'
			).
			when('/question',
				templateUrl: 'views/question'
			).
			when('/contact',
				templateUrl: 'views/contact'
			).
			otherwise(
				redirectTo: '/huts'
			)
])

app.controller('hutCrawlerCtrl', ['$scope', '$http', ($scope, $http) ->

	$scope.isLoading = true;
	$scope.hutGroups = []
	$scope.topBarHutNames = []
	$scope.hutNameZhSelected = ''
	$scope.titleBarNameSelected = '台灣山屋餘額查詢'
	$scope.calendarTitles = []
	$scope.adminColor = 
		'0': 'adminColorEven'
		'1': 'adminColorOdd'

	$scope.titleBar = [
		url: '#/contact'
		name: '聯絡我'
	,
		url: '#/question'
		name: '常見問題'
	,
		url: '#/huts'
		name: '台灣山屋餘額查詢'
	,
		url: '#/about'
		name: '關於'
	]

	$http
		.get '/api/hut'
		.success (result, statusCode) ->
			# console.log result
			$scope.isLoading = false
			$scope.hutGroups = result.hutGroups
			$scope.huts = result.huts
		.error (e) ->
			console.log e

	# $scope.adminClicked = (adminName) ->
	# 	switch adminName
	# 		when '南投林區管理處'
	# 		when '玉山國家公園'
	# 		when '台灣山林悠遊網'
	# 		when '太魯閣國家公園'
	# 		when '雪霸國家公園'

	$scope.hutNameClicked = (hutNameZh) ->             
		$scope.calendarTitles = ['日','一','二','三','四','五','六'] 

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

	$scope.titleBarNameClicked = (titleBarName) ->
		$scope.titleBarNameSelected = titleBarName
])
