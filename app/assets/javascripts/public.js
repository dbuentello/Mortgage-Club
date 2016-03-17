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
//= require elevator.min
//= require bootstrap-sprockets
//= require d3.min
//= require d3.slider
//= require zopim

// Important to import jquery_ujs before bundle_PublicApp as that patches jquery xhr to use the authenticity token!

//= require build/bundle_PublicApp

// Facebook Pixel Code
!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?
  n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;
  n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;
  t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,
    document,'script','//connect.facebook.net/en_US/fbevents.js');
  fbq('init', '971021386313588');
  fbq('track', "PageView");
  fbq('track', 'ViewContent');

// Google Analytics
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
   (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
   m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
 })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
 ga('create', 'UA-74698103-1', 'auto');
 ga('send', 'pageview');

// General Setting
$(document).ready(function() {

  //Check to see if the window is top if not then display button
  $(window).scroll(function(){
    if ($(this).scrollTop() > 100) {
      $('.cd-top').fadeIn();
    } else {
      $('.cd-top').fadeOut();
    }
  });

  //Click event to scroll to top
  $('.cd-top').click(function(){
    $('html, body').animate({scrollTop : 0}, 800);
    return false;
  });

  // Elevator
  var elevator = new Elevator({
    element: document.querySelector('#backtopBtn'),
    duration:2000,
  });

 $("[data-toggle='tooltip']").tooltip({
    placement: "left",
    trigger: "manual"
  }).tooltip("show");
});