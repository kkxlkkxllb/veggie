game = exports ? this
game.copy_html = (index,msec,effect) ->
	rand_num = parseInt $("#rand_"+index).attr "r"
	html = $($(".weekday")[rand_num]).html()
	$("#rand_"+index).css("top",-450).html(html).animate "top":0,msec,effect
game.allen_game =->
	if $("#allen_game").length is 1
		copy_html(1,1000,"easeOutBack")
		copy_html(2,1000,"easeOutBack")
		week_day = new Date().getDay()
		$("#weekdays").animate "top":-week_day*250,1800,"easeOutBack", ->
			w = $($('.weekday')[week_day]).text()
			r1 = $("#rand_1").text()
			r2 = $("#rand_2").text()
	#		if w is r1 or w is r2 or r1 is r2
	#			console.log("bingo")