$ ->
	status = $(".status").text()
	mixpanel.track(status)