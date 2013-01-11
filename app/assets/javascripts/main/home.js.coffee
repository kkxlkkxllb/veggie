class window.Home
	@init: ->
		home = new Home()
		home.info($("#impress"))
		if $("#top_nav").length is 0
			$("html").addClass("home")
	@menu_fade: ->
		$nav = $("#top_nav")
		fadeIn = -> 
			setTimeout(
				-> $nav.css 'opacity':'0.4'
				2000
			)
		fadeIn()
		$nav.hover(
			-> $(@).css 'opacity':'1'
			-> fadeIn()
		)
	constructor: ->
		Utils.masonry($("#user_list"),'.user_item')				
	info: ($wrap)->
		if $wrap.length is 1 and !$('body').hasClass("impress-not-supported")
			$wrap.jmpress()
			$wrap.show()
