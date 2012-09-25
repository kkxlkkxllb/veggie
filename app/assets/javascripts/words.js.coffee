# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
word = exports ? this
word.init_words_ground = ($container,item,$form) ->
	$(item,$container).animate opacity: 1
	$container.isotope
		itemSelector : item,
		layoutMode : 'masonry',
		getSortData :
			title : ( $elem ) ->
				$elem.find('span.title').text()
	init_insert_tags($form,$("#new_word_tag_modal"),$container)
	init_audio_play($container)
	init_fill_tag($form)
	init_filter($container)
	form_submit($("#new_word form"))
	init_fetch_word($container)
word.form_submit = (ele) ->
	ele.bind 'ajax:beforeSend', ->
		$("input",ele).addClass "disable_event"
	ele.bind 'ajax:success', (d,data) ->
		if data.status is 0
			$("#word_ground").isotope('insert',$(data.data.html))
			$("#new_word input").val("").focus()
			$("input",ele).removeClass("disable_event");
word.init_audio_play = ($container) ->
	$container.delegate "a.audio","click", ->
		$("audio",$(this))[0].play()
		false
word.init_insert_tags = (form,$modal,$container) ->
	$container.delegate "a.itag","click", ->
		ele = $(this)
		if $modal.length is 1
			wid = ele.parent('.word_item').attr("wid")
			wtitle = $("span.title",ele.parent('.word_item')).text()
			hash_tags = $("span.ctags",ele.parent('.word_item')).text()
			$("span.wtitle",$modal).text(wtitle)
			$("input#tags",form).val(hash_tags)
			$modal.modal()		
			$("input#id",form).val(wid)
			$("button.btn",form).click ->
				form.submit()
			form.bind 'ajax:success', (d,data) ->
				if data.status is 0
					$modal.modal('hide')
					$("span.ctags",ele.parent('.word_item')).text(data.data.title)
		false
word.init_filter = ($container) ->
	$('#filter_nav a').click ->
		$('#filter_nav a').removeClass "selected"
		$(this).addClass "selected"
		selector = $(this).attr('data-filter')
		$container.isotope({ filter: selector })
		false
word.init_fill_tag = ($form) ->
	$("#tags_area").delegate "span","click", ->
		value = $("input#tags",$form).val()
		$("input#tags",$form).val(value + "#" + $(this).text() + " ")
word.init_fetch_word = ($container) ->
	$container.delegate "a.fetch","click", ->
		ele = $(this)
		wid = ele.parent('.word_item').attr("wid")
		$.post "/words/clone",{id:wid},(data) ->
			if data.status is 0
				ele.hide()