class window.Members
	@init: ->
		member = new Members()
		member.setting($("#user_setting"))
		Utils.user_theme()
		member.show($("#user_show"),".word_item")
		member.dashboard $("#impress"),$("#magic_images_modal"),$("#cpanel")
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
	dashboard: ($wrap,$modal,$cpanel) ->
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
			percent = ($(".step").index($current) + 1)*100/max
			$("#progress .current_bar").css "width": "#{percent}%"	
			if $current.hasClass 'word_pic'
				$(".group-img",$cpanel).addClass 'active'
				$(".group-word",$cpanel).removeClass 'active'					
				$("input#id",$cpanel).val(id)
			else if $current.hasClass 'word_item'
				$(".group-img",$cpanel).removeClass 'active'
				$(".group-word",$cpanel).addClass 'active'
				imagine($current,id)
		start_learn = ->
			$("#start_page").fadeOut()
			Home.menu_fade()
			$("#progress").addClass 'active'					
			step_handle($(".step.active",$wrap),$cpanel)									
			h = $(window).height()/3
			$(".group",$cpanel).css "top": "#{h}px"
			$(".step",$wrap).on 'enterStep', (e) ->
				step_handle($(e.target),$cpanel)
				
		if $wrap.length is 1
			$wrap.jmpress
				keyboard:
					keys:
						9: null
						32: null
						37: null
						39: null
			$wrap.show()
			cid = $("#start_page").attr 'cid'
			if $.cookie "course_#{cid}"
				start_learn()
			else
				$("#start_page").fadeIn()				
				$("#top_nav").css 'opacity':'0'
				$("#startup").click ->
					$.cookie "course_#{cid}", true, expires: 7
					$wrap.jmpress "goTo",$('.step').first()
					start_learn()
		$("a[href='#magic']",$cpanel).click ->
			$modal.modal()
			false
		$("a[href='#provider']",$modal).click ->
			# deinit jmpress
			Utils.loading $(".images",$modal)
			provider = $(@).attr('data')
			$(".magic_items a").removeClass 'active'
			$(@).addClass 'active'
			$.get "/olive/fetch?provider=#{provider}",(data) ->
				if data.status is 0
					html = ""
					for img in data.data
						html += "<img src='#{img}' />"				
					$(".images",$modal).html(html)
					$('img',$(".images",$modal)).click ->
						$img = $(@)
						Utils.loading $img								
						$current = $(".step.active",$wrap)
						$.post "/words/select_img"
							id: $current.attr('wid')
							img_url: $img.attr('src')
							(data) ->
								if data.status is 0	
									$modal.modal('hide')
									$current.find('.me img').attr("src",data.data).fadeIn()
								Utils.loaded $img
				else
					$(".errors",$modal).fadeIn()
				Utils.loaded $(".images",$modal)
			false
		$("a[href='#upload']",$cpanel).click ->	
			if $("input#id",$cpanel).val() isnt "0"
				$("input[type='file']",$cpanel).trigger "click"
			false
		$upload_form = $(".group-img form",$cpanel)
		$("input[type='file']",$upload_form).change ->
			$upload_form.submit()
		$("a[href='#spell']",$cpanel).click ->
			false
		$("a[href='#annotate']",$cpanel).click ->
			false
					
			
