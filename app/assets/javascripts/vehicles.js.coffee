jQuery ->
  vehicle_models = $('#test_vehicle_model_id').html()
  $('#new_vehicle #vehicle_vehicle_model_id').html('')
  $('.my-brand').change ->
    # empty select tag / removing options
    $('#vehicle_vehicle_model_id').html('')
    # make new ooptions
    brand = $("option:selected", this).text()
    escaped_state = brand.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(vehicle_models).filter("optgroup[label='#{escaped_state}']").html()
    $('#vehicle_vehicle_model_id').html(options)
