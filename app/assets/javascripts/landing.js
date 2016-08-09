//= require lodash
//= require jquery
//= require jquery_ujs
//= require elevator.min
//= require d3.min
//= require d3.slider
//= require build/bundle_PublicApp
//= require landing/plugins
//= require landing/functions
//= require landing/jquery.themepunch.tools.min
//= require landing/jquery.themepunch.revolution.min
//= require landing/revolution.extension.video.min
//= require landing/revolution.extension.slideanims.min
//= require landing/revolution.extension.actions.min
//= require landing/revolution.extension.layeranimation.min
//= require landing/revolution.extension.kenburn.min
//= require landing/revolution.extension.navigation.min
//= require landing/revolution.extension.migration.min
//= require landing/revolution.extension.parallax.min
$(document).ready(function(){
  $("[data-toggle='tooltip']").tooltip({
    trigger: "manual"
  }).tooltip("show");
  mixpanel.track("Homepage-Enter");
  $("#findMyRateLink").click(function(){
    mixpanel.track("Navbar-FindMyRates");
  });
  $("#apply-btn").click(function(){
    mixpanel.track("Homepage-FindMyRatesTable");
  });
  $("#btnSignupDevise").click(function(){
    mixpanel.track("SignUp-Btn");
  });
  var $faqItems = $('#faqs .faq');
  if( window.location.hash != '' ) {
    var getFaqFilterHash = window.location.hash;
    var hashFaqFilter = getFaqFilterHash.split('#');
    if( $faqItems.hasClass( hashFaqFilter[1] ) ) {
      $('#portfolio-filter li').removeClass('activeFilter');
      $( '[data-filter=".'+ hashFaqFilter[1] +'"]' ).parent('li').addClass('activeFilter');
      var hashFaqSelector = '.' + hashFaqFilter[1];
      $faqItems.css('display', 'none');
      if( hashFaqSelector != 'all' ) {
        $( hashFaqSelector ).fadeIn(500);
      } else {
        $faqItems.fadeIn(500);
      }
    }
  }

  $('#portfolio-filter a').click(function(){
    $('#portfolio-filter li').removeClass('activeFilter');
    $(this).parent('li').addClass('activeFilter');
    var faqSelector = $(this).attr('data-filter');
    $faqItems.css('display', 'none');
    if( faqSelector != 'all' ) {
      $( faqSelector ).fadeIn(500);
    } else {
      $faqItems.fadeIn(500);
    }
    return false;
  });
  function createGuid()
  {
      return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
          var r = Math.random()*16|0, v = c === 'x' ? r : (r&0x3|0x8);
          return v.toString(16);
      });
  }
  function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length,c.length);
        }
    }
    return "";
  }
  function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
  }

  function checkCookie() {
    var user = getCookie("username");
    if (user != "") {
        alert("Welcome again " + user);
    } else {
        user = prompt("Please enter your name:", "");
        if (user != "" && user != null) {
            setCookie("username", user, 365);
        }
    }
  }
});
