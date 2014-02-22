# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  # $('form').on 'click', '.remove_fields', (event) ->
  #   $(this).prev('input[type=hidden]').val('1')
  #   $(this).closest('fieldset').hide()
  #   event.preventDefault()
   
  # $('form').on 'click', '.add_fields', (event) ->
  #   if $('fieldset:visible').length < 5
  #     # time = new Date().getTime()
  #     time = $('fieldset:visible').length 
  #     regexp = new RegExp($(this).data('id'), 'g')
  #     $(this).before($(this).data('fields').replace(regexp, time))
  #     event.preventDefault()

    # hide remove link from last and first on change
    # $('.trip-route fieldset').find('.remove_fields').css( "display", "inline" )
    # $('.trip-route fieldset').first().find('.remove_fields').css( "display", "none" )
    # $('.trip-route fieldset').last().find('.remove_fields').css( "display", "none" )

    # cities = $('#test_origin_id').html()
    # $('.my-states').change ->
    #   # empty select tag / removing options
    #   $(this).parent().next().children().html('')
    #   # make new ooptions
    #   state = $("option:selected", this).text()
    #   escaped_state = state.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    #   options = $(cities).filter("optgroup[label='#{escaped_state}']").html()
    #   if options
    #     $(this).parent().next().children().html(options)
    #   else
    #     $(this).parent().next().children().empty('')
  # hide remove link from last and first
  # $('.trip-route fieldset').first().find('.remove_fields').css( "display", "none" )
  # $('.trip-route fieldset').last().find('.remove_fields').css( "display", "none" )


  # 
  $('#trip_subtrips_attributes_3_origin_address').closest('fieldset').hide()
  $('#trip_subtrips_attributes_2_origin_address').closest('fieldset').hide()
  $('#trip_subtrips_attributes_1_origin_address').closest('fieldset').hide()

  $('#trip_subtrips_attributes_0_origin_address').addClass('required')
  $('#trip_subtrips_attributes_4_origin_address').addClass('required')

  $('.trip-route fieldset').first().find('.remove_fields1').css( "display", "none" )
  $('.trip-route fieldset').last().find('.remove_fields1').css( "display", "none" )

  $('#trip_subtrips_attributes_4_origin_address').closest('fieldset').find($('.add_fields1')).show()
  
  $('form').on 'click', '.add_fields1', (event) ->
    $('fieldset:hidden').first().show()
    event.preventDefault()
  
  $('form').on 'click', '.remove_fields1', (event) ->
    $(this).closest('fieldset').hide()
    event.preventDefault()


    