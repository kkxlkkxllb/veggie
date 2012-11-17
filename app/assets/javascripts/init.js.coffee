$ ->
	Utils.infinitescroll($("#home"))
	Utils.masonry($("#home"),'.leaf')
	Utils.masonry($("#user_list"),'.user_item')		
	$("i[rel='tooltip'],a[rel='tooltip']").tooltip()
	if $("#top_nav").length is 0
		$("html").addClass("home")
	Word.init()
	Olive.init()
	Home.init()
	mixpanel.track("new visitor")