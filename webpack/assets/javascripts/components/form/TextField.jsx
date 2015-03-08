/**
 * @jsx React.DOM
 */

var HelpTooltip = require('./help_tooltip');

var TextFormatMixin = require('../../mixins/text_format_mixin');
var StaticFieldMixin = require('../../mixins/static_field_mixin');
var UpdateChangeMixin = require('../../mixins/update_change_mixin');
var TextFocusMixin = require('../../mixins/text_focus_mixin');

/**
 * TextField renders a form field that can be converted between editable and read-only mode.
 * It also provides some predefined formatting helper for the read-only texts.
 */
var TextFieldView = React.createClass({
  mixins: [StaticFieldMixin, UpdateChangeMixin, TextFocusMixin, TextFormatMixin],

  propTypes: {
    editable: React.PropTypes.bool, // determines if component should show the input box or the static text
    label: React.PropTypes.string, // field label
    // intitial value
    value: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.number
    ]),

    // @tooltip is an object with properties `text` and `position`.
    // `position` is one of `top`, `right`, `bottom`, or `left`.
    // It is used to create a tooltip that will appear next to the
    // label text.
    tooltip: React.PropTypes.object,

    // @format is used to format the static text, and will not affect the input text.
    // numbers will be commafied;
    // currency will be rounded, fixed at the decimals, commafied
    // and prepended with @currency if provided
    format: React.PropTypes.oneOf(['number', 'currency']),
    currency: React.PropTypes.string,
    decimals: React.PropTypes.number,

    // @prefix and @suffix will be prepended and appended to the static text,
    // and will not affect the text in the input field.
    prefix: React.PropTypes.string,
    suffix: React.PropTypes.string,

    // if @onChange is provided, when user changes the text input, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [value]} where @keyName is from the props and `value` is the updated text value.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,

    // static text for null value
    emptyStaticText: React.PropTypes.string,

    // set this to true if you don't want to truncate the static text
    noTruncation: React.PropTypes.bool
  },

  getDefaultProps: function() {
    return {
      decimals: 2,
      prefix: '',
      suffix: '',
      noTruncation: false,
      tooltip: {}
    };
  },

  render: function() {
    var classes = this.getFieldClasses(this.props.editable, this.props.isLarge),
        prefix = this.props.prefix,
        suffix = this.props.suffix,
        displayText = this.props.value,
        rightAlign = (this.props.format == 'number' && !suffix),
        tooltip = this.props.tooltip,
        hasTooltip = tooltip.hasOwnProperty('text') && tooltip.hasOwnProperty('position');

    if (this.props.format == 'number') {
      displayText = this.commafy(this.props.value, this.props.decimals);
    } else if (this.props.format == 'currency') {
      displayText = this.formatCurrency(this.props.value, this.props.currency);
    }

    if (!displayText && this.props.emptyStaticText) {
      displayText = this.props.emptyStaticText;
    } else {
      displayText = prefix + (displayText || '') + suffix;
    }

    return (
      <div>
        <label className="col-xs-12 pan">
          <span>{this.props.label}</span>
          {hasTooltip ?
            <HelpTooltip position={tooltip.position} text={tooltip.text} />
          : null}
          <input className={classes.editableFieldClasses + (rightAlign ? ' text-right' : '')} type="text" value={this.props.value}
            onChange={this.handleChange} onFocus={this.handleFocus} placeholder={this.props.placeholder} name={this.props.name}/>
        </label>
        <p className={classes.staticFieldClasses}>{displayText}</p>
      </div>
    );
  }
});

module.exports = TextFieldView;
