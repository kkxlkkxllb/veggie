word = exports ? this
word.is_correct = (ele) ->
	$answer = ele.attr('rel')
	$key = $(".title",ele.closest('.word')).attr("rel")
	if $answer is $key
		ele.addClass "good"
	else
		$("#m_flash").text($answer).fadeIn()
		setTimeout("hide_flash()",5000)
word.reset_test = ->
	$(".field").removeClass("good")
	$("body").animate({scrollTop: 0},1000)
word.hide_flash = ->
	$("#m_flash").fadeOut()