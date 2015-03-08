

var StaticFieldMixin = require('../../mixins/static_field_mixin');
var ObjectHelperMixin = require('../../mixins/object_helper_mixin');
var MultiselectMixin = require('../../mixins/multiselect_mixin');

/**
 * MultiselectField provides the interface for user to select multiple options.
 */
var MultiselectFieldView = React.createClass({
  mixins: [MultiselectMixin, StaticFieldMixin, ObjectHelperMixin],

  propTypes: {
    editable: React.PropTypes.bool, // determines if component should show the input box or the static text
    label: React.PropTypes.string, // field label

    // the initially selected values
    values: React.PropTypes.arrayOf(React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.number
    ])),

    // @options is an array of objects with properties `name` and `value`.
    // It is used to build the options for the select input, and also to query for
    // the display text showed when the field is in read-only mode.
    options: React.PropTypes.arrayOf(React.PropTypes.object),

    // @numberDisplay is the maximum number of selected options that will be listed out
    // if user selects more options than this number, the component will display
    // the static text such as '3 people' or '5 days', where `people` and `days` are
    // specified by the @unit prop.
    numberDisplayed: React.PropTypes.number,
    unit: React.PropTypes.string,

    // if @onChange is provided, when user select the options, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [values]} where @keyName is from the props and `values` is the array of selected values.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,
  },

  initMultiselect: function() {
    this.$select = $(this.getDOMNode()).find('select');
    this.setSelection();
    this.$select.multiselect({
      numberDisplayed: this.props.numberDisplayed,
      buttonClass: 'btn btn-default typeTruncate',
      onChange: function(option, checked) {
        var value = $(option).val(),
            values = this.normalize(this.props.values),
            newValues;

        if (checked) {
          newValues = _.union(values, [value]);
        } else {
          newValues = _.without(values, value);
        }

        if (typeof this.handleChange == 'function') {
          this.handleChange(newValues);
        }

      }.bind(this)
    });
  },

  render: function() {
    var names = this.getNamesFromValues(this.props.values, this.props.options);

    return (
      <div className="col-xs-12 phn">
        <div className="multiselect-group multiselect-group-sml" style={{'display': this.props.editable ? null : 'none'}}>
          <label className="col-xs-12 pan">
            <span className={this.props.label ? 'mrs' : null}>{this.props.label}</span>
            <br/>
            <select className="form-control input-sm" multiple="multiple">
              {this.props.options.map(function (option) {
                return (<option key={option.value} value={option.value}>{option.name}</option>);
              }, this)}
            </select>
          </label>
        </div>
        <div className="col-xs-12 phn" style={{'display': this.props.editable ? 'none' : null}}>
          <label className="col-xs-12 pan"><span className={this.props.label ? 'mrs' : null}>{this.props.label}</span></label>
          <p className="form-control-static typeTruncate col-xs-12 phn">{names}</p>
        </div>
      </div>
    );
  },

  componentDidMount: function() {
    this.initMultiselect();
  },

  componentDidUpdate: function() {
    this.setSelection();
    this.$select.multiselect('refresh');
  },

  componentWillUnmount: function() {
    this.$select.multiselect('destroy');
  }
});


module.exports = MultiselectFieldView;
