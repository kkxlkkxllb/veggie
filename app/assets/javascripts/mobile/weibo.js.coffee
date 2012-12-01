weibo = exports ? this
class weibo.Weibo
	@init: ->
		weibo = new Weibo($("#home"))
		weibo.filter_provider($("#user_list"))
	constructor: (@$wrap) ->
		$.get("/mobile/t",(data) ->
			if data.status is 0
				@$wrap.append(data.data.html)
		,"json").complete ->
			@$wrap.infinitescroll
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
					@$wrap.append(newElements)
	filter_provider: ($ulist,$wrap = @$wrap) ->
		$("a.l2p",$wrap).live "click",->
			pid = $(@).attr("pid")
			$.post("/mobile/t",{pid:pid},(data) ->
				if data.status is 0
					$wrap.html(data.data.html)
			,"json").complete ->
				width = $(".user_item",$ulist).length * 96
				$ulist.css "width":width
