class window.Members
	@init: ->
		member = new Members()
		member.setting($("#user_setting"))
		member.show($("#ground"),".word_item")
		member.cpanel $("#ground .cpanel"),$("#magic_images_modal")
		if $("#allen").length is 1
			Allen.init()	
	constructor: ->
	setting: ($wrap) ->
		$(".providers img",$wrap).tooltip()
		activeTab = $('[href=' + location.hash + ']',$wrap)
		activeTab && activeTab.tab('show')
	show: ($container,item)->
		$(item,$container).animate opacity:1
		$container.isotope
			itemSelector: item
			layoutMode : 'masonry'
	cpanel: ($wrap,$modal) ->
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
					
			
