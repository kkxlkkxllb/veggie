class window.Leafs
	@init: ->
		leaf = new Leafs()
		leaf.destroy_leaf()
	constructor: (@$wrap = $("#t_wrap")) ->
		Utils.infinitescroll(@$wrap)
		Utils.masonry(@$wrap,'.leaf')
		$(".leaf img").load ->
			lzld(this)
		$(document).bind "keyup.leaf",(e)->
			if e.keyCode is 17
				$(".leaf .action").toggle()
	destroy_leaf: ($wrap = @$wrap) ->
		$(".leaf").on "click","span.destroy", ->
			ele = $(@)
			$.post "/leafs/destroy"
				id: ele.attr("lid")
				(data) ->
					if data.status is 0
						ele.closest('.leaf').remove()
						$wrap.masonry('reload')
