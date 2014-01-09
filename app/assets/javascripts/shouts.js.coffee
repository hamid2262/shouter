# show and hide remove buttom for shouts
$ ->
	$(".shout").hover (event) ->
		$(this).toggleClass("hover")
