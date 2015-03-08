

var ObjectHelperMixin = require('../../mixins/object_helper_mixin');
var MultiselectMixin = require('../../mixins/multiselect_mixin');

/**
 * SearchableMultiSelectField provides the interface for user to search and select multiple options from a list.
 */
var SearchableMultiSelectField = React.createClass({
  mixins: [ObjectHelperMixin, MultiselectMixin],

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

    // if @onChange is provided, when user select the options, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [values]} where @keyName is from the props and `values` is the array of selected values.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,

    placeholder: React.PropTypes.string
  },

  initMultiselect: function() {
    this.$select = $(this.refs.selectField.getDOMNode());
    this.setSelection();
    this.$select.select2({
      placeholder: this.props.placeholder,
      width: '100%'
    }).on('change', _.bind(function() {
      this.handleChange(this.$select.val());
    }, this));
  },

  componentDidMount: function() {
    this.initMultiselect();
  },

  render: function() {
    var names = this.getNamesFromValues(this.props.values, this.props.options);

    return (
      <div className="col-xs-12 phn">
        {this.props.label ?
          <label className='typeWeightNormal typeLowlight'>{this.props.label}</label>
        : null}
        <div className={'h6 typeWeightNormal mvn' + (this.props.editable ? '' : ' hideFully')}>
          <select ref='selectField' multiple>
            {this.props.options.map(function (option) {
              return <option key={option.value} value={option.value}>{option.name}</option>;
            }, this)}
          </select>
        </div>
        <div className={this.props.editable ? 'hideFully' : null}>
          <p className="form-control-static col-xs-12 phn">{names}</p>
        </div>
      </div>
    );
  }

});


module.exports = SearchableMultiSelectField;
