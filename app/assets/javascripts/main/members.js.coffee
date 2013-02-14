class window.Members
	@init: ->
		member = new Members()
		member.setting($("#user_setting"))
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
	dashboard: ($wrap) ->		
		play_audio = ($audio) ->
			if $audio.length is 1
				unless $audio[0].src isnt ''
					$audio[0].src = $audio.attr('data')
				$audio[0].play()
		step_handle = ($current,max = $(".step").length) ->
			id = $current.attr 'wid'	
			rel = $current.attr 'rel'
			step = $(".step").index($current) + 1		
			percent = step*100/max
			$("#progress .current_bar").css "width": "#{percent}%"
			if $current.hasClass "word_item"
				play_audio($current.find("audio"))
			unless $current.hasClass('loaded') or (rel is undefined)
				Imagine[rel]($current,id)

		start_learn = ->
			Home.menu_fade()
			$("#progress").addClass 'active'					
			step_handle($(".step.active",$wrap))									
			$(".step",$wrap).on 'enterStep', (e) ->
				step_handle($(e.target))
				put_course($(e.target).attr("id"))
			$(".record a,.speech input").tooltip()
			$(document).bind "keyup.imagine", (e) ->
				$current = $(".step.active")
				if $current.hasClass 'loaded'
					$active = $current.find(".item.active")
					$container = $current.find(".wrap")
					item_width = $active.width()
					$left = $container.position().left
					switch e.keyCode
						when 37#left
							$next = $active.next()
							if $next.length isnt 0
								$next.addClass 'active'
								$active.removeClass 'active'
								$container.css "left":($left - item_width) + "px"
							play_audio($next.find("audio"))
						when 39#right
							$prev = $active.prev()
							if $prev.length isnt 0
								$prev.addClass 'active'
								$active.removeClass 'active'
								$container.css "left":($left + item_width) + "px"
							play_audio($prev.find("audio"))
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
				mouse:
					clickSelects: false
				keyboard:
					keys:
						9: null
						37: null
						39: null
			# forbin auto loop
			$wrap.jmpress("route", "#start_exam", true)
			$wrap.jmpress("route", "#start", true, true)			
			$wrap.show()
			start_exam()
			window.cid = $("#start").attr 'cid'
			if step = get_course()
				$wrap.jmpress "goTo",$("##{step}")
			else
				put_course()
			start_learn()
			
		# upload image
		# $("a[href='#upload']",$cpanel).click ->	
		# 	if $("input#id",$cpanel).val() isnt "0"
		# 		$("input[type='file']",$cpanel).trigger "click"
		# 	false
		# $upload_form = $(".group-img form",$cpanel)
		# $("input[type='file']",$upload_form).change ->
		# 	$upload_form.submit()	
		# annotate
		$form = $(".annotate form",$wrap)
		$form.bind 'ajax:success', (d,data) ->
			if data.status is 0
				$("input[type='text']",$(@)).addClass 'done'
		$("input[type='text']",$form).focus ->
			$(@).removeClass("done")
		$("input[type='text']",$form).change ->
			$(@).closest("form").submit()
		$speech = $(".word_item .speech input")
		if document.createElement('input').webkitSpeech is undefined
			$speech.remove()
		else
			$speech.bind "webkitspeechchange", -> 
				key = $(@).attr "key"
				if $(@).val() is key
					Utils.flash("发音很准哦！","success","left")
				else
					Utils.flash("还差一点，加油！","error","right")