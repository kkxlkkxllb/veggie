class window.Home
	@init: ->
		home = new Home()
		home.info($("#impress"))
		if $("#top_nav").length is 0
			$("html").addClass("home")
	@header_fade: ->
		$header = $("#top_nav")
		fade = ->
			$header.css 'width': '80px'
		fade()
		$header.hover(
			-> $(@).css 'width': '100%'
			-> fade()
		)
			
	constructor: ->
		Utils.masonry($("#user_list"),'.user_item')				
	info: ($wrap)->
		if $wrap.length is 1 and !$('body').hasClass("impress-not-supported")
			impress().init()
			$wrap.show()
			api = impress()
