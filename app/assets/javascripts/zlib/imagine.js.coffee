class window.Imagine
	@images: ($current,wid) ->
		$container = $(".img_wrap",$current)
		$.get "/words/imagine?id=#{wid}&type=2",(data) ->
			html = ""
			if data.status is 0	
				if data.data.img
					$img = $current.find('.me img')
					$img.attr("src",data.data.img)
					$img.fadeIn()
				for img in data.data.imagine
					html += "<span class='img imagine'><img src='#{img}' /></span>" 
			$(".img_wrap",$current).append(html)
		$current.addClass 'loaded'
	@annotate: ($current,wid) ->
		$.get "/words/imagine?id=#{wid}&type=1",(data) ->
			if data.status is 0	
				if data.data
					$(".annotate input[type='text']",$current).val(data.data).addClass 'done'
		$current.addClass 'loaded'
	audios: ->
		recorder = new AudioRecorder()
		$modal.on "click","a.record", ->		
			recorder.startRecording($(@))
			false
		$modal.on "click","a.record-play", ->
			audio = $(@).prev('audio')
			audio[0].play()
			false