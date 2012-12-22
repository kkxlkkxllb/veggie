class window.Mhome
	@flash: (msg)->
		$alert = $("#m_flash")
		$alert.text(msg).fadeIn()
		fuc =-> $alert.fadeOut()
		setTimeout fuc,5000
	constructor: ($wrap) ->
		if window.screen.height is 480		
			$("meta[name=viewport]").content = "width=device-width,initial-scale=1,user-scalable=0, minimum-scale=1, maximum-scale=1"
		$("#m_nav .menu").click ->
			page = $(@).attr "rel"		
			$("#m_nav_back").show()
			$("#m_nav").hide()
			window[$.string(page).capitalize().str].init()
		$("#m_nav_back").click ->
			$(@).hide()
			$wrap.infinitescroll("destroy").html("")
			$("#m_nav").show()
	
