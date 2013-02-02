class window.MagicModal
	@hide: ->
		$(".magic_modal").removeClass 'show'
		$('a',$("#cpanel")).removeClass 'disable_event'
		$(".step.active").removeClass 'opacity'
	constructor: (@$modal) ->
		$(".step.active").addClass 'opacity'	
		@$modal.addClass 'show'
		$('a',$("#cpanel")).addClass 'disable_event'
	init_images: ($modal = @$modal,self = this) ->		
		$images_wrap = $(".images",$modal)			
		if $images_wrap.find('img').length is 0
			$.get "/olive/fetch",(data) ->
				if data.status is 0
					html = ""
					for img in data.data
						html += "<img class='pic' src='#{img}' />"				
					$images_wrap.html(html)					
					self.enable_key_control($images_wrap,data.data.length)
					self.enable_click_image($images_wrap)	
				else
					$images_wrap.html $(".error",$modal).html()
	# key control for magic image
	# per screen 7 images 
	# image width: 110px
	enable_key_control: ($scroll_row,ele_size,$modal = @$modal) ->
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
						MagicModal.hide()
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
	enable_click_image: ($scroll_row,$modal = @$modal) ->
		$('img',$scroll_row).click ->
			MagicModal.hide()
			$img = $(@)					
			$current = $(".step.active")							
			$target = $current.find('.me img')	
			Utils.loading $target.show()											
			$.post "/words/select_img_u"
				id: $current.attr('wid')
				img_url: $img.attr('src')
				(data) ->
					if data.status is 0	
						$target.attr("src",data.data)
					Utils.loaded $target