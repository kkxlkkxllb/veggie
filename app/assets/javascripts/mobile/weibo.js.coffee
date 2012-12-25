class window.Weibo
	@page: 1
	@init: ->
		weibo = new Weibo($("#home"))
		Weibo.get()
		weibo.filter_provider()
		weibo.more($("#load_more"))
	constructor: (@$wrap) ->
	more: ($ele)->
		$('a',$ele).click ->
			Weibo.get()
			false
	@get: (pid = null,$wrap = $("#home")) ->
		$.post("/mobile/t",{page: @page},(data) ->
			if data.status is 0
				$wrap.append(data.data.html)
		,"json").complete ->
			@page++
			$(".leaf .img img").load ->
				lzld(this)
	filter_provider: ($wrap = @$wrap) ->
		$("a.l2p",$wrap).live "click",->
			pid = $(@).attr("pid")
			$.post("/mobile/t",{pid:pid},(data) ->
				if data.status is 0
					$wrap.html(data.data.html)
					$("#user_list").css "width":data.data.cnt*96
			,"json").complete ->
				$(".leaf .img img").load ->
					lzld(this)
