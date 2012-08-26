root = exports ? this
root.init_masonry = ($contain,item) ->
	$contain.imagesLoaded ->	
		$(item).animate opacity: 1
		$contain.masonry
			itemSelector : item,
			isAnimated: false,
			isFitWidth: true
root.init_infinitescroll = ($wrap) ->
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
      $newElems = $( newElements ).css opacity: 0
      $newElems.imagesLoaded ->
        $newElems.animate opacity: 1
        $wrap.masonry( 'appended', $newElems, true )
root.reload_tree =->
	$wrap = $("#home")
	$.post "/home/index",(data) ->
		if data.status is 0
			$wrap.html(data.data.html)
			$wrap.imagesLoaded ->
				$wrap.masonry('reload')
	,"json"
root.grow_leaf = (is_older,provider) ->
	if is_older is 0
		older = ""
	else
		older = 1
	$.post "/leafs/grow",{older:older,provider:provider},(data) ->
		if data.status is 0
			window.location.reload()
root.destroy_leaf = (leaf_id,ele) ->
	$.post "/leafs/destroy",{id:leaf_id},(data) ->
		if data.status is 0
			ele.closest('.leaf').remove()
			$("#home").masonry('reload')
root.login =->
	$("#login_modal").modal()
root.add_provider_view =->
	$("#new_provider_modal").modal()
	form = $("form#new_provider_form")
	$("span.btn-group span.btn",form).click ->
		rel = $(this).attr 'rel'
		$(this).addClass("actived").siblings().removeClass("actived")
		$("#provider_provider",form).val(rel)
	form.bind 'ajax:success', (data) ->
		if data.status is 0
			$("#new_provider_modal").modal('hide')
		else
			smoke.signal "没成功"
root.init_info =->
	impress().init()