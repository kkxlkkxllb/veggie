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
		# control magic_image_modal 'show'&'hide'
		magic_image = (action,$current = $(".step.active",$wrap)) ->
			$modal = $("#magic_images_modal")
			if action is 'show'
				$current.addClass 'opacity'	
				$modal.addClass 'show'
				$('a',$cpanel).addClass 'disable_event'
			else
				$current.removeClass 'opacity'
				$modal.removeClass 'show'
				$('a',$cpanel).removeClass 'disable_event'
			$modal
		# key control for magic image
		# per screen 7 images 
		# image width: 110px
		enable_key_control = ($modal,$scroll_row,ele_size)->
			$scroll_row.css "width":ele_size*110
			screen_width = $modal.width()
			if ele_size%7 is 0
				screen_count = ele_size/7
			else 
				screen_count = parseInt(ele_size/7) + 1
			current_screen = 1
			$num = $(".badge",$modal).text "1 / #{screen_count}"
			$(document).bind "keyup.magic", (e) ->
				if $modal.hasClass 'show'					
					switch e.keyCode
						when 27
							magic_image('hide')
							false
						when 37 #left
							current_screen++
							if current_screen > screen_count						
								current_screen = 1
						when 39 #right
							current_screen--
							if current_screen < 1
								current_screen = screen_count
					target_offset = (1 - current_screen)*screen_width
					$scroll_row.animate left:"#{target_offset}px",500,'easeInOutQuart'
					$num.text "#{current_screen} / #{screen_count}"
		enable_click_image = ($scroll_row) ->
			$('img',$scroll_row).click ->
				magic_image('hide')
				$img = $(@)					
				$current = $(".step.active",$wrap)							
				$target = $current.find('.me img')	
				Utils.loading $target.show()											
				$.post "/words/select_img_u"
					id: $current.attr('wid')
					img_url: $img.attr('src')
					(data) ->
						if data.status is 0	
							$target.attr("src",data.data)
						Utils.loaded $target
		play_audio = ($audio) ->
			if $audio.length is 1
				unless $audio[0].src isnt ''
					$audio[0].src = $audio.attr('data')
				$audio[0].play()
		# 联想
		imagine = ($current,wid) ->
			unless $current.hasClass 'loaded'
				Utils.image_imagine $current
				$.get "/words/imagine?id=#{wid}",(data) ->
					html = ""
					if data.status is 0	
						if data.data.m
							$img = $current.find('.me img')
							$img.attr("src",data.data.m)
							$img.fadeIn()
						for img in data.data.imagine
							html += "<span class='img imagine'><img src='#{img}' /></span>" 
					$(".img_wrap",$current).append(html)
				$current.addClass 'loaded'
		step_handle = ($current,$cpanel,max = $(".step").length) ->
			id = $current.attr 'wid'
			play_audio($current.find("audio"))
			step = $(".step").index($current) + 1		
			percent = step*100/max
			$("#progress .current_bar").css "width": "#{percent}%"
			magic_image('hide')
			if $current.hasClass 'word_pic'
				$(".group-img",$cpanel).addClass 'active'
				$(".group-word",$cpanel).removeClass 'active'					
				$("input#id",$cpanel).val(id)
				imagine($current,id)
			else if $current.hasClass 'word_item'
				$(".group-img",$cpanel).removeClass 'active'
				$(".group-word",$cpanel).addClass 'active'
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
		$("a[href='#magic']",$cpanel).click ->				
			$current = $(".step.active",$wrap)	
			$modal = magic_image('show')		
			$images_wrap = $(".images",$modal)			
			if $images_wrap.find('img').length is 0
				$.get "/olive/fetch",(data) ->
					if data.status is 0
						html = ""
						for img in data.data
							html += "<img class='pic' src='#{img}' />"				
						$images_wrap.html(html)
						enable_key_control($modal,$images_wrap,data.data.length)
						enable_click_image($images_wrap)											
					else
						$images_wrap.html $(".error",$modal).html()		
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

			false
					
			
