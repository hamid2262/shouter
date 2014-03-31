function initialize() {

  var options = {
    types: ['(cities)']
    // , componentRestrictions: {country: "ir"}
  };

  var origin = document.getElementById('search_subtrip_origin_address');
  var autocomplete_origin = new google.maps.places.Autocomplete(origin, options);
  google.maps.event.addListener(autocomplete_origin, 'place_changed', function () {
    var place = autocomplete_origin.getPlace();
    document.getElementById('search_subtrip_olat').value    = place.geometry.location.lat();
    document.getElementById('search_subtrip_olng').value    = place.geometry.location.lng();
   });

  var destination = document.getElementById('search_subtrip_destination_address');
  var autocomplete_destination = new google.maps.places.Autocomplete(destination, options);
  google.maps.event.addListener(autocomplete_destination, 'place_changed', function () {
    var place = autocomplete_destination.getPlace();
    document.getElementById('search_subtrip_dlat').value    = place.geometry.location.lat();
    document.getElementById('search_subtrip_dlng').value    = place.geometry.location.lng();
  });

/////////////////////////// Trip New
  var address0 = document.getElementById('trip_subtrips_attributes_0_origin_address');
  var autocomplete0 = new google.maps.places.Autocomplete(address0, options);
  google.maps.event.addListener(autocomplete0, 'place_changed', function () {
    var place0 = autocomplete0.getPlace();
    // console.log(place.geometry.location.lat())
    document.getElementById('trip_subtrips_attributes_0_olat').value    = place0.geometry.location.lat();
    document.getElementById('trip_subtrips_attributes_0_olng').value    = place0.geometry.location.lng();
  });

  var address1 = document.getElementById('trip_subtrips_attributes_1_origin_address');
  var autocomplete1 = new google.maps.places.Autocomplete(address1, options);
  google.maps.event.addListener(autocomplete1, 'place_changed', function () {
    var place1 = autocomplete1.getPlace();
    document.getElementById('trip_subtrips_attributes_1_olat').value    = place1.geometry.location.lat();
    document.getElementById('trip_subtrips_attributes_1_olng').value    = place1.geometry.location.lng();
  });

  var address2 = document.getElementById('trip_subtrips_attributes_2_origin_address');
  var autocomplete2 = new google.maps.places.Autocomplete(address2, options);
  google.maps.event.addListener(autocomplete2, 'place_changed', function () {
    var place2 = autocomplete2.getPlace();
    document.getElementById('trip_subtrips_attributes_2_olat').value    = place2.geometry.location.lat();
    document.getElementById('trip_subtrips_attributes_2_olng').value    = place2.geometry.location.lng();
  });

  var address3 = document.getElementById('trip_subtrips_attributes_3_origin_address');
  var autocomplete3 = new google.maps.places.Autocomplete(address3, options);
  google.maps.event.addListener(autocomplete3, 'place_changed', function () {
    var place3 = autocomplete3.getPlace();
    document.getElementById('trip_subtrips_attributes_3_olat').value    = place3.geometry.location.lat();
    document.getElementById('trip_subtrips_attributes_3_olng').value    = place3.geometry.location.lng();
  });

  var address4 = document.getElementById('trip_subtrips_attributes_4_origin_address');
  var autocomplete4 = new google.maps.places.Autocomplete(address4, options);
  google.maps.event.addListener(autocomplete4, 'place_changed', function () {
    var place4 = autocomplete4.getPlace();
    document.getElementById('trip_subtrips_attributes_4_olat').value    = place4.geometry.location.lat();
    document.getElementById('trip_subtrips_attributes_4_olng').value    = place4.geometry.location.lng();
  });



}
google.maps.event.addDomListener(window, 'load', initialize);