/**
 * @jsx React.DOM
 */

var TextFocusMixin = {
  handleFocus: function(event) {
    var target = event.target;
    setTimeout(function() {
      target.select();
    }, 0);
  }
};

module.exports = TextFocusMixin;
