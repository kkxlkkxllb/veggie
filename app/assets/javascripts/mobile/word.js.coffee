word = exports ? this
word.is_correct = (ele) ->
	$answer = ele.attr('rel')
	$key = $(".title",ele.closest('.word')).attr("rel")
	if $answer is $key
		ele.addClass "good"