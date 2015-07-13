exec = require("child_process").exec

module.exports = (app) ->
	# router
	app.get '/miro', (req, res) ->
		res.render 'miro/views/index'

	# api
	app.get '/api/reply', (req, res) ->
		question = req.query['question']
		console.log 'question = ' + question
		exec 'ruby miro/algo/findEye.rb ' + question, (err, stdout, stderr) ->
			if err
				console.log 'server err = ' + err + ', stderr = ' + stderr
				res.status(404).send('server err')
			else
				console.log 'success'
				console.log 'stdout: ' + stdout

				replys = stdout.split '\n'
				console.log replys
				reply = {}
				reply['words'] = replys[0]
				reply['song_name'] = replys[1]
				reply['sentence'] = replys[2]            
				reply['youtube_url'] = replys[3]
				reply['youtube_embed_url'] = 'http://www.youtube.com/embed/' + replys[3].split('v=')[1]

				console.log 'reply = ' + reply
				res.send reply

