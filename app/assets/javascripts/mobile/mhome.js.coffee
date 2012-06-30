# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	$("#m_nav .banner").click ->
		rel = $(this).attr "rel"
		$wrap = $("#home")
		if rel is "weibo"
			$nav = "<nav class='pagination'><a href='/mobile/mweibo?page=2'></a></nav>"
			$.post("/mobile/mweibo",(data) ->
				if data.status is 0
					$wrap.append(data.data.html).after($nav)
			,"json").complete ->
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