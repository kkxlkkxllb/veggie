$(function(){
	//瀑布流
	init_masonry($("#home"),'.leaf');	
	init_masonry($("#user_list"),'.user_item');	

	$(".icon-headphones").live('click',function(){
		var sound = $(this).next()[0];
		sound.load();
		sound.play();
		return false;
	});
	
	$("div.leaf").live('hover',function(){
		$("span.action",$(this)).toggle();
	});	
	
	$("#m_nav .banner").click(function(){
		var rel = $(this).attr("rel");
		var $wrap = $("#home");
		if(rel == "weibo"){
			var $nav = "<nav class='pagination'><a href='/mobile/mweibo?page=2'></a></nav>";
			$.post("/mobile/mweibo",function(data){
				if(data.status == 0)
					$wrap.append(data.data.html).after($nav);
				
			}).complete(function(){
				
				init_infinitescroll($wrap);
				
			});
		}
	});
})

function reload_tree(){
	$.post("/home/index",function(data){
		if(data.status == 0){
			$("#home").html(data.data.html);
			$("#home").imagesLoaded(function(){
				$("#home").masonry('reload');
			});
		}
	});
}

function grow_leaf(is_older,provider){
	var older = (is_older == 0) ? "" : 1;
	$.post("/leafs/grow",{older:older,provider:provider},function(data){
		if(data.status == 0)
			window.location.reload();
	});
}

function destroy_leaf(leaf_id,ele){
	$.post("/leafs/destroy",{id:leaf_id},function(data){
		if(data.status == 0){
			ele.closest('.leaf').remove();
			$("#home").masonry('reload');
		}
	})
}

function login(){
	$("#login_modal").modal();
}

function insert_word(){
	var word = $("input#word").val();
	$.post("/word/insert",{word:word},function(data){
		if(data.status == 0){
			window.location.reload();
		}
	})
}

function init_infinitescroll($wrap){
	$wrap.infinitescroll({
	  navSelector  : "nav.pagination",
    nextSelector : "nav.pagination a",
    itemSelector : ".leaf",
		debug        : false,
		loading: {
        finishedMsg: '这是所有咯',
				msgText : "正在努力加载更多内容...",
        img: 'http://i.imgur.com/6RMhx.gif'
      }
		},
	  // trigger Masonry as a callback
	  function( newElements ) {
	    // hide new items while they are loading
	    var $newElems = $( newElements ).css({ opacity: 0 });
	    // ensure that images load before adding to masonry layout
	    $newElems.imagesLoaded(function(){
	      // show elems now they're ready
	      $newElems.animate({ opacity: 1 });
	      $wrap.masonry( 'appended', $newElems, true ); 
	    });
	  }
  );
}

function init_masonry($contain,item){
	$(item).css({ opacity: 0 });
	$contain.imagesLoaded(function(){//图片加载完成再初始化插件	
		$(item).animate({ opacity: 1 });	
	  $contain.masonry({
	    itemSelector : item,
			isAnimated: false,
			isFitWidth: true
	  });
	});
}