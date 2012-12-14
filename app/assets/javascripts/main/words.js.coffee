class window.Words
	@init: ->
		word = new Words($("#word_ground"),".word_item")
		word.after_create $("#new_word form"),$("#new_word_tag_modal"),$("form#new_word_tag_form")
		word.audio_play()
		word.insert_tags $("form#new_word_tag_form"),$("#new_word_tag_modal")
		word.filter_word($("#word_nav"))
		word.clone_word()
		word.img_change()
	@tag_modal: ($modal,$form,title,id,tags) ->
		$("span.wtitle",$modal).text(title)
		$("input#id",$form).val(id)
		$("input#tags",$form).val(tags)	
		$modal.modal()
	constructor: (@$container) ->
		$container = @$container
		
	open_course: (cid,item,$wrap = $("#course_wrap")) ->
		$("#course_catelog").hide()
		$.get "/words/course"
			cid: cid
			(data) ->
				if data.status is 0
					$wrap.html JST['course'](data.data)
					$container = $("#word_ground")
					$container.imagesLoaded ->
						$(item,$container).animate opacity:1
						$container.isotope
							itemSelector: item
							layoutMode : 'masonry'
	after_create: ($form,$modal,$tag_form) ->
		$form.bind 'ajax:beforeSend', ->
			$("input",$form).addClass "disable_event"
			Utils.loading $form
		$form.bind 'ajax:success', (d,data) ->
			if data.status is 0				
				$("#new_word input").val("")
				Words.tag_modal($modal,$tag_form,data.data.title,data.data.id,"")
			else
				Utils.flash("o_O 呃，失败了，单词没查到")
			$("input",$form).removeClass("disable_event")
			Utils.loaded $form
	audio_play: =>
		@$container.delegate "a.audio","click", ->
			$("audio",$(@))[0].play()
			false
	insert_tags: ($form,$modal) =>
		@$container.delegate "a.itag","click", ->
			if $modal.length is 1
				$item = $(@).closest('.word_item')
				wid = $item.attr("wid")
				wtitle = $("span.title",$item).text()
				hash_tags = $("span.ctags",$item).text()
				Words.tag_modal($modal,$form,wtitle,wid,hash_tags)
			false
		$("button.btn",$form).click ->
			$form.submit()
		$("span.btn-danger",$form).click ->
			$("input#tags",$form).val("")
		$("#tags_area").delegate "span","click", ->
			value = $("input#tags",$form).val()
			$("input#tags",$form).val("#{value}#" + $(@).text() + " ")
		$form.bind 'ajax:success', (d,data) ->
			if data.status is 0
				$modal.modal('hide')
				Utils.flash(data.data.tags)
	filter_word: ($wrap,$container = @$container) ->
		$('ul',$wrap).find("a").click ->
			if $(@).hasClass "pink"
				false
			$('ul',$wrap).find("a.pink").removeClass("pink").addClass("green")
			$(@).removeClass("green").addClass("pink")
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
					else
						console.log "login required"
			false
	img_change: ($container = @$container) ->
		$container.delegate "span.change_btn","click", ->
			ele = $(@)
			ele.hide()
			$wrap = ele.closest('.word_item')
			Utils.loading $('.pic img',$wrap)
			$.post "/words/fetch_img"
				id: $wrap.attr("wid")
				(data) ->
					if data.status is 0
						$('.pic img',$wrap).attr("src",data.data.pic).load ->
							$container.isotope()
							Utils.loaded $(@)
							ele.show()
