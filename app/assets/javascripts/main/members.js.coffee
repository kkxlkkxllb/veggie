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
				img = $current_img.find("span.origin img")
				img.attr("src",img.attr('data'))
				$.get "/words/imagine?id=#{wid}",(data) ->
					html = ""
					if data.status is 0	
						if data.data.m
							$current_img.find('.me img').attr "src",data.data.m		
						for img in data.data.imagine
							html += "<span class='img imagine'><img src='#{img}' /></span>" 
					$(".img_wrap",$current_img).append(html)
				$current.addClass 'loaded'
		step_handle = ($current,$cpanel) ->
			id = $current.attr 'wid'
			play_audio($current.find("audio"))				
			if $current.hasClass 'word_pic'
				$(".group-img",$cpanel).addClass 'active'
				$(".group-word",$cpanel).removeClass 'active'					
				$("input#id",$cpanel).val(id)
			else
				$(".group-img",$cpanel).removeClass 'active'
				$(".group-word",$cpanel).addClass 'active'
				imagine($current,id)
				
		if $wrap.length is 1
			$wrap.jmpress
				keyboard:
					keys:
						9: null
						32: null
						37: null
						39: null
						
			step_handle($(".step.active",$wrap),$cpanel)
			Home.menu_fade()
			$wrap.show()
			h = $(window).height()/3
			$(".group",$cpanel).css "top": "#{h}px"
			$(".step",$wrap).on 'enterStep', (e) ->
				step_handle($(e.target),$cpanel)
		$("a[href='#magic']",$cpanel).click ->
			$modal.modal()
			false
		$("a[href='#provider']",$modal).click ->
			Utils.loading $modal
			provider = $(@).attr('data')
			$.get "/olive/fetch?provider=#{provider}",(data) ->
				if data.status is 0
					html = ""					
					$(".images",$modal).html(html)				
					Utils.loaded $modal
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
					
			
