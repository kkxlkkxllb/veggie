$ ->
	Utils.infinitescroll($("#home"))
	Utils.masonry($("#home"),'.leaf')
	Utils.masonry($("#user_list"),'.user_item')
	if $("#top_nav").length is 0
		$("html").addClass("home")
	Word.init()
	Olive.init()
	Home.init()
	Member.init()
	mixpanel.track("new visitor")