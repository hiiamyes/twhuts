express = require 'express'
async = require 'async'

app = express()
app.set 'view engine', 'jade'
app.set 'views', __dirname + '/'
app.use express.static(__dirname + '/')

# db
MongoClient = require('mongodb').MongoClient
mongoServerUrl = 'mongodb://yes:yes@ds035280.mongolab.com:35280/hiking'

# crawler
crawler = require './hut_crawler/scripts/crawler.js'
crawler.crawl MongoClient, mongoServerUrl

# routing
app.get '/', (req, res) ->
	res.render 'index'

app.get '/hut_crawler/views/:name', (req, res) ->
	res.render 'hiking/views/' + req.params.name

app.get '/hut_crawler', (req, res) ->
	res.render 'hiking/views/index'

app.get '/comic', (req, res) ->
	res.render 'comic/views/index'

# api
app.get '/api/hut', (req, res) ->
	MongoClient.connect mongoServerUrl, (err, db) ->
		async.parallel(
			hutGroups: (cb) ->
				db.collection('huts').aggregate([
					{ $sort: {nameZh: 1}}, 
					{ $group: {
						_id:
							admin: '$admin'
						hutNameZhs:
							$push: '$nameZh'
					}}
				], (err, result) ->
						cb null, result
				)
			huts: (cb) ->	
				db.collection('huts').find().toArray (err, docs) ->
					cb null, docs
			, (err, results) ->
				res.status(200).send({'hutGroups': results.hutGroups, 'huts': results.huts})
		)	        

# porting
port = Number process.env.PORT || 8080
app.listen port, () ->
	console.log 'Listening on ' + port
