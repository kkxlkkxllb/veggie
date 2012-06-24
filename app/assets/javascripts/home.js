$(function(){
	//瀑布流
	var $wrap = $("#home");	
	$(".leaf").css({ opacity: 0 });
	$wrap.imagesLoaded(function(){//图片加载完成再初始化插件
		$(".leaf").animate({ opacity: 1 });		
	  $wrap.masonry({
	    itemSelector : '.leaf',
			isAnimated: false,
			isFitWidth: true
	  });
	});	
	
	var $user_list = $("#user_list");
	$user_list.imagesLoaded(function(){//图片加载完成再初始化插件		
	  $user_list.masonry({
	    itemSelector : '.user_item',
			isAnimated: false,
			isFitWidth: true
	  });
	});
	
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
	
	$("div.leaf").live('hover',function(){
		$("span.action",$(this)).toggle();
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