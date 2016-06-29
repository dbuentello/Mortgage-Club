var React = require('react/addons');
var StaticFieldMixin = require('mixins/StaticFieldMixin');
var UpdateChangeMixin = require('mixins/UpdateChangeMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var TextFocusMixin = require('mixins/TextFocusMixin');
var ValidationField = require('./ValidationField');
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
    onBlur: React.PropTypes.func,

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

  onBlur: function(event) {
    this.handleChange(event);
    if (this.props.onBlur) {
      this.props.onBlur(event);
    }
  },

  showDatePicker: function() {
    this.$input.datepicker("show");
  },

  render: function() {
    var dateVal = this.isoToUsDate(this.props.value) || this.props.emptyStaticText;
    var requiredMessage = this.props.requiredMessage || "This field is required";
    var disabled = this.props.editMode === false ? "disabled" : null;
    var invalidMessage = this.props.invalidMessage;

    return (
      <div>
        <h6>{this.props.label}</h6>
        <div className="date-field">
          <input disabled={disabled} className={"form-control " + this.props.customClass} defaultValue={dateVal} type="text" placeholder={this.props.placeholder} data-date-end-date="0d"
            onBlur={this.onBlur} onFocus={this.handleFocus} id={this.props.keyName} name={this.props.label}/>
          <img src="/icons/date.png" alt="title" onClick={this.showDatePicker}/>
        </div>
        <ValidationField id={this.props.keyName} activateRequiredField={this.props.activateRequiredField} value={dateVal} requiredMessage={requiredMessage} invalidMessage={invalidMessage} validationTypes={this.props.validationTypes}/>
      </div>
    );
  },

  componentDidMount: function() {
    this.$input = $(this.getDOMNode()).find("input");
    this.$input.datepicker({
      format: "mm/dd/yyyy",
      forceParse: true,
      autoclose: true,
      todayHighlight: true,
      enableOnReadonly: false
    });
    this.$input.datepicker().on("changeDate", this.handleChange);
  },

  componentWillUnmount: function() {
    this.$input.datepicker("remove");
  }
});

module.exports = DateFieldView;
