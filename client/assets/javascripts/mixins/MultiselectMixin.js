
/**
 * Used in MultiselectField, but this component have not used yet
 * TODO: UNUSED CODE
 */
var MultiselectMixin = {
  getNamesFromValues: function(values, options) {
    if (!values || values.length < 1) {
      return 'None selected';
    }

    if (values.length > this.props.numberDisplayed) {
      return values.length + ' ' + this.props.unit;
    }

    return _.compact(_.map(this.normalize(values), function (value) {
      var item = _.findWhere(this.normalize(options), {value: value});
      return item ? item.name : null;
    }, this)).join(', ');
  },

  setSelection: function() {
    this.$select.find('option').each(function (index, el) {
      if (_.contains(this.normalize(this.props.values), el.value)) {
        $(el).prop('selected', true);
      } else {
        $(el).removeAttr('selected');
      }
    }.bind(this));
  },

  handleChange: function(newValues) {
    var change = {};

    change[this.props.keyName] = newValues;
    this.props.onChange(change);

    this.setState({
      names: this.getNamesFromValues(newValues, this.props.options)
    });
  }
};

module.exports = MultiselectMixin;
