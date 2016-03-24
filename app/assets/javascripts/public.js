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

// Important to import jquery_ujs before bundle_PublicApp as that patches jquery xhr to use the authenticity token!

//= require build/bundle_PublicApp

adroll_adv_id = "NDSCNHHAEJDGPEYTI3VING";
adroll_pix_id = "I7ZUQKIJDNFZTKERETJRFK";
/* OPTIONAL: provide email to improve user identification */
/* adroll_email = "username@example.com"; */
(function () {
  var _onload = function(){
  if (document.readyState && !/loaded|complete/.test(document.readyState)){setTimeout(_onload, 10);return}
  if (!window.__adroll_loaded){__adroll_loaded=true;setTimeout(_onload, 50);return}
  var scr = document.createElement("script");
  var host = (("https:" == document.location.protocol) ? "https://s.adroll.com" : "http://a.adroll.com");
  scr.setAttribute('async', 'true');
  scr.type = "text/javascript";
  scr.src = host + "/j/roundtrip.js";
  ((document.getElementsByTagName('head') || [null])[0] ||
    document.getElementsByTagName('script')[0].parentNode).appendChild(scr);
  };
  if (window.addEventListener) {window.addEventListener('load', _onload, false);}
  else {window.attachEvent('onload', _onload)}
}());

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

// // start Mixpanel -->
//  (function(e,b){if(!b.__SV){var a,f,i,g;window.mixpanel=b;b._i=[];b.init=function(a,e,d){function f(b,h){var a=h.split(".");2==a.length&&(b=b[a[0]],h=a[1]);b[h]=function(){b.push([h].concat(Array.prototype.slice.call(arguments,0)))}}var c=b;"undefined"!==typeof d?c=b[d]=[]:d="mixpanel";c.people=c.people||[];c.toString=function(b){var a="mixpanel";"mixpanel"!==d&&(a+="."+d);b||(a+=" (stub)");return a};c.people.toString=function(){return c.toString(1)+".people (stub)"};i="disable time_event track track_pageview track_links track_forms register register_once alias unregister identify name_tag set_config people.set people.set_once people.increment people.append people.union people.track_charge people.clear_charges people.delete_user".split(" ");
//  for(g=0;g<i.length;g++)f(c,i[g]);b._i.push([a,e,d])};b.__SV=1.2;a=e.createElement("script");a.type="text/javascript";a.async=!0;a.src="undefined"!==typeof MIXPANEL_CUSTOM_LIB_URL?MIXPANEL_CUSTOM_LIB_URL:"file:"===e.location.protocol&&"//cdn.mxpnl.com/libs/mixpanel-2-latest.min.js".match(/^\/\//)?"https://cdn.mxpnl.com/libs/mixpanel-2-latest.min.js":"//cdn.mxpnl.com/libs/mixpanel-2-latest.min.js";f=e.getElementsByTagName("script")[0];f.parentNode.insertBefore(a,f)}})(document,window.mixpanel||[]);
//  mixpanel.init("cdf4bdb6a5368a9426af0bec06e6c956");
//  // end Mixpanel -->

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

 $("#login-btn").click(function(){
   mixpanel.track("clickLoginBtn");
 });
 $("#btnSignupDevise").click(function(){
   mixpanel.track("clickSignUp");
 });
 $("#findMyRateBtn").click(function(){
   mixpanel.track("clickFindMyRateNavbar");
 });
});
