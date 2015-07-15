var TextFormatMixin = require('./TextFormatMixin');

var UpdateChangeMixin = {
  handleChange: function(event) {
    var change = {},
        value = event.target.value;

    if (typeof this.props.onChange == 'function') {
      if (this.fieldType == 'date') {
        value = TextFormatMixin.usToIsoDate(value);
      }

      if (this.fieldType == 'boolean') {
        // this accounts for the NULL state of the boolean field that we have in our database
        if (value !== undefined && value !== null && value !== '') {
          value = (value == 'true');
        }
      } else {
        // normalize non-boolean fields
        value = value || null;
      }

      if (this.props.dataType == 'int') {
        value = parseInt(value, 10);
      } else if (this.props.dataType == 'float') {
        value = parseFloat(value);
      }

      if (this.props.liveFormat && _.isFunction(this.props.format)) {
        value = this.props.format(value);
      }

      change[this.props.keyName] = value;
      this.props.onChange(change);
    }

    if (typeof this.updateState == 'function') {
      this.updateState(event);
    }
  }
};

module.exports = UpdateChangeMixin;
