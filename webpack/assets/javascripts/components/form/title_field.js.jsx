/**
 * @jsx React.DOM
 */

var StaticFieldMixin = require('../../mixins/static_field_mixin');
var UpdateChangeMixin = require('../../mixins/update_change_mixin');
var TextFocusMixin = require('../../mixins/text_focus_mixin');

/**
 * TittleField is similar to TextField, but without label and the static text is bolded and titleized
 */
var TitleFieldView = React.createClass({
  mixins: [StaticFieldMixin, UpdateChangeMixin, TextFocusMixin],

  propTypes: {
    // determines if component should show the input box or the static text
    editable: React.PropTypes.bool,

    // initial value
    value: React.PropTypes.any,

    // if @onChange is provided, when user changes the text input, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [value]} where @keyName is from the props and `value` is the updated text value.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,
  },

  render: function() {
    var classes = this.getFieldClasses(this.props.editable, this.props.isLarge);
    return (
      <div>
        <input className={classes.editableFieldClasses} value={this.props.value} type="text"
          onChange={this.handleChange} onFocus={this.handleFocus} />
        <p className={classes.staticFieldClasses}>
          <strong className="typeCapitalize">{this.props.value}</strong>
        </p>
      </div>
    );
  }
});

module.exports = TitleFieldView;
