class window.Members
	@init: ->
		member = new Members()
		member.setting($("#user_setting"))
		Utils.user_theme()
		member.show($("#user_show"),".word_item")
		member.dashboard $("#impress"),$("#cpanel")
		if $("#allen").length is 1
			Allen.init()	
	constructor: ->
		$("html").addClass 'uhome'
	setting: ($wrap) ->
		$(".providers img",$wrap).tooltip()
		activeTab = $('[href=' + location.hash + ']',$wrap)
		if activeTab.length is 1
			activeTab.tab('show')
		else
			$("[href='#profile']",$wrap).tab('show')
		$("#profile .avatar").click ->
			$("input[type='file']",$(@).parent()).trigger "click"
			false
		$("form input[type='file']",$wrap).change ->
			$(@).closest('form').submit()
	show: ($container,item)->
		$container.imagesLoaded ->
			$(item,$container).animate opacity:1
			$container.isotope
				itemSelector: item
				layoutMode : 'masonry'
	dashboard: ($wrap,$cpanel) ->
		modal_init = ($modal) ->
			$current = $(".step.active",$wrap)
			$("span.title",$modal).text $current.attr("wtitle")
			$modal.attr "data-current",$current.attr("id")
			$modal.modal().on "hidden",->
				$wrap.jmpress "goTo",$current
		play_audio = ($audio) ->
			if $audio.length is 1
				unless $audio[0].src isnt ''
					$audio[0].src = $audio.attr('data')
				$audio[0].play()
		# 联想
		imagine = ($current,wid) ->
			unless $current.hasClass 'loaded'
				$current_img = $current.next()
				Utils.image_imagine $current_img
				$.get "/words/imagine?id=#{wid}",(data) ->
					html = ""
					if data.status is 0	
						if data.data.m
							$img = $current_img.find('.me img')
							$img.attr("src",data.data.m)
							$img.fadeIn()
						for img in data.data.imagine
							html += "<span class='img imagine'><img src='#{img}' /></span>" 
					$(".img_wrap",$current_img).append(html)
				$current.addClass 'loaded'
		step_handle = ($current,$cpanel,max = $(".step").length) ->
			id = $current.attr 'wid'
			play_audio($current.find("audio"))
			step = $(".step").index($current) + 1		
			percent = step*100/max
			$("#progress .current_bar").css "width": "#{percent}%"
			if $current.hasClass 'word_pic'
				$(".group-img",$cpanel).addClass 'active'
				$(".group-word",$cpanel).removeClass 'active'					
				$("input#id",$cpanel).val(id)
			else if $current.hasClass 'word_item'
				$(".group-img",$cpanel).removeClass 'active'
				$(".group-word",$cpanel).addClass 'active'
				imagine($current,id)
			else
				$(".group-img",$cpanel).removeClass 'active'
				$(".group-word",$cpanel).removeClass 'active'
		start_learn = ->
			$("#start_page").fadeOut()
			Home.menu_fade()
			$("#progress").addClass 'active'					
			step_handle($(".step.active",$wrap),$cpanel)									
			h = $(window).height()/3
			$(".group",$cpanel).css "top": "#{h}px"
			$(".step",$wrap).on 'enterStep', (e) ->
				step_handle($(e.target),$cpanel)
				put_course($(e.target).attr("id"))
		start_exam = ($exam = $("#start_exam")) ->
			$("a[href='#again']",$exam).click ->
				$wrap.jmpress "goTo",$('.step').first()
				false
			$("a[href='#exam']",$exam).click ->
				put_course(0)
				false
		put_course = (val = 1,cid = window.cid) ->
			if val is 0
				val = null
			$.cookie "course_#{cid}", val, expires: 7
		get_course = (cid = window.cid) ->
			$.cookie "course_#{cid}"
		# jmpress init		
		if $wrap.length is 1
			$wrap.jmpress
				keyboard:
					keys:
						9: null
						32: null
						37: null
						39: null
			# forbin auto loop
			$wrap.jmpress("route", "#start_exam", true)
			$wrap.jmpress("route", "#1", true, true)			
			$wrap.show()
			start_exam()
			window.cid = $("#start_page").attr 'cid'
			if step = get_course()
				$wrap.jmpress "goTo",$("##{step}")
				start_learn()
			else
				$("#start_page").fadeIn()				
				$("#top_nav").css 'opacity':'0'
				$("#startup").click ->
					put_course()
					$wrap.jmpress "goTo",$('.step').first()
					start_learn()
		# magic images
		$modal = $("#magic_images_modal")
		$("a[href='#magic']",$cpanel).click ->			
			modal_init($modal)			
			$(".magic_items a:first-child",$modal).click()
			false
		$(".magic_items a",$modal).click ->			
			provider = $(@).attr('data')
			$images_wrap = $("##{provider}",$modal)
			$(@).addClass('active').siblings().removeClass 'active'
			$(".images",$modal).hide()
			$images_wrap.show()
			unless $images_wrap.html() isnt ""
				Utils.loading $(".magic_items",$modal)
				$.get "/olive/fetch?provider=#{provider}",(data) ->
					if data.status is 0
						html = ""
						for img in data.data
							html += "<img src='#{img}' />"				
						$images_wrap.html(html)
						$('img',$images_wrap).click ->
							$img = $(@)
							Utils.loading $img								
							$current = $("#"+$modal.attr("data-current"))
							$.post "/words/select_img_u"
								id: $current.attr('wid')
								img_url: $img.attr('src')
								(data) ->
									if data.status is 0	
										$modal.modal('hide')
										$current.find('.me img').attr("src",data.data).fadeIn()
									Utils.loaded $img
					else
						if data.status is -2
							$images_wrap.html $(".errors",$modal).fadeIn()
						else
							$images_wrap.html("<div class='errors alert alert-error'>还没有任何内容哦</div>")				
					Utils.loaded $(".magic_items",$modal)
			false
		# upload image
		$("a[href='#upload']",$cpanel).click ->	
			if $("input#id",$cpanel).val() isnt "0"
				$("input[type='file']",$cpanel).trigger "click"
			false
		$upload_form = $(".group-img form",$cpanel)
		$("input[type='file']",$upload_form).change ->
			$upload_form.submit()
		# spell test
		$("a[href='#spell']",$cpanel).click ->
			false
			
		# annotate
		$("a[href='#annotate']",$cpanel).click ->
			$annotate_modal = $("#annotate_modal")			
			modal_init($annotate_modal)
			false
					
			
