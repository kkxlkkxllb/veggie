member = exports ? this
class member.Members
	@init: ->
		member = new Members($("#user_setting"))		
	constructor: (@$wrap) ->
		$(".providers img",@$wrap).tooltip()
		activeTab = $('[href=' + location.hash + ']',@$wrap)
		activeTab && activeTab.tab('show')
