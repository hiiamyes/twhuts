# db
MongoClient = require('mongodb').MongoClient
mongoServerUrl = 'mongodb://yes:yes@ds035280.mongolab.com:35280/hiking'
collectionName = 'trails'

module.exports = (app) ->
	# router
	app.get '/twtrails', (req, res) ->
		res.render 'twtrails/views/index'

	# api
	app.get '/api/trail', (req, res) ->
		MongoClient.connect mongoServerUrl, (err, db) ->
			db.collection(collectionName).find().toArray (err, docs) ->
				res.status(200).send(docs)
