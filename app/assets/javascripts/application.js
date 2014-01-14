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
//= require jquery.validate
// require localization/messages_fa   moved to application.html with an if condition
//= require jquery_ujs
// require turbolinks
//= require bootstrap
//= require select2
//= require_tree .

$(function() {
  $(".select2_input").select2({ 
		width: '265px' 
	});

  // update url by tab changing
  $('.nav-tabs a').click(function (e) {
    $(this).tab('show');
    var scrollmem = $('body').scrollTop();
    window.location.hash = this.hash;
    // $('html,body').scrollTop(scrollmem);
  });

  // url change with nav-tabs hashed address
  var hash = window.location.hash;
  hash && $('ul.nav a[href="' + hash + '"]').tab('show');

  // in user update profile when form has validation error, must go to tab that has error
  var t = $('p.tab').text();
  t = $('ul.nav a[href="#' + $.trim(t) + '"]');
  t && t.tab('show');  

});



