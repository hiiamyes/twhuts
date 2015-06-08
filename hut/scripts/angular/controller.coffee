app = angular.module 'hutCrawler', ['ngRoute']

app.config(['$routeProvider',
	($routeProvider) ->
		$routeProvider.
			when('/huts',
				templateUrl: 'views/huts'
			).
			when('/changelog',
				templateUrl: 'views/changelog'
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
	$scope.updateDate = ''
	$scope.hutGroups = []
	$scope.topBarHutNames = []
	$scope.hutNameZhSelected = ''
	$scope.titleBarNameSelected = '山屋餘額'
	$scope.calendarTitles = []
	$scope.adminColor = 
		'0': 'adminColorEven'
		'1': 'adminColorOdd'

	$scope.titleBar = [
		url: '#/huts'
		name: '山屋餘額'
	,
		url: '#/changelog'
		name: '更新日誌'
	,	
		url: '#/about'
		name: '關於'
	,
		url: '#/question'
		name: '常見問題'
	,
		url: '#/contact'
		name: '聯絡我'
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

				$scope.updateDate = moment(hut.capacityStatuses.dateCrawl).format('M月D日 H:mm')

				for status, istatus in hut.capacityStatuses.status

					$scope.ggData.push {date: status.date, remaining: parseInt(status.remaining), applying: parseInt(status.applying)}

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

			###
			Structure
				svg
					groupChart
						groupBarRemaining
						groupBarApplying
						groupLabelRemaing
						groupLabelApplying
						groupXAxis
			###

			# Constants
			groupChartHeight = 300
			groupChartPadding = 20
			barWidth = 14 # There are two bars in one day.
			barInterval = 26
			
			# Let's draw!
			scope.$watch(
				'data'
				,(g) ->
					sizeData = scope.data.length
					if sizeData isnt 0
						
						# Clear all.
						d3.select(element[0]).selectAll('*').remove()

						# 
						groupChartWidth = barWidth * 2 * sizeData + barInterval * (sizeData - 1)
						
						# 
						svg = d3.select element[0]			
							.append 'svg'			
							.attr 'width',  groupChartWidth + groupChartPadding * 2
							.attr 'height', groupChartHeight + groupChartPadding * 2

						# 
						groupChart = svg
							.append 'g'
							.attr 'width', groupChartWidth
							.attr 'height', groupChartHeight
							.attr 'transform', 'translate(' + groupChartPadding + ',' + groupChartPadding + ')'

						# Create y scale
						remainingMax = d3.max(scope.data, (d) -> d.remaining)
						applyingMax = d3.max(scope.data, (d) -> d.applying)
						yScale = d3.scale.linear()
							.range [groupChartHeight, 0]
							.domain [0, d3.max([remainingMax, applyingMax])]
						
						# Create bars - remaining
						groupChart
							.append 'g'
							.selectAll('rect').data(scope.data).enter().append('rect')
							.attr 'x', (d, i) -> barInterval / 2 + i * (barWidth * 2 + barInterval)
							.attr 'y', (d) -> yScale(d.remaining)
							.attr 'width', barWidth
							.attr 'height', (d) -> groupChartHeight - yScale d.remaining
							.attr 'class', 'bar remaining'
						
						# Create bars - applying
						groupChart
							.append 'g'
							.selectAll('rect').data(scope.data).enter().append('rect')
							.attr 'x', (d, i) -> barInterval / 2 + barWidth + i * (barWidth * 2 + barInterval)
							.attr 'y', (d) -> yScale(d.applying)
							.attr 'width', barWidth
							.attr 'height', (d) -> groupChartHeight - yScale d.applying
							.attr 'class', 'bar applying'

						# Add xAxis, include line, label-date, separator
						xAxis = groupChart.append 'g'
						xAxis						
							.append 'line'
							.attr 'x1', 0
							.attr 'y1', groupChartHeight
							.attr 'x2', groupChartWidth + barInterval
							.attr 'y2', groupChartHeight
							.attr 'class', 'xaxis'

						xAxis
							.append 'g'
							.selectAll('line').data([0..sizeData]).enter().append('line')
							.attr 'x1', (d, i) -> i * (barWidth * 2 + barInterval)
							.attr 'y1', groupChartHeight
							.attr 'x2', (d, i) -> i * (barWidth * 2 + barInterval)
							.attr 'y2', groupChartHeight + 5
							.attr 'class', 'xaxis'

						format = d3.time.format('%_m/%_d')
						xAxis
							.append 'g'
							.selectAll('text').data(scope.data).enter().append('text')
							.text (d) -> format(new Date(d.date))
							.attr 'x', (d, i) -> barInterval / 2 + barWidth  + i * (barWidth * 2 + barInterval)
							.attr 'y', (d) -> groupChartHeight + 20
							.attr 'class', (d) -> 
								switch new Date(d.date).getDay()
									when 0, 6 then 'label date weekend'
									else 'label date weekday'

						# Add labels - remaining and applying
						groupChart
							.append 'g'
							.selectAll('text').data(scope.data).enter().append('text')
							.text (d) -> if d.remaining != 0 then d.remaining else ''
							.attr 'x', (d, i) -> barInterval / 2 + barWidth * 0.6  + i * (barWidth * 2 + barInterval)
							.attr 'y', (d) -> yScale(d.remaining) - 5
							.attr 'class', 'label remaining'

						groupChart
							.append 'g'
							.selectAll('text').data(scope.data).enter().append('text')
							.text (d) -> if d.applying != 0 then d.applying else ''
							.attr 'x', (d, i) -> barInterval / 2 + barWidth * 1.4 + i * (barWidth * 2 + barInterval)
							.attr 'y', (d) -> yScale(d.applying) - 5
							.attr 'class', 'label applying'						

				,true
			)			
	}
