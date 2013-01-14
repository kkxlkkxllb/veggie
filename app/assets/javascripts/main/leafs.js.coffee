class window.Leafs
	@init: ->
		leaf = new Leafs()
		leaf.destroy_leaf()
	constructor: (@$wrap = $("#t_wrap")) ->
		Utils.infinitescroll(@$wrap)
		Utils.masonry(@$wrap,'.leaf')
		$("div.leaf").live 'hover',->
			$("span.action",$(@)).toggle()
		$(".leaf img").load ->
			lzld(this)
	destroy_leaf: ($wrap = @$wrap) ->
		$(".leaf span.destroy").live "click", ->
			ele = $(@)
			$.post "/leafs/destroy"
				id: ele.attr("lid")
				(data) ->
					if data.status is 0
						ele.closest('.leaf').remove()
						$wrap.masonry('reload')
