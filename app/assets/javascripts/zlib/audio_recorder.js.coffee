class window.AudioRecorder
	duration: 5000
	constructor: ->
		self = this
		if !navigator.getUserMedia 
			window.AudioContext = window.AudioContext || window.webkitAudioContext
			navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia
			window.URL = window.URL || window.webkitURL			
			self.audio_context = new AudioContext
			unless navigator.getUserMedia
				alert "not support"
			
	startRecording: (button) ->
		self = this		
		startUserMedia = (stream) ->
			input = self.audio_context.createMediaStreamSource(stream)
			input.connect(self.audio_context.destination)
			recorder = new Recorder(input)
			recorder		
		unless navigator.getUserMedia					
			navigator.getUserMedia
				audio: true
				startUserMedia
				(e) ->
					Utils.flash("请允许使用您的麦克风哦！","error","right")
					false
	
		startUserMedia.record()
		button.addClass 'ing'
		setTimeout(
			-> self.stopRecording(button)
			self.duration
		)
				
	stopRecording: (button) ->
		recorder && recorder.stop()
		button.removeClass 'ing'
		this.createDownloadLink(button.next().find("audio.output"))
		recorder.clear()
	createDownloadLink: (audio) ->
		recorder and recorder.exportWAV (blob) ->
			url = URL.createObjectURL(blob)	 
			audio[0].src = url
			audio[0].play()
			audio.next().removeClass "disabled"