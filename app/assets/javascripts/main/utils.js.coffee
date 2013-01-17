class window.Utils
	@loading: ($item) ->
		$item.addClass 'disable_event'
		$item.queue (next) ->
			$(@).animate({opacity: 0.2},800).animate({opacity: 1},800)
			$(@).queue(arguments.callee)
			next()
	@loaded: ($item) ->
		$item.stop(true).css "opacity",1
		$item.removeClass 'disable_event'
	@flash: (msg,type='',style='') ->
		$flash = $("#flash_message")
		$flash.prepend("<div class='alert text_center hide'><strong></strong></div>")
		$alert = $(".alert",$flash)
		if type isnt ''
			$alert.addClass "alert-#{type}"
		if style isnt ''
			$alert.addClass "alert-#{style}"
		$("strong",$alert).text(msg)
		$alert.slideDown()
		fuc = -> 
			$alert.slideUp ->
				$alert.remove()
		setTimeout fuc,5000
		false
	@infinitescroll: ($wrap) ->
		$wrap.infinitescroll
			navSelector	 : "nav.pagination",
			nextSelector : "nav.pagination a",
			itemSelector : ".leaf",
			debug				 : false,
			loading: 
				finishedMsg: '这是所有咯',
				msgText : "正在努力加载更多内容...",
				img: 'http://i.imgur.com/6RMhx.gif'
			,
			(newElements) ->
				$newElems = $( newElements ).css opacity: 0
				$newElems.imagesLoaded ->
					$newElems.animate opacity: 1
					$wrap.masonry( 'appended', $newElems, true )
				$("img",$( newElements )).load ->
					lzld(this)
	@masonry: ($contain,item) ->
		$contain.imagesLoaded ->	
			$(item).animate opacity: 1
			$contain.masonry
				itemSelector : item,
				isAnimated: false,
				isFitWidth: true
	@user_theme: ($bg_wrap = $(".user_bg")) ->
		if $bg_wrap.length is 1
			opacity = $bg_wrap.attr("data-o")
			$("img",$bg_wrap).load ->
				$(@).css 'opacity':opacity
				$bg_wrap.animate opacity: 1
	@image_imagine: ($wrap) ->
		$container = $(".img_wrap",$wrap)
		
		