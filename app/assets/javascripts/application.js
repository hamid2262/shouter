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
//= require chosen.proto.min
//= require docsupport/prism

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
	$(".tip").tooltip();
});

