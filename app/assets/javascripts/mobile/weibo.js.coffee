weibo = exports ? this
weibo.get_provider = (pid) ->
	$wrap = $("#home")
	$.post "/mobile/mweibo",{pid:pid},(data) ->
		if data.status is 0
			$wrap.html(data.data.html)
	,"json"