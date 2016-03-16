$('.flashSection').delay(7000).fadeOut();
$(document).on('ready', function(event) {
  // initialize persistent state
  $zopim(function(){
    $zopim.livechat.window.hide();
  });
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
    $('html, body').animate({scrollTop : 0},800);
    return false;
  });

  var elevator = new Elevator({
    element: document.querySelector('#backtopBtn'),
    duration:2000,
  });

  $('[data-toggle="tooltip"]').tooltip();
});