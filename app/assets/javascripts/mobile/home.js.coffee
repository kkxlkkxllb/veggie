home = exports ? this
class home.Home
	@flash: (msg)->
		$alert = $("#m_flash")
		$alert.text(msg).fadeIn()
		fuc =-> $alert.fadeOut()
		setTimeout fuc,5000
	constructor: (@$wrap) ->
		$("#m_nav .menu").click ->
			page = $(@).attr "rel"		
			$("#m_nav_back").show()
			$("#m_nav").hide()
			window[$.string(page).capitalize().str].init()
		$("#m_nav_back").click ->
			$(@).hide()
			@$wrap.infinitescroll("destroy").html("")
			$("#m_nav").show()
	
