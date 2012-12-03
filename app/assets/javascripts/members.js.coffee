member = exports ? this
class member.Members
	@init: ->
		member = new Members($("#user_setting"))
		if $("#allen").length is 1
			Allen.init()	
	constructor: (@$wrap) ->
		$(".providers img",@$wrap).tooltip()
		activeTab = $('[href=' + location.hash + ']',@$wrap)
		activeTab && activeTab.tab('show')
