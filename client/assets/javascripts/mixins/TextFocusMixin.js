var TextFocusMixin = {
  handleFocus: function(event) {
    var target = event.target;
    setTimeout(function() {
      target.select();
    }, 0);

    if (typeof this.props.onFocus == 'function') {
      this.props.onFocus();
    }
  }
};

module.exports = TextFocusMixin;
