class window.Imagine
	@images: ($current,wid) ->
		$container = $(".wrap",$current)
		$.get "/words/imagine?id=#{wid}&type=2",(data) ->
			html = ""
			if data.status is 0	
				for img in data.data
					html += "<div class='item imagine'><img src='#{img}' /></div>" 
				width = (data.data.length + 1)*280
				$(".wrap",$current).append(html).css 'width': "#{width}px"
		$current.addClass 'loaded' 
	@annotate: ($current,wid) ->
		$.get "/words/imagine?id=#{wid}&type=1",(data) ->
			if data.status is 0	
				if data.data
					$(".annotate input[type='text']",$current).val(data.data).addClass 'done'
		$current.addClass 'loaded'
	@audios: ($current,wid) ->
		$audio = $("audio",$current)
		$.get "/words/imagine?id=#{wid}&type=3",(data) ->
			if data.status is 0	
				if data.data.me 
					$c_audio = $(".custom audio",$current)
					$c_audio[0].src = data.data.me 
					$c_audio.parent().fadeIn()
		#检测浏览器是否支持语音输入
		if navigator.webkitGetUserMedia or navigator.getUserMedia
			window.recorder = window.recorder || new AudioRecorder()
			$current.on "click","a[href='#record']", ->		
				window.recorder.startRecording($(@).parent())
				false		
		else
			$current.on "click","a[href='#record']", ->		
				Utils.flash "您的浏览器不支持语音输入，请尝试chrome","error","right"
				false
		$current.on "click","a[href='#play']", ->
			$btn = $(@)
			$audio = $btn.prev('audio')
			$audio[0].play()
			false
		$audio.on 'play', ->
			$(@).next().html "<i class='icon-spinner icon-spin'></i>"
		$audio.on 'ended', ->
			$(@).next().text "▶"
		$current.addClass 'loaded'