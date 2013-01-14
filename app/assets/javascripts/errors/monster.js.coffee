# Cursor Monster by simurai
# updated by veggie
$ ->
	$wrap = $('#wrapper')
	status = "sleep"
	mouthOpen = false
	count = 0
	$(document).mousemove (e) ->
		docW = $(window).width()
		docH = $(window).height()		
		diffX = (docW/2) - e.clientX
		diffY = (docH/2)-100 - e.clientY		
		dist = distance(docW/2,docH/2, e.clientX, e.clientY)
		distM = distance(docW/2,(docH/2)+60, e.clientX, e.clientY)				
		if status is "sleep"			
			if distM < 200
				$wrap.removeClass("sleep").addClass("hungry")
				status = "hungry"
				playAudio("audio-ohh")					
		else if status is "hungry"							
			eye_background = Math.floor(diffX/-30) + 'px ' + Math.floor( diffY /-30 ) + 'px'		
			eye_translate =	Math.floor(diffX/-50 ) + 'px, '+ Math.floor(diffY/-100 ) + 'px'	
			$(".eye").css
				"background-position":eye_background
				"-webkit-transform":'translate3d(' + eye_translate + ',0)'
				"-moz-transform":'translate(' + eye_translate + ')'
			$(".eye:first-child").css
				"background-position":eye_background
				"-webkit-transform":'translate3d(' + eye_translate + ',0) scale(.6)'
				"-moz-transform":'translate(' + eye_translate + ') scale(.6)'
			
			eye_lid_p = 100 + Math.floor( diffY /-20 )
			eye_lid = '-webkit-gradient(radial, 50% ' + eye_lid_p + '%, 20, 50% ' + eye_lid_p + '%, 50, color-stop(.5, rgba(0,0,0,0)), color-stop(.6, rgba(0,0,0,1)))'
			$(".lid").css
				"-webkit-mask-image":eye_lid
			
			if distM > 200
				if mouthOpen
					mouthOpen = false
					$('#mouth').addClass("out")
					mouth_height = "20px"
					count = 0
			else				
				mouth_height = 80 - Math.floor(distM /3) + 'px'
				if !mouthOpen
					mouthOpen = true
					$('#mouth').removeClass("out")
			mouth_transform = Math.floor(diffX/-80) + "px, " + Math.floor(diffY/-80 ) + 'px'
			$("#mouth").css
				"height":mouth_height
				"-webkit-transform":'translate3d(' + mouth_transform + ', 0)'
				"-moz-transform":'translate(' + mouth_transform + ')'

			if distM < 30 and count > 50
				count = 0
				$("#mouth").css
					"height":""
					"-webkit-transform":""
					"-moz-transform":""
				$("body").css
					"cursor":"none"				
				$wrap.removeClass("hungry").addClass("eat")
				playAudio("audio-snap")
				status = "eat"				
			else
				count++			
		else if status is "eat"		
			if distM > 120
				$wrap.removeClass("eat").addClass("hungry")
				$("body").css
					"cursor":""
				status = "hungry"
				playAudio("audio-ohh")
				
distance = (x1, y1, x2, y2) ->
	Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2))

playAudio = (id) ->	
	$("##{id}")[0].play() 