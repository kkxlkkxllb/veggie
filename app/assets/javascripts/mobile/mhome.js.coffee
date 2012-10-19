# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	$wrap = $("#home")
	$("#m_nav_back").click ->
		$(this).hide()		
		$wrap.infinitescroll("destroy").html("")
		$("#m_nav").show()
	$("#m_nav .menu").click ->
		rel = $(this).attr "rel"		
		$("#m_nav_back").show()
		$("#m_nav").hide()
		switch rel
			when "weibo"
				$.get("/mobile/t",(data) ->
					if data.status is 0
						$wrap.append(data.data.html)
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
			when "en"
				$.get("/mobile/word",(data) ->
					if data.status is 0
						$wrap.append(data.data.html)
				,"json").complete ->
					$("span.reset_btn").bind 'click',->
						reset_test()
					$("span.tag_btn").click ->
						load_ctag($(this).attr 'rel')
			else
				false