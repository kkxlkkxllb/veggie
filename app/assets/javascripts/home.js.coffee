home = exports ? this
class home.Home
	@init: ->
		home = new Home()
		home.add_provider_view $("#new_provider_modal"),$("form#new_provider_form")
		home.info($("#impress"))
		if $("#top_nav").length is 0
			$("html").addClass("home")
	constructor: ->
		Utils.masonry($("#user_list"),'.user_item')
	add_provider_view: ($modal,$form) ->
		$("#add_new_btn").click ->
			$modal.modal()
			$("span.btn-group span.btn",$form).click ->
				rel = $(@).attr 'rel'
				$(@).addClass("actived").siblings().removeClass("actived")
				$("#provider_provider",$form).val(rel)
			$form.bind 'ajax:success', (d,data) ->
				if data.status is 0
					$modal.modal('hide')
	info: ($wrap)->
		if $wrap.length is 1 and !$('body').hasClass("impress-not-supported")
			impress().init()
			$wrap.show()
			api = impress()
