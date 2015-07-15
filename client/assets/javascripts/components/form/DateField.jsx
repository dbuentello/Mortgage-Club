
var React = require('react/addons');
var StaticFieldMixin = require('mixins/StaticFieldMixin');
var UpdateChangeMixin = require('mixins/UpdateChangeMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var TextFocusMixin = require('mixins/TextFocusMixin');

/**
 * DateField handles the conversion between ISO date (for value) and US date (for display)
 * automatically, and also has bootstrap date picker built-in.
 */
var DateFieldView = React.createClass({
  mixins: [StaticFieldMixin, UpdateChangeMixin, TextFormatMixin, TextFocusMixin],
  fieldType: 'date',

  propTypes: {
    editable: React.PropTypes.bool, // determines if component should show the input box or the static text
    label: React.PropTypes.string, // field label
    // intitial value--will be converted to US date for display in both
    // the input box and the static field
    value: React.PropTypes.string,

    // if @onChange is provided, when user changes the date, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [date]} where @keyName is from the props and `date` is the date value in ISO format.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,
    // static text for null value
    emptyStaticText: React.PropTypes.string,

    placeholder: React.PropTypes.string,
    // set this to false if you want the field to have a red outline
    valid: React.PropTypes.bool
  },

  getDefaultProps: function() {
    return {valid: true};
  },

  render: function() {
    var classes = this.getFieldClasses(this.props.editable, this.props.isLarge, this.props.valid),
        dateVal = this.isoToUsDate(this.props.value) || this.props.emptyStaticText;
    return (
      <div>
        <label className="col-xs-12 pan">
          <span className={this.props.label ? 'h7 typeBold mrs' : null}>{this.props.label}</span>
          <div className="input-group date datepicker pan" style={{display: this.props.editable ? null : 'none', zIndex: this.props.zIndex}}>
            <input className={classes.editableFieldClasses} defaultValue={dateVal} type="text" placeholder={this.props.placeholder}
              onBlur={this.handleChange} onFocus={this.handleFocus}/>
            <span className="input-group-addon">
              <i className="iconCalendar"/>
            </span>
          </div>
        </label>
        <p className={classes.staticFieldClasses}>{dateVal}</p>
      </div>
    );
  },

  componentDidMount: function() {
    this.$input = $(this.getDOMNode()).find('input');
    this.$input.datepicker({
      format: 'mm/dd/yyyy',
      forceParse: true,
      autoclose: true,
      todayHighlight: true
    });
    this.$input.datepicker().on('changeDate', this.handleChange);
  },

  componentWillUnmount: function() {
    this.$input.datepicker('remove');
  }
});

module.exports = DateFieldView;
