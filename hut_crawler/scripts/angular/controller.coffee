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

	$scope.ggData = []

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

		$scope.ggData = [];

		$scope.calendarTitles = ['日','一','二','三','四','五','六'] 

		$scope.hutNameZhSelected = hutNameZh        
		hutApplicableAll = []
		hutApplicableInOneWeek = []
		for hut in $scope.huts
			if hut.nameZh is hutNameZh
				for status, istatus in hut.capacityStatuses.status

					$scope.ggData.push {date: status.date, amount: parseInt(status.remaining)}

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

app.directive 'barChart', () ->
	return {
		restrict: 'E',
		scope: {data: '=data'},
		link: (scope, element, attrs) ->

			# Constants
			padding = 40
			widthBar = 40
			heightChart = 300
			
			scope.$watch(
				'data'
				,(g) ->
					sizeData = scope.data.length
					if sizeData isnt 0
						
						# Clear all.
						d3.select(element[0]).selectAll('*').remove()

						# Create the canvas.
						svg = d3.select element[0]				
							.append 'svg'			
							.attr 'width', sizeData * widthBar + padding * 2
							.attr 'height', heightChart + padding * 2

						chartGroup = svg
							.append 'g'
							.attr 'width', sizeData * widthBar
							.attr 'height', heightChart
							.attr 'transform', 'translate(' + padding + ',' + padding + ')'

						# Add the x-axis.
						x = d3.time.scale()
							.range [0, sizeData * widthBar - padding]
							.domain [new Date(scope.data[0].date), new Date(scope.data[scope.data.length-1].date)]
						xAxis = d3.svg.axis().scale(x).tickFormat(d3.time.format("%m%d")).ticks(scope.data.length)
						chartGroup
							.append 'g'
							.attr 'class', 'x axis'							
							.attr 'transform', 'translate(' + widthBar / 2 + ',' + heightChart + ')'
							.call xAxis;

						# Add the y-axis.
						y = d3.scale.linear()
							.range [heightChart, 0]
							.domain [0, d3.max(scope.data, (d) -> d.amount)]
						# yAxis = d3.svg.axis().scale(y).orient('left')
						# chartGroup
						# 	.append 'g'
						# 	.attr 'class', 'y axis'	
						# 	.call yAxis;	

						# Create new rect according to data.
						chartGroup
							.append 'g'
							.selectAll('rect').data(scope.data).enter().append('rect')
							.attr 'x', (d, i) -> i * widthBar + 10
							.attr 'y', (d) -> y(d.amount)
							.attr 'width', widthBar - 20
							.attr 'height', (d) -> heightChart - y d.amount
							.attr 'fill', 'rgba(255,255,255,.5)'

						# Add labels
						chartGroup
							.append 'g'
							.selectAll('text').data(scope.data).enter().append('text')
							.text (d) -> d.amount
							.attr 'x', (d, i) -> i * widthBar
							.attr 'y', (d) -> y(d.amount) - 5
							.attr 'fill', 'red'		
							.attr 'font-size', 11									

				,true
			)			
	}
