# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
word = exports ? this
word.form_submit = (ele) ->
	ele.bind 'ajax:beforeSend', ->
		$("input",ele).addClass "disable_event"
	ele.bind 'ajax:success', (d,data) ->
		if data.status is 0
			$("#word_ground").isotope('insert',$(data.data.html))
			$("#new_word input").val("").focus()
			$("input",ele).removeClass("disable_event");
word.audio_play = (ele) ->
	$("audio",ele)[0].play()
word.insert_tags = (ele) ->
	$modal = $("#new_word_tag_modal")
	if $modal.length is 1
		wid = ele.attr("wid")
		form = $("form#new_word_tag_form")
		wtitle = $("span.title",ele.parent('.word_item')).text()
		$("span.wtitle",$modal).text(wtitle)
		$("input#tags",form).val(ele.attr('data-original-title'))
		$modal.modal()		
		$("input#id",form).val(wid)
		$("button.btn",form).click ->
			form.submit()
		form.bind 'ajax:success', (d,data) ->
			if data.status is 0
				$modal.modal('hide')
				ele.attr("title",data.data.title)
word.init_words_ground = ($container,item) ->
	$(item,$container).animate opacity: 1
	$container.isotope
		itemSelector : item,
		layoutMode : 'masonry',
		getSortData :
			title : ( $elem ) ->
				$elem.find('span.title').text()
word.init_filter = ($container) ->
	$('#filter_nav a').click ->
		$('#filter_nav a').removeClass "selected"
		$(this).addClass "selected"
		selector = $(this).attr('data-filter')
		$container.isotope({ filter: selector })
		false