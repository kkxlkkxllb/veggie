class window.Olive
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
			if ele.parents(".btn-group").length is 1
				arg["feature"] = ele.attr("rel")
			arg["provider"] = cp.attr("id")
			$.post "/olive/sync",arg,(data) ->
				if data.status is 0
					$(".result-container",ele.closest(".tab-pane")).html(data.data.html)
					$(".item img").tooltip()
				else
					Utils.flash("o_O 呃，失败了，没搜索到相关内容")
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
				(data) ->
					if data.status is 0
						Utils.flash "(o_o) 成功执行#{data.data.num}个任务"
