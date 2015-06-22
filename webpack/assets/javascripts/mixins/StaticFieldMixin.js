var React = require('react/addons');
var cx = React.addons.classSet;
// var classNames = require('classnames');

var StaticFieldMixin = {
  getFieldClasses: function(editable, isLarge, valid) {
    return {
      editableFieldClasses: cx({
        'form-control': true,
        'typeWeightNormal': true,
        'input-sm': !isLarge,
        'hidden': !editable,
        'error': !valid
      }),
      staticFieldClasses: cx({
        'form-control-static': true,
        'col-xs-12': true,
        'typeTruncate': !this.props.noTruncation,
        'pan': true,
        'hidden': editable
      })
    };
  }
};

module.exports = StaticFieldMixin;
