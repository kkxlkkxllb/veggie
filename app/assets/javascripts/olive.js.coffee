# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
olive = exports ? this
olive.init_olive = ->
	init_tagged_input("#olive")
olive.init_tagged_input = ($wrap) ->
	$container = $('.result-container',$wrap)
	$(".item",$container).live "click", ->
		$(this).toggleClass("select")
	$(".cpanel span.tag",$wrap).click ->
		provider = $(this).prev().attr("rel")
		tag = $(this).prev().val()
		$section = $(this).closest("section")
		$.post "/olive/sync",{provider:provider,tag:tag},(data) ->
			if data.status is 0
				$(".result-container",$section).html(data.data.html)
				$(".item img").tooltip()