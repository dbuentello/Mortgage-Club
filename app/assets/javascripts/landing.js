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
})
