class window.Members
	@init: ->
		member = new Members()
		member.setting($("#user_setting"))
		member.show($("#ground"),".word_item")
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
