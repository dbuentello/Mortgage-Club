/**
 * @jsx React.DOM
 */

var StaticFieldMixin = require('../../mixins/static_field_mixin');
var UpdateChangeMixin = require('../../mixins/update_change_mixin');
var TextFormatMixin = require('../../mixins/text_format_mixin');

/**
 * DateField handles the conversion between ISO date (for value) and US date (for display)
 * automatically, and also has bootstrap date picker built-in.
 */
var DateFieldView = React.createClass({
  mixins: [StaticFieldMixin, UpdateChangeMixin, TextFormatMixin],
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
  },

  render: function() {
    var classes = this.getFieldClasses(this.props.editable, this.props.isLarge),
        dateVal = this.isoToUsDate(this.props.value);
    return (
      <div>
        <label className="col-xs-12 pan">
          <span className={this.props.label ? 'mrs' : null}>{this.props.label}</span>
          <div className="input-group date datepicker pan" style={{display: this.props.editable ? null : 'none', zIndex: this.props.zIndex}}>
            <input className={classes.editableFieldClasses} value={dateVal} onChange={this.handleChange} type="text" />
            <span className="input-group-addon">
              <i className="glyphicon glyphicon-calendar"></i>
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
