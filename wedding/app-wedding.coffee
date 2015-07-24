apiKey = 'ehyLECUeTeWzeCcbfRcQ2w'
# sendgrid  = require('sendgrid')(apiKey)
sendgrid  = require('sendgrid')('namejoshua', 'jojo782011')

module.exports = (app) ->
	# router
	app.get '/wedding', (req, res) ->
		res.render 'wedding/views/index'

	app.get '/wedding/views/:name', (req, res) ->
		res.render 'wedding/views/' + req.params.name

	# api
	app.get '/api/sendEmail', (req, res) ->
		console.log 'yayaya'
		payload = 
			to: 'joshuayes@gmail.com'
			from: 'joshuayes@gmail.com'
			subject: 'Saying Hi'
			text : 'This is my first email through SendGrid'

		sendgrid.send payload, (err, json) ->
  			if err then console.error err
  			console.log json
	# 	question = req.query['question']
	# 	console.log 'question = ' + question
	# 	exec 'ruby miro/algo/findEye.rb ' + question, (err, stdout, stderr) ->
	# 		if err
	# 			console.log 'server err = ' + err + ', stderr = ' + stderr
	# 			res.status(404).send('server err')
	# 		else
	# 			console.log 'success'
	# 			console.log 'stdout: ' + stdout

	# 			replys = stdout.split '\n'
	# 			console.log replys
	# 			reply = {}
	# 			reply['words'] = replys[0]
	# 			reply['song_name'] = replys[1]
	# 			reply['sentence'] = replys[2]            
	# 			reply['youtube_url'] = replys[3]
	# 			reply['youtube_embed_url'] = 'http://www.youtube.com/embed/' + replys[3].split('v=')[1]

	# 			console.log 'reply = ' + reply
	# 			res.send reply

