weibo = exports ? this
weibo.get_provider = (pid) ->
	$wrap = $("#home")
	$.post("/mobile/t",{pid:pid},(data) ->
		if data.status is 0
			$wrap.html(data.data.html)
	,"json").complete ->
		width = $("#user_list .user_item").length * 96
		$("#user_list").css "width":width