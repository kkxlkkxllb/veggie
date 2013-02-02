class window.AudioRecorder
	duration: 5000
	constructor: ->
		window.AudioContext = window.AudioContext || window.webkitAudioContext
		navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia
		window.URL = window.URL || window.webkitURL			
		audio_context = new AudioContext
		unless navigator.getUserMedia
			alert "not support"
			
		startUserMedia = (stream) ->
			input = audio_context.createMediaStreamSource(stream)
			input.connect(audio_context.destination)		
			this.recorder = new Recorder(input)
		navigator.getUserMedia
			audio: true
			startUserMedia
			(e) ->
				console.log('No live audio input: ' + e)
	
	startRecording: (button) ->
		try
			recorder && recorder.record()
			button.addClass 'ing'
			self = this			
			setTimeout(
				-> self.stopRecording(button)
				self.duration
			)
		catch error
			Utils.flash("请允许使用您的麦克风哦！","error","right")
	stopRecording: (button) ->
		recorder && recorder.stop()
		button.removeClass 'ing'
		this.createDownloadLink(button.next("audio.output"))
		recorder.clear()
	createDownloadLink: (audio) ->
		recorder and recorder.exportWAV (blob) ->
			url = URL.createObjectURL(blob)	 
			audio[0].src = url
			audio[0].play()
			audio.next().removeClass "disabled"