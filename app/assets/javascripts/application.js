//= require jquery
//= require jquery.validate
// require localization/messages_fa   moved to application.html with an if condition
//= require jquery_ujs
// require turbolinks
//= require bootstrap
//= require select2
//= require underscore
//= require gmaps/google
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



