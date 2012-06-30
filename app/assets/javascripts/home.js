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
	
})