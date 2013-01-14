class window.Word
	@init: ->
		word = new Word($("#home"))
	@over: ->
		$("#home").empty()
	constructor: ($wrap) ->
		$.get("/mobile/word",(data) ->
			if data.status is 0
				$wrap.append(data.data.html)
		,"json").complete ->
			Word.correct_it($("#words_wrap"))
			Word.reset($("#reset"),$("#words_wrap"))
	@correct_it: ($wwrap) ->
		$(".field",$wwrap).click ->
			$answer = $(@).attr('rel')
			$key = $(".title",$(@).closest('.word')).attr("rel")
			if $answer is $key
				$(@).addClass "good"
			else
				Mhome.flash($answer)
	@reset: ($rwrap,$wwrap) ->
		$("span.reset_btn",$rwrap).click ->		
			$(".field",$wwrap).removeClass("good")
			$("body").animate({scrollTop: 0},1000)
		$("span.tag_btn",$rwrap).click ->
			tag = $(@).attr 'rel'
			$.post("/mobile/word",ctag:tag,(data) ->
				if data.status is 0
					$wwrap.html(data.data.html)
			,"json").complete ->
				$("body").animate({scrollTop: 0},1000)
				Word.correct_it($wwrap)
			
