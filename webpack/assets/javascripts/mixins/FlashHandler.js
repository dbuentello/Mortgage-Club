var FlashHandler = {
  showFlash: function(msg_type, message) {
    // now, 7 seconds before auto hide
    $('.page-alert').delay(7000).fadeOut();
  },

  showFlashes: function(flashes) {
    for (var key in flashes) {
      var message = flashes[key];
      console.log(message);
      console.log(key);
      console.log(key);
      this.showFlash(key, message);
    }
  }
};

module.exports = FlashHandler;
