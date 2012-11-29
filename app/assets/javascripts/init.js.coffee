$ ->
	Utils.infinitescroll($("#home"))
	Utils.masonry($("#home"),'.leaf')
	Utils.masonry($("#user_list"),'.user_item')
	if $("#top_nav").length is 0
		$("html").addClass("home")
	Olive.init()
	Home.init()
	Member.init()
	if $("#course_wrap").length is 1
		Word.init()
	mixpanel.track("new visitor")
