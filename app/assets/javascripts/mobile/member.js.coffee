class window.Member
	@init: ->
		member = new Member($("#home"))
	constructor: ($wrap) ->
		$.get("/mobile/m",(data) ->
			if data.status is 0
				$wrap.append(data.data.html)
		,"json").complete ->
			$upload_form = $("#dashboard form")
			$("#dashboard span img").click ->
				$("input[type='file']",$upload_form).trigger "click"
			$("input[type='file']",$upload_form).change ->
				$upload_form.submit()
