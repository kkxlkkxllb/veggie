class window.AudioRecorder
	duration: 3000
	constructor: ->
		self = this
		window.AudioContext = window.AudioContext || window.webkitAudioContext
		navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia
		window.URL = window.URL || window.webkitURL			
		self.audio_context = new AudioContext
	startRecording: (button) ->
		self = this
		start_record = ->
			self.recorder.record()
			button.addClass 'ing'
			setTimeout(
				-> self.stopRecording(button)
				self.duration
			)
		startUserMedia = (stream) ->
			input = self.audio_context.createMediaStreamSource(stream)
			input.connect(self.audio_context.destination)
			self.recorder = new Recorder(input)	
			start_record()	
		if self.recorder isnt undefined
			start_record()	
		else			
			navigator.getUserMedia
				audio: true
				startUserMedia
				(e) ->
					Utils.flash("请允许使用您的麦克风哦！","error","right")
					false
			
	stopRecording: (button) ->
		self = this
		self.recorder && self.recorder.stop()
		button.removeClass 'ing'
		this.createDownloadLink(button.next().find("audio.output"))
		self.recorder.clear()
	createDownloadLink: (audio) ->
		self = this
		self.recorder and self.recorder.exportWAV (blob) ->
			url = URL.createObjectURL(blob)	 
			audio[0].src = url
			audio[0].play()
			audio.parent().fadeIn()
			wid = audio.closest(".word_audio").attr "wid"
			form = new FormData()
			form.append("file", blob)
			form.append("id",wid)
			form.append("authenticity_token",$("#audio_uploader form").find("input[name='authenticity_token']").val())
			oReq = new XMLHttpRequest()
			oReq.open("POST", '/words/upload_audio_u')
			oReq.send(form)
