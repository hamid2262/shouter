// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// require turbolinks
//= require bootstrap
//= require_tree .

//= require jquery-1.6.2.min
//= require jquery-ui-1.10.3.custom.min
//= require jquery.ui.datepicker-cc
//= require calendar
//= require jquery.ui.datepicker-cc-fa


$(function() {
  $(".datepicker").datepicker({ 
  	minDate: 0, 
		showButtonPanel: true,
		buttonImage: "https://s3-eu-west-1.amazonaws.com/shouter/static_files/css/images/calender.gif",
		showOn: "both"
	});
});

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