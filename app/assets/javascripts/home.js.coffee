root = exports ? this
root.reload_tree =->
	$wrap = $("#home")
	$.post "/home/index",(data) ->
		if data.status is 0
			$wrap.html(data.data.html)
			$wrap.imagesLoaded ->
				$wrap.masonry('reload')
	,"json"
root.init_destroy_leaf = ->
	$(".leaf").delegate "span.destroy","click", ->
		ele = $(this)
		$.post "/leafs/destroy",{id:ele.attr("lid")},(data) ->
			if data.status is 0
				ele.closest('.leaf').remove()
				$("#home").masonry('reload')
root.add_provider_view =->
	$modal = $("#new_provider_modal")
	$modal.modal()
	form = $("form#new_provider_form")
	$("span.btn-group span.btn",form).click ->
		rel = $(this).attr 'rel'
		$(this).addClass("actived").siblings().removeClass("actived")
		$("#provider_provider",form).val(rel)
	form.bind 'ajax:success', (d,data) ->
		if data.status is 0
			$modal.modal('hide')
root.init_info =->
	impress().init()
	$("#impress").show()