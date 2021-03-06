var React = require('react/addons');
var HelpTooltip = require('./HelpTooltip');
var _ = require('lodash');

var TextFormatMixin = require('mixins/TextFormatMixin');
var StaticFieldMixin = require('mixins/StaticFieldMixin');
var UpdateChangeMixin = require('mixins/UpdateChangeMixin');
var TextFocusMixin = require('mixins/TextFocusMixin');

/**
 * TextField renders a form field that can be converted between editable and read-only mode.
 * It also provides some predefined formatting helper for the read-only texts.
 */
var TextField = React.createClass({
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
    // alternatively, supply a function to process the formatting
    format: React.PropTypes.oneOfType([
      React.PropTypes.oneOf(['number', 'currency']),
      React.PropTypes.func
    ]),
    currency: React.PropTypes.string,
    decimals: React.PropTypes.number,

    // set this to true if you want to format the value while the user types
    liveFormat: React.PropTypes.bool,

    // @prefix and @suffix will be prepended and appended to the static text,
    // and will not affect the text in the input field.
    prefix: React.PropTypes.string,
    suffix: React.PropTypes.string,

    // if @onChange is provided, when user changes the text input, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [value]} where @keyName is from the props and `value` is the updated text value.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,

    onBlur: React.PropTypes.func,

    // static text for null value
    emptyStaticText: React.PropTypes.string,

    // set this to true if you don't want to truncate the static text
    noTruncation: React.PropTypes.bool,

    // set this to false if you want the field to have a red outline
    valid: React.PropTypes.bool,

    // set this to true if you want the hidden field
    hidden: React.PropTypes.bool,
  },

  getDefaultProps: function() {
    return {
      decimals: 2,
      prefix: '',
      suffix: '',
      noTruncation: false,
      tooltip: {},
      valid: true,
      hidden: false
    };
  },

  render: function() {
    var classes = this.getFieldClasses(this.props.editable, this.props.isLarge, this.props.valid),
        prefix = this.props.prefix,
        suffix = this.props.suffix,
        displayText = this.props.value,
        rightAlign = (this.props.format == 'number' && !suffix),
        tooltip = this.props.tooltip,
        type = this.props.hidden == true ? "hidden" : "text",
        hasTooltip = tooltip.hasOwnProperty('text') && tooltip.hasOwnProperty('position');
    if (this.props.password === true) {
      type = "password";
    }

    if (this.props.format == 'number') {
      displayText = this.commafy(this.props.value, this.props.decimals);
    } else if (this.props.format == 'currency') {
      displayText = this.formatCurrency(this.props.value, this.props.currency);
    } else if (_.isFunction(this.props.format)) {
      displayText = this.props.format(this.props.value);
    }

    if (!displayText && this.props.emptyStaticText) {
      displayText = this.props.emptyStaticText;
    } else {
      displayText = prefix + (displayText || '') + suffix;
    }

    return (
      <div>
          <label className="col-xs-12 pan">
            {
              this.props.hidden ?
                null
              : <span className='h7 typeBold'>{this.props.label}</span>
            }
            {
              hasTooltip ?
                <HelpTooltip position={tooltip.position} text={tooltip.text} />
              : null
            }
            <input className={classes.editableFieldClasses + (rightAlign ? ' text-right' : '')} type={type} value={this.props.value}
              onChange={this.handleChange} onBlur={this.handleBlur} onFocus={this.handleFocus} placeholder={this.props.placeholder}
              name={this.props.name} id={this.props.keyName}/>
          </label>
          {
            this.props.hidden ?
              null
            : <p className={classes.staticFieldClasses}>{displayText}</p>
          }
      </div>
    );
  }
});

module.exports = TextField;
