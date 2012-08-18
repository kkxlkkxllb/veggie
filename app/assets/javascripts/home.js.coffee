$ ->
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
	$(".nav_item span.bird").css({'left':"0px"}).animate {left:"1000px"},5000,"easeInBack",->
		$(this).animate {left:"100px"},5000,"easeInOutSine"