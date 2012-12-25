class window.Mhome
	@flash: (msg)->
		$alert = $("#m_flash")
		$alert.text(msg).fadeIn()
		fuc =-> $alert.fadeOut()
		setTimeout fuc,5000
	@loading: ($item) ->
		$item.queue (next) ->
			$(@).animate({opacity: 0.2},800).animate({opacity: 1},800)
			$(@).queue(arguments.callee)
			next()
	@loaded: ($item) ->
		$item.stop(true).css "opacity",1
	constructor: ->
		if window.screen.height is 480		
			$("meta[name=viewport]").content = "width=device-width,initial-scale=1,user-scalable=0, minimum-scale=1, maximum-scale=1"
		$("#m_nav .menu").click ->
			page = $(@).attr "rel"			
			$("#m_nav").addClass 'hide'
			obj = window[$.string(page).capitalize().str]
			obj.init()
			$("#m_nav_back").show().click ->
				$(@).hide()
				obj.over()
				$("#m_nav").removeClass 'hide'
	
