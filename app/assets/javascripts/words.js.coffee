word = exports ? this
class word.Word
	@init: ->
		word = new Word($("#word_ground"),".word_item")
		word.after_create $("#new_word form"),$("#new_word_tag_modal")
		word.audio_play()
		word.insert_tags $("form#new_word_tag_form"),$("#new_word_tag_modal")
		word.filter_word($("#word_nav"))
		word.clone_word()
		word.viewport()
		word.img_change()
	constructor: (@$container,item) ->
		$(item,@$container).animate opacity:1
		@$container.isotope
			itemSelector: item
			layoutMode : 'masonry'
			getSortData :
				title : ( $elem ) ->
					$elem.find('span.title').text()
	after_create: ($form,$modal) ->
		$form.bind 'ajax:beforeSend', ->
			$("input",$form).addClass "disable_event"
			Utils.loading $form
		$form.bind 'ajax:success', (d,data) ->
			if data.status is 0
				$("#new_word input").val("").focus()
				$("span.wtitle",$modal).text(data.data.title)
				$("input#id",$form).val(data.data.id)
				$("input#et",$form).val(data.data.t)
				$("input#tags",$form).val("")
				$modal.modal()
			else
				Utils.flash("o_O 呃，失败了，单词没查到")
			$("input",$form).removeClass("disable_event")
			Utils.loaded $form
	audio_play: =>
		@$container.delegate "a.audio","click", ->
			$("audio",$(@))[0].play()
	insert_tags: ($form,$modal) =>
		@$container.delegate "a.itag","click", ->
			if $modal.length is 1
				$item = $(@).closest('.word_item')
				wid = $item.attr("wid")
				wtitle = $("span.title",$item).text()
				hash_tags = $("span.ctags",$item).text()
				$("span.wtitle",$modal).text(wtitle)
				$("input#tags",$form).val(hash_tags)
				$("input#id",$form).val(wid)
				$modal.modal()					
		$("button.btn",$form).click ->
			$form.submit()
		$("#tags_area").delegate "span","click", ->
			value = $("input#tags",$form).val()
			$("input#tags",$form).val("#{value}#" + $(@).text() + " ")
		$form.bind 'ajax:success', (d,data) ->
			if data.status is 0
				$modal.modal('hide')
				$("span.ctags",$item).text(data.data.title)
	filter_word: ($wrap,$container = @$container) ->
		$('ul',$wrap).find("a").click ->
			if $(@).parent('li').hasClass "active"
				false
			$(@).parent('li').addClass("active").siblings().removeClass "active"
			$container.isotope({ filter: $(@).attr('ctag') })
			false
	clone_word: =>
		@$container.delegate "a.fetch","click", ->
			ele = $(@)
			$.post "/words/clone"
				id: ele.parents('.word_item').attr("wid")
				(data) ->
					if data.status is 0
						ele.addClass "cancel"
					else if data.status is 1
						ele.removeClass "cancel"
	viewport: ($container = @$container) ->		
		$("#word_nav span.btn-group").delegate "span.btn","click", ->
			rel = $(@).attr("rel")
			$(@).addClass("active").siblings().removeClass('active')
			$(".#{rel}",$container).show().siblings().hide()
			$container.isotope()
	img_change: ($container = @$container) ->
		$container.delegate "span.change_btn","click", ->
			ele = $(@)
			ele.hide()
			$wrap = ele.closest('.word_item')
			Utils.loading $('.pic img',$wrap)
			$.post "/words/make_pic"
				id: $wrap.attr("wid")
				(data) ->
					if data.status is 0
						$('.pic img',$wrap).attr("src",data.data.pic).load ->
							$container.isotope()
							Utils.loaded $(@)
							ele.show()
