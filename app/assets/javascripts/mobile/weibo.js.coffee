class window.Weibo
	@init: ->
		weibo = new Weibo($("#home"))
		weibo.filter_provider()
	constructor: (@$wrap) ->
		$wrap = @$wrap
		$.get("/mobile/t",(data) ->
			if data.status is 0
				$wrap.append(data.data.html)
		,"json").complete ->
			$(".leaf .img img").load ->
				lzld(this)
			$wrap.infinitescroll
				navSelector  : "nav.pagination",
				nextSelector : "nav.pagination a",
				itemSelector : ".leaf",
				debug        : false,
				loading: 
					finishedMsg: '这是所有咯',
					msgText : "正在努力加载更多内容...",
					img: 'http://i.imgur.com/6RMhx.gif'
	     	,
				(newElements) ->
					$wrap.append(newElements)
					$(".img img",$( newElements )).load ->
						lzld(this)
	filter_provider: ($wrap = @$wrap) ->
		$("a.l2p",$wrap).live "click",->
			pid = $(@).attr("pid")
			$.post("/mobile/t",{pid:pid},(data) ->
				if data.status is 0
					$wrap.html(data.data.html)
					$("#user_list").css "width":data.data.cnt*96
			,"json")
