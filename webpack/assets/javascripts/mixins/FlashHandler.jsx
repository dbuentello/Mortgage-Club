var React = require('react/addons');
var FlashItem = require('components/FlashItem');

var FlashHandler = {
  showFlash: function(msg_type, message) {
    // add new flash to the flash section
    React.render(
      <FlashItem msg_type={msg_type} message={message} />,
      $('.page-alert')[0]
    );

    // now, 7 seconds before auto hide
    $('.page-alert').delay(7000).fadeOut();
  },

  showFlashes: function(flashes) {
    for (var key in flashes) {
      var message = flashes[key];

      this.showFlash(key, message);
    }
  },

  renderLoader: function() {
    return (
      <div className="overlayContainer pvxl rbl rbr">
        <div className="overlayDefault overlayFull text-center pts">
          <div className="loaderLarge"></div>
        </div>
      </div>
    );
  }
};

module.exports = FlashHandler;
