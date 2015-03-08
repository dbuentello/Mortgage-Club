var StaticFieldMixin = require('../../mixins/static_field_mixin');
var UpdateChangeMixin = require('../../mixins/update_change_mixin');
var TextFocusMixin = require('../../mixins/text_focus_mixin');

/**
 * PasswordField renders a form field for users to enter their password
 */
var PasswordField = React.createClass({
  mixins: [UpdateChangeMixin, TextFocusMixin, StaticFieldMixin],

  propTypes: {
    editable: React.PropTypes.bool, // determines if component should show the input box or the static text
    label: React.PropTypes.string, // field label

    // if @onChange is provided, when user changes the text input, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [value]} where @keyName is from the props and `value` is the updated text value.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,
    placeholder: React.PropTypes.string
  },

  render: function() {
    var classes = this.getFieldClasses(this.props.editable, this.props.isLarge);

    return (
      <div>
        <label className="col-xs-12 pan">
          <span>{this.props.label}</span>
          <input
            className={classes.editableFieldClasses}
            type='password'
            onChange={this.handleChange}
            onFocus={this.handleFocus}
            placeholder={this.props.placeholder} name={this.props.name}/>
        </label>
        <p className={classes.staticFieldClasses}>**********</p>
      </div>
    );
  }
});

module.exports = PasswordField;
