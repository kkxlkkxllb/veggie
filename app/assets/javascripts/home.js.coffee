$ ->
	init_infinitescroll($("#home"));
	init_masonry($("#home"),'.leaf')
	init_masonry($("#user_list"),'.user_item')
	$(".icon-headphones").live 'click',->
		sound = $(this).next()[0]
		sound.load()
		sound.play()
		false	
	$("div.leaf").live 'hover',->
		$("span.action",$(this)).toggle()
	form_submit($("#new_word form"))
	init_info()
	mixpanel.track("new visitor")