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
	init_info()
	$(".nav_item span.bird").animate {left:"100px",opacity: 1},2000,"easeInOutSine",->
		$("#fish1 img").css({"top":"-60px"}).animate {opacity: 1,top:0},4000,->
			$(this).animate {opacity: 0,top:"-60px"},4000,->
				$("#fish2 img").css({"left":"-200px","top":0}).animate {opacity: 1,left:"50px",top:"-60px"},4000,->
					$(this).animate {opacity:0,left:"250px"},4000,->
						$("#fish3 img").css({"bottom":"-80px"}).animate {opacity: 1,left:"20px",bottom:"0px"},4000,->
							$(this).animate {opacity:0,left:"100px",bottom:"120px"},4000