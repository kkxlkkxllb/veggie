utils = exports ? this
class utils.Utils
	@loading: ($item) ->
		$item.queue (next) ->
			$(@).animate({opacity: 0.2},800).animate({opacity: 1},800)
			$(@).queue(arguments.callee)
			next()
	@loaded: ($item) ->
		$item.stop(true).css "opacity",1
	@infinitescroll: ($wrap) ->
		$wrap.infinitescroll
	    navSelector  : "nav.pagination",
	    nextSelector : "nav.pagination a",
	    itemSelector : ".leaf",
	    debug        : false,
	    loading: 
	      finishedMsg: '这是所有咯',
	      msgText : "正在努力加载更多内容...",
	      img: 'http://i.imgur.com/6RMhx.gif'
	    ,
	    (newElements) ->
	      $newElems = $( newElements ).css opacity: 0
	      $newElems.imagesLoaded ->
	        $newElems.animate opacity: 1
	        $wrap.masonry( 'appended', $newElems, true )
	@masonry: ($contain,item) ->
		$contain.imagesLoaded ->	
			$(item).animate opacity: 1
			$contain.masonry
				itemSelector : item,
				isAnimated: false,
				isFitWidth: true