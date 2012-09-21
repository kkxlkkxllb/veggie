$ ->
	init_infinitescroll($("#home"))
	init_masonry($("#home"),'.leaf')
	init_masonry($("#user_list"),'.user_item')
	init_words_ground($("#word_ground"),".word_item")
	init_filter($("#word_ground"))
	init_fill_tag($("form#new_word_tag_form"))
	$("div.leaf").live 'hover',->
		$("span.action",$(this)).toggle()
	form_submit($("#new_word form"))
	mixpanel.track("new visitor")
	if $("#impress").length != 0
		init_info()
	$("#add_new_btn").click ->
		add_provider_view()
	$("a[rel='tooltip']").tooltip()