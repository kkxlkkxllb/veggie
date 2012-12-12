class window.Members
	@init: ->
		member = new Members()
		member.setting($("#user_setting"))
		member.show($("#ground"),".word_item")
		member.cpanel $("#impress"),$("#magic_images_modal")
		if $("#allen").length is 1
			Allen.init()	
	constructor: ->
		$("html").addClass 'uhome'
	setting: ($wrap) ->
		$(".providers img",$wrap).tooltip()
		activeTab = $('[href=' + location.hash + ']',$wrap)
		activeTab && activeTab.tab('show')
	show: ($container,item)->
		$container.imagesLoaded ->
			$(item,$container).animate opacity:1
			$container.isotope
				itemSelector: item
				layoutMode : 'masonry'
	cpanel: ($wrap,$modal) ->
		impress().init()
		$wrap.show()
		$("a[href='#magic']",$wrap).click ->
			title = $(@).parent().attr "data"
			$modal.modal()
			Utils.loading $modal
			$.get "/olive/fetch?title=#{title}",(data) ->
				if data.status is 0
					html = ""					
					$(".modal-body",$modal).html(html)				
					Utils.loaded $modal
			false
		$("a[href='#upload']",$wrap).click ->			
			$("input[type='file']",$(@).closest('.cpanel')).trigger "click"
			false
		$("form input[type='file']",$wrap).change ->
			$(@).closest('form').submit()

					
			
