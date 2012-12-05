class window.Word
	@init: ->
		word = new Word($("#home"))
		word.correct_it($("#words_wrap"))
		word.reset($("#reset"),$("#words_wrap"))
	constructor: ($wrap) ->
		$.get("/mobile/word",(data) ->
			if data.status is 0
				$wrap.append(data.data.html)
		,"json")
	correct_it: ($wwrap) ->
		$(".field",$wwrap).live "click",->
			$answer = $(@).attr('rel')
			$key = $(".title",$(@).closest('.word')).attr("rel")
			if $answer is $key
				$(@).addClass "good"
			else
				Mhome.flash($answer)
	reset: ($rwrap,$wwrap) ->
		$("span.reset_btn",$rwrap).live "click",->		
			$(".field",$wwrap).removeClass("good")
			$("body").animate({scrollTop: 0},1000)
		$("span.tag_btn",$rwrap).live "click",->
			tag = $(@).attr 'rel'
			$.post("/mobile/word",ctag:tag,(data) ->
				if data.status is 0
					$wwrap.html(data.data.html)
			,"json").complete ->
				$("body").animate({scrollTop: 0},1000)
			
