/**
 * Show alert errors
 */
var React = require('react/addons');
var FlashList = require('components/FlashList');

var FlashHandler = {
  showFlashes: function(flashes) {
    if($('.page-alert').length > 0){
      // add new flash to the flash section
      React.render(
        <FlashList flashes={flashes}/>,
        $('.page-alert')[0]
      );
      // now, show in 7 seconds before auto hide
      $('.page-alert').fadeIn();
      $('.page-alert').delay(7000).fadeOut();
    }
  }
};

module.exports = FlashHandler;
