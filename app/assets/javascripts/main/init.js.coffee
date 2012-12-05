$ ->
	page = $("body").attr("data-js")
	window[$.string(page).capitalize().str].init()
	mixpanel.track("new visitor")
