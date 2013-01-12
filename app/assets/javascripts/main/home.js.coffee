class window.Home
	@init: ->
		home = new Home()
		home.welcome($("#impress"))
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
	welcome: ($wrap)->
		if $wrap.length is 1
			$wrap.jmpress()
			$wrap.show()
