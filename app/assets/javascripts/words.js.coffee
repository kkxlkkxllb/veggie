# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
word = exports ? this
word.del_word = (ele) ->
	contain = ele.closest("tr")
	title = $("td.title a",contain).text()
	$.post "/words/destroy",{title:title},(data) ->
		if data.status is 0
			contain.remove()
word.form_submit = (ele) ->
	ele.bind 'ajax:beforeSend', ->
		$("input",ele).addClass "disable_event"
		$("i.icon-plus",ele).hide()
		$("i.icon-refresh",ele).show()
		mixpanel.track("try add word")
word.detect = (ele) ->
	$modal = $("#input_tip_modal")
	input = ele.val()
	$.get "/words/search",{word:input},(data) ->
		if data.status is 0
			$modal.append("<ul></ul>").show()