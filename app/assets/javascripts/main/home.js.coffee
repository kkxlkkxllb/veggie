class window.Home
	@init: ->
		home = new Home()
		home.info($("#impress"))
		if $("#top_nav").length is 0
			$("html").addClass("home")
	constructor: ->
		Utils.masonry($("#user_list"),'.user_item')				
	info: ($wrap)->
		if $wrap.length is 1 and !$('body').hasClass("impress-not-supported")
			impress().init()
			$wrap.show()
			api = impress()
