$ ->
	init_infinitescroll($("#home"))
	init_masonry($("#home"),'.leaf')
	init_masonry($("#user_list"),'.user_item')
	init_words_ground($("#word_ground"),".word_item",$("form#new_word_tag_form"))
	init_destroy_leaf()
	$("div.leaf").live 'hover',->
		$("span.action",$(this)).toggle()
	mixpanel.track("new visitor")
	if $("#impress").length is 1 and !$('body').hasClass("impress-not-supported")
		init_info()
	$("#add_new_btn").click ->
		add_provider_view()
	$("i[rel='tooltip'],a[rel='tooltip']").tooltip()
	if $("#top_nav").length is 0
		$("html").addClass("home")