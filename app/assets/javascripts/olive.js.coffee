olive = exports ? this
class olive.Olive
	@init: ->
		olive = new Olive($("#olive"))
		olive.render_view()
		olive.publish($(".cpanel span.publish"))
	constructor: (@$wrap) ->
		$(".item",@$wrap).live "click",->
			$(@).toggleClass "select"
	render_view: =>
		$(".cpanel span.btn-success",@$wrap).click ->
			ele = $(@)
			ele.addClass "disabled"			
			cp = ele.closest(".tab-pane")
			Utils.loading cp
			param = ele.attr("rel")
			$input = $("input[name='#{param}']",cp)
			arg = {}
			if $input.length is 1
				arg[param] = $input.val()
			arg["provider"] = cp.attr("id")
			$.post "/olive/sync",arg,(data) ->
					if data.status is 0
						$(".result-container",ele.closest(".tab-pane")).html(data.data.html)
						$(".item img").tooltip()
						ele.removeClass "disabled"
						Utils.loaded cp
	publish: ($btn) ->
		$btn.click ->
			$wrap = $(@).closest(".tab-pane")
			data = []
			for img in $(".item.select img",$wrap)				
				data.push JSON.stringify 
					'photo':$(img).attr("src")
					'caption':$(img).attr("data-original-title")
			$.post "/olive/publish"
				data: data