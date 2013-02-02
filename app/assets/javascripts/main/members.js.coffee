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
		
		play_audio = ($audio) ->
			if $audio.length is 1
				unless $audio[0].src isnt ''
					$audio[0].src = $audio.attr('data')
				$audio[0].play()
		# 联想
		imagine = ($current,wid) ->
			$current_images = $current.next()
			unless $current.hasClass 'loaded'
				Utils.image_imagine $current_images
				$.get "/words/imagine?id=#{wid}",(data) ->
					html = ""
					if data.status is 0	
						if data.data.content
							$(".annotate input[type='text']",$current).val(data.data.content).addClass 'done'
						if data.data.img
							$img = $current_images.find('.me img')
							$img.attr("src",data.data.img)
							$img.fadeIn()
						for img in data.data.imagine
							html += "<span class='img imagine'><img src='#{img}' /></span>" 
					$(".img_wrap",$current_images).append(html)
				$current.addClass 'loaded'
		step_handle = ($current,$cpanel,max = $(".step").length) ->
			id = $current.attr 'wid'
			play_audio($current.find(".original audio"))
			step = $(".step").index($current) + 1		
			percent = step*100/max
			$("#progress .current_bar").css "width": "#{percent}%"
			MagicModal.hide()
			if $current.hasClass 'word_pic'
				$(".group-img",$cpanel).addClass 'active'
				$(".group-word",$cpanel).removeClass 'active'					
				$("input#id",$cpanel).val(id)
				imagine($current.prev(),id)
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
		$("a[href='#magic']",$cpanel).click ->				
			modal = new MagicModal $("#magic_images_modal")	
			modal.init_images()
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
		#audio
		$("a[href='#voice']",$cpanel).click ->
			modal = new MagicModal $("#audio_input_modal")
			modal.init_audios()
			false		
		# annotate
		$form = $(".annotate form",$wrap)
		$form.bind 'ajax:success', (d,data) ->
			if data.status is 0
				$("input[type='text']",$(@)).addClass 'done'
		$("input[type='text']",$form).focus ->
			$(@).removeClass("done")
		$("input[type='text']",$form).change ->
			$(@).closest("form").submit()
