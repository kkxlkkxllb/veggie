# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
word = exports ? this
word.form_submit = (ele) ->
	ele.bind 'ajax:beforeSend', ->
		$("input",ele).addClass "disable_event"
		$("i.icon-plus",ele).hide()
		$("i.icon-refresh",ele).parent().show()
		mixpanel.track("try add word")
word.init_words_ground = ->
	$container = $("#word_ground")
	$container.toggle(
		-> 
			$container.isotope
				layoutMode : 'masonry'
		->
			$container.isotope
				layoutMode : 'straightDown'
	)
	$container.isotope
		itemSelector : '.word_item',
		layoutMode : 'straightDown',
		getSortData :
			title : ( $elem ) ->
			  $elem.find('span.title').text()