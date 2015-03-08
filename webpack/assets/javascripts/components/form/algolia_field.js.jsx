/* global FlexSearch */

var TextFocusMixin = require('../../mixins/text_focus_mixin');

/**
 * TypeaheadField is a text field that has autosuggestion built-in.
 */
var SearchField = React.createClass({
  mixins: [TextFocusMixin],

  propTypes: {
    editable: React.PropTypes.bool, // determines if component should show the input box or the static text
    label: React.PropTypes.string, // field label

    // initial value
    value: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.number
    ]),

    searchIndex: React.PropTypes.oneOf(['clients', 'companies', 'shipments', 'documents']).isRequired,

    // if onChange is provided, when user changes the input, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [value]} where @keyName is from the props and `value` is the value of the option.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,

    // input placeholder
    placeholder: React.PropTypes.string,

    // set to true if you want to select the entire object from algolia instead of just the id
    selectWholeObject: React.PropTypes.bool
  },

  nameFields: {
    clients: 'company_name',
    companies: 'name',
    shipments: 'name',
    documents: 'name'
  },

  getInitialState: function() {
    return {
      name: this.props.value
    };
  },

  componentDidMount: function() {
    this.$input = $(this.getDOMNode()).find('input');
    this.initTypeAhead();
  },

  componentWillUnmount: function() {
    this.$input.typeahead('destroy');
  },

  render: function() {
    return (
      <div>
        <label className="col-xs-12 pan" style={{'display': this.props.editable ? null : 'none'}}>
          <span className={this.props.label ? 'mrs' : null}>{this.props.label}</span>
          <input className="form-control input-sm" type="text" value={this.state.name}
            onFocus={this.handleFocus} onChange={this.handleChange} placeholder={this.props.placeholder}/>
        </label>
        <div style={{'display': this.props.editable ? 'none' : null}}>
          <label className="col-xs-12 pan">
            <span className={this.props.label ? 'mrs' : null}>{this.props.label}</span>
          </label>
          <p className="form-control-static typeTruncate col-xs-12 pan">{this.state.name}</p>
        </div>
      </div>
    );
  },

  handleChange: function(event) {
    var name = event.target.value;
    if (name === '') {
      this.handleSelect(event, {value: null, name: name});
    }

    this.setState({name: name});
  },

  handleSelect: function(event, selection) {
    var change = {};

    this.setState({
      name: selection[this.nameFields[this.props.searchIndex]]
    });

    if (this.props.selectWholeObject) {
      change[this.props.keyName] = selection;
    } else {
      change[this.props.keyName] = selection.objectID;
    }

    if (typeof this.props.onChange == 'function') {
      this.props.onChange(change);
    }
  },

  initTypeAhead: function() {
    var indexMap = {
      'clients': FlexSearch.clientIndex,
      'companies': FlexSearch.companyIndex,
      'shipments': FlexSearch.shipmentIndex,
      'documents': FlexSearch.documentIndex
    };

    var search = new FlexSearch(null, null, FlexSearch.coreIndicies('production', [indexMap[this.props.searchIndex]]));
    search.instantiateTypeahead(this.$input, {
      selectCallback: this.handleSelect,
      context: this,
      template: {}
    });

    // hack to get around incompatibility between reactjs and typeahead
    this.$input.prev('input').removeAttr('data-reactid');
  }
});

module.exports = SearchField;
