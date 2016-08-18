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
//= require lodash
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap_datepicker
//= require d3.min
//= require d3.slider
//= require auto-complete.min
//= require idle-timer.min
//= require landing/functions
// Important to import jquery_ujs before bundle_BorrowerApp as that patches jquery xhr to use the authenticity token!

//= require build/bundle_BorrowerApp

// General Config
$(document).on('ready', function(event) {
  google.charts.load('current', {'packages':['corechart']});
  $('.flashSection').delay(7000).fadeOut();
  $('[data-toggle="tooltip"]').tooltip();
});
$(document).on( "idle.idleTimer", function(event, elem, obj){

});
$(document).on( "active.idleTimer", function(event, elem, obj, triggerevent){
       // function you want to fire when the user becomes active again

});

(function ($) {

    $( document ).on( "idle.idleTimer", function(event, elem, obj){
        console.log("idle time");
    });

    $( document ).on( "active.idleTimer", function(event, elem, obj, triggerevent){
        console.log("reset timeout");
        $.idleTimer("reset");
        console.log($( document ).idleTimer("getRemainingTime"));
    });

    $.idleTimer(15000);

})(jQuery);
