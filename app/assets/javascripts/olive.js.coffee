olive = exports ? this
class olive.Olive
	@init: ->
		olive = new Olive($("#olive"))
		olive.render_view()
	constructor: (@$wrap) ->
		$(".item",@$wrap).live "click",->
			$(@).toggleClass "select"
	render_view: =>
		$(".cpanel span.tag",@$wrap).click ->
			ele = $(@)
			$.post "/olive/sync"
				provider: ele.prev().attr("rel")
				tag: ele.prev().val()
				(data) ->
					if data.status is 0
						$(".result-container",ele.closest(".tab-pane")).html(data.data.html)
						$(".item img").tooltip()