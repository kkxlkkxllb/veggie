class window.Weibo
	@page: 1
	@init: ->
		weibo = new Weibo($("#home"))
		weibo.filter_provider()
	@over: ->
		$("#home").empty()
		$("#load_more").remove()
	constructor: (@$wrap) ->
		html = "<div id='load_more'>loading</div>"
		@$wrap.after(html)
		Weibo.get(true).complete ->
			$("#load_more").text("more").click ->
				Mhome.loading($(@))
				$ele = $(@)
				Weibo.get().complete ->
					Mhome.loaded($ele)
	@get: (init = false,$wrap = $("#home")) ->
		$.post("/mobile/t",{page: (Weibo.page unless init)},(data) ->
			if data.status is 0
				if init
					$wrap.html(data.data.html)
				else
					html = $(data.data.html).find(".leaf")
					if html.length is 0
						$("#load_more").unbind().text("that's all")
					else
						$wrap.append html
		,"json").complete ->
			Weibo.page++
			$(".leaf img").load ->
				lzld(this)
	filter_provider: ($wrap = @$wrap) ->
		$("a.l2p",$wrap).live "click",->
			pid = $(@).attr("pid")
			$.post("/mobile/t",{pid:pid},(data) ->
				if data.status is 0
					$wrap.html(data.data.html)
					$("#user_list").css "width":data.data.cnt*96
			,"json").complete ->
				$(".leaf img").load ->
					lzld(this)
