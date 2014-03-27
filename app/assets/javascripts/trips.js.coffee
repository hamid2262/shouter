# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#trip_subtrips_attributes_3_origin_address').closest('fieldset').hide()
  $('#trip_subtrips_attributes_2_origin_address').closest('fieldset').hide()
  $('#trip_subtrips_attributes_1_origin_address').closest('fieldset').hide()

  $('#trip_subtrips_attributes_0_origin_address').addClass('required')
  $('#trip_subtrips_attributes_4_origin_address').addClass('required')

  $('.trip-route fieldset').first().find('.remove_fields').css( "display", "none" )
  $('.trip-route fieldset').last().find('.remove_fields').css( "display", "none" )

  $('#trip_subtrips_attributes_4_origin_address').closest('fieldset').find($('.add_fields')).show()
  
  $('form').on 'click', '.add_fields', (event) ->
    $('fieldset:hidden').first().show()
    event.preventDefault()
  
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).closest('fieldset').hide()
    event.preventDefault()


# select_admin   
  drivers = $('#admin #trip_driver_id').html()
  $('#admin #trip_driver_id').empty('')
  $('#admin #temp1_temp_id').change ->
    branch = $("option:selected", this).text()
    escaped_state = branch.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(drivers).filter("optgroup[label='#{escaped_state}']").html()
    console.log options
    if options
      $('#admin #trip_driver_id').html(options)
    else
      $('#admin #trip_driver_id').empty('')

# select_period
  $('#period_periodic').click ->
    if ($(this).is(':checked'))
      $('#wdays').show()
  $('#period_once').click ->
    if ($(this).is(':checked'))
      $('#wdays').hide()
