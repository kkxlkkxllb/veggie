$ ->
	init_infinitescroll($("#home"));
	init_masonry($("#home"),'.leaf')
	init_masonry($("#user_list"),'.user_item')
	$("a[rel=popover]").popover()
	$(".tooltip").tooltip()
	$("a[rel=tooltip]").tooltip()
	$(".icon-headphones").live 'click',->
		sound = $(this).next()[0]
		sound.load()
		sound.play()
		false	
	$("div.leaf").live 'hover',->
		$("span.action",$(this)).toggle()
	form_submit($("#new_word form"))
	mixpanel.track("new visitor")
	if $("#impress").length != 0
		init_info()