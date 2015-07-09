var React = require('react/addons');
var FlashItem = require('components/FlashItem');
var FlashList = require('components/FlashList');

var FlashHandler = {
  showFlashes: function(flashes) {
    // add new flash to the flash section
    React.render(
      <FlashList flashes={flashes}/>,
      $('.page-alert')[0]
    );

    // now, 7 seconds before auto hide
    $('.page-alert').delay(7000).fadeOut();
  }
};

module.exports = FlashHandler;
