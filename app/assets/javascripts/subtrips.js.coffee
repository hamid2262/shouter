jQuery ->
	# $('.states_cities .cities select').parent().hide()
	cities = $('.states_cities .cities select').html()
	$('.states_cities .cities select').html('')
	$('.my-states').change ->
		# console.log(cities)
		state = $("option:selected", this).text()
		escaped_state = state.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
		options = $(cities).filter("optgroup[label='#{escaped_state}']").html()
		if options
			$(this).parent().next().children().html(options)
		else
			$(this).parent().next().children().empty('')
			
  # hide remove link from last and first
  $('.trip-route fieldset').first().find('.remove_fields').css( "display", "none" )
  $('.trip-route fieldset').last().find('.remove_fields').css( "display", "none" )
