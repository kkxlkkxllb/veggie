# 拖拽插件
# author: veggie
$.fn.drag = (options) ->
	defaults = 
		handler: false
		opacity: 0.5
		onlyX: false
		onlyY: false
	opts = $.extend(defaults, options)
	this.each ->
		isMove = false
		if opts.handler
			handler = $(@).find(opts.handler)
		else
			handler = $(@)
		handler.css 	
			"-webkit-user-select":"none"		
			"top":0
			"left":0
			
		dx = 0
		dy = 0
		$(document).mousemove (e) ->
			if isMove
				unless opts.onlyY
					eX = e.pageX			
					handler.css 'left': eX - dx
				unless opts.onlyX
					eY = e.pageY
					handler.css 'top': eY - dy
		.mouseup ->
			isMove = false
			handler.fadeTo('fast', 1)
		handler.mousedown (e) ->
			if $(e.target).is(handler) or handler.has($(e.target))
				isMove = true
				$(@).css 'cursor':'move'
				handler.fadeTo('fast', opts.opacity)
				unless opts.onlyY
					dx = e.pageX - parseInt(handler.css("left"))
				unless opts.onlyX
					dy = e.pageY - parseInt(handler.css("top"))