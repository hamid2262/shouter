jQuery ->
	$('span.number').click ->
		# console.log($(this).html())
		$(this).toggleClass('number_on_click')
		if $(this).hasClass('number_on_click')
			$(".seats_nums").append("<div>hello world</div>")
		else
			console.log "asd"