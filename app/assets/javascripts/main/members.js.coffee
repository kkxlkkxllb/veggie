class window.Members
	@init: ->
		member = new Members()
		member.setting($("#user_setting"))
		Utils.user_theme()
		member.show($("#user_show"),".word_item")
		member.dashboard $("#impress"),$("#magic_images_modal")
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
	dashboard: ($wrap,$modal) ->
		if $wrap.length is 1
			impress().init()
			$wrap.show()
			api = impress()
			$(document).on 'impress:stepenter', (e) ->
				audio = $(e.target).find("audio")[0]
				if audio
					audio.play()
		$("a[href='#magic']",$wrap).click ->
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
		$("a[href='#upload']",$wrap).click ->			
			$("input[type='file']",$(@).closest('.cpanel')).trigger "click"
			false
		$("form input[type='file']",$wrap).change ->
			$(@).closest('form').submit()

					
			
