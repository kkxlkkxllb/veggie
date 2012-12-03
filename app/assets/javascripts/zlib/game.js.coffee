game = exports ? this
class game.Allen
	@init: ->
		allen = new Allen($("#weekdays"))
	@copy_html: (index,msec,effect,$wrap = @$wrap) ->
		rand_num = parseInt $("#rand_"+index).attr "r"
		html = $($(".weekday",$wrap)[rand_num]).html()
		$("#rand_"+index).css("top",-450).html(html).animate "top":0,msec,effect
	constructor: (@$wrap) ->
		Allen.copy_html(1,1000,"easeOutBack")
		Allen.copy_html(2,1000,"easeOutBack")
		week_day = new Date().getDay()
		$("#weekdays").animate "top":-week_day*250,1800,"easeOutBack", ->
			w = $($('.weekday')[week_day]).text()
			r1 = $("#rand_1").text()
			r2 = $("#rand_2").text()
			if w is r1 or w is r2 or r1 is r2
				Utils.flash("bingo!")
	
		
