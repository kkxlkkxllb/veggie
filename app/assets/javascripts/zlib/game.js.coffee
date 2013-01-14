class window.Allen
	@init: ->
		game = new Allen($("#allen"))
		game.start(Allen.random())
		game.again()
	@random: (num = 7)->
		Math.floor(Math.random()*num)
	@copy_html: (index,effect,$wrap = @$wrap) ->
		rand_num = Allen.random()
		html = $($(".weekday",$wrap)[rand_num]).html()
		$("#rand_"+index).css("top",-450).html(html).animate "top":0,(Math.random() + 1)*1000,effect
	constructor: (@$wrap) ->
	start: (rand_num) ->
		Allen.copy_html(1,"easeOutBack")
		Allen.copy_html(2,"easeOutBack")
		$("#weekdays").animate "top":-rand_num*250,1800,"easeOutBack", ->
			w = $($('.weekday')[rand_num]).text()
			r1 = $("#rand_1").text()
			r2 = $("#rand_2").text()
			if w is r1 and r1 is r2
				Utils.flash("Bingo!")
	again: ($wrap = @$wrap)->
		$("#panel a",$wrap).click ->
			game = new Allen($("#allen"))
			game.start(Allen.random())
			game.destroy	
			false
			
		
