class window.Course
	@init: ->
		word = new Course($("#word_ground"),".word_item")
		word.after_create $("#new_word form"),$("#new_word_tag_modal"),$("form#new_word_tag_form")
		word.audio_play()
		word.insert_tags $("form#new_word_tag_form"),$("#new_word_tag_modal")
		word.filter_word($("#word_nav"))
		word.img_change()
	@tag_modal: ($modal,$form,title,id,tags) ->
		$("span.wtitle",$modal).text(title)
		$("input#id",$form).val(id)
		$("input#tags",$form).val(tags)	
		$modal.modal()
	constructor: (@$container,item) ->
		$("html").addClass 'chome'
		$container = @$container
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
				Course.tag_modal($modal,$tag_form,data.data.title,data.data.id,"")
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
				Course.tag_modal($modal,$form,wtitle,wid,hash_tags)
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
	img_change: ($container = @$container,$modal = $("#editor_magic")) ->
		response = ($target,wid,params) ->
			$(".images",$modal).empty()
			Utils.loading $(".modal-header",$modal)
			$.get "/olive/magic?#{params}",(data) ->
				if data.status is 0
					html = ''
					for i in data.data
						html += "<img src='#{i}' />"
					$(".images",$modal).html(html)
					Utils.loaded $(".modal-header",$modal)
					$('img',$(".images",$modal)).click ->
						$modal.modal('hide')					
						Utils.loading $target
						img = $(@).attr('src')
						$.post "/words/fetch_img"
							id: wid
							img: img
							(data) ->
								if data.status is 0
									$target.attr("src",data.data.pic).load ->
										Utils.loaded $target
										$container.isotope()
		$container.delegate "a.change_btn","click", ->
			$modal.modal()
			$wrap = $(@).closest('.word_item')
			$target = $('.pic img',$wrap)
			wid = $wrap.attr("wid")			
			response($target,wid,"id=#{wid}")
			$("span.title",$modal).text($("span.title",$wrap).text())
			$("a.more").show().click ->
				$(@).hide()
				response($target,wid,"more=1&id=#{wid}")
				false
			false			
