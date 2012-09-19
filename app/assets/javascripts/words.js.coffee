# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
word = exports ? this
word.form_submit = (ele) ->
	ele.bind 'ajax:beforeSend', ->
		$("input",ele).addClass "disable_event"
word.audio_play = (ele) ->
	$("audio",ele)[0].play()
word.init_words_ground = ($container,item) ->
	$(item,$container).animate opacity: 1
	$container.isotope
		itemSelector : item,
		layoutMode : 'masonry',
		getSortData :
			title : ( $elem ) ->
			  $elem.find('span.title').text()