$ ->
	init_infinitescroll($("#home"));
	init_masonry($("#home"),'.leaf')
	init_masonry($("#user_list"),'.user_item')
	$("div.leaf").live 'hover',->
		$("span.action",$(this)).toggle()
	form_submit($("#new_word form"))
	mixpanel.track("new visitor")
	if $("#impress").length != 0
		init_info()
	$("#add_new_btn").click ->
		add_provider_view()