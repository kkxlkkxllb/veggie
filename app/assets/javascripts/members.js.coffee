member = exports ? this
class member.Member
	@init: ->
		member = new Member($("#user_setting"))		
	constructor: (@$wrap) ->
		$(".providers img",@$wrap).tooltip()