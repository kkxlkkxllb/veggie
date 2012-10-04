utils = exports ? this
utils.init_masonry = ($contain,item) ->
	$contain.imagesLoaded ->	
		$(item).animate opacity: 1
		$contain.masonry
			itemSelector : item,
			isAnimated: false,
			isFitWidth: true
utils.init_infinitescroll = ($wrap) ->
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

	