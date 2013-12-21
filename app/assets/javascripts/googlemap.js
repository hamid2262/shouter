function initialize() {

  var options = {
    types: ['(cities)'],
    componentRestrictions: {country: "ir"}
  };

  var origin = document.getElementById('search_subtrip_origin_id');
  var destination = document.getElementById('search_subtrip_destination_id');

  var autocomplete_origin = new google.maps.places.Autocomplete(origin, options);
  var autocomplete_destination = new google.maps.places.Autocomplete(destination, options);

  google.maps.event.addListener(autocomplete_origin, 'place_changed', function () {
    var place = autocomplete_origin.getPlace();
    document.getElementById('search_subtrip_origin_lat').value    = place.geometry.location.lat();
    document.getElementById('search_subtrip_origin_lng').value    = place.geometry.location.lng();
    document.getElementById('search_subtrip_origin').value        = place.name;
    document.getElementById('search_subtrip_origin1').value       = place.address_components[0].long_name;
    document.getElementById('search_subtrip_origin2').value       = place.address_components[1].long_name;
    document.getElementById('search_subtrip_originState').value   = place.address_components[2].long_name;
    document.getElementById('search_subtrip_originCountry').value = place.address_components[3].long_name;
  });

  google.maps.event.addListener(autocomplete_destination, 'place_changed', function () {
    var place_destination = autocomplete_destination.getPlace();
    document.getElementById('search_subtrip_destination_lat').value 	 = place_destination.geometry.location.lat();
    document.getElementById('search_subtrip_destination_lng').value 	 = place_destination.geometry.location.lng();
    document.getElementById('search_subtrip_destination').value   		 = place_destination.name;
    document.getElementById('search_subtrip_destination1').value  		 = place_destination.address_components[0].long_name;
    document.getElementById('search_subtrip_destination2').value  		 = place_destination.address_components[1].long_name;
    document.getElementById('search_subtrip_destinationState').value   = place_destination.address_components[2].long_name;
    document.getElementById('search_subtrip_destinationCountry').value = place_destination.address_components[3].long_name;
  });

}
google.maps.event.addDomListener(window, 'load', initialize);