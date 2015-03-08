/* global Bloodhound */



var TextFocusMixin = require('../../mixins/text_focus_mixin');

/**
 * TypeaheadField is a text field that has autosuggestion built-in.
 */
var TypeaheadField = React.createClass({
  mixins: [TextFocusMixin],

  propTypes: {
    editable: React.PropTypes.bool, // determines if component should show the input box or the static text
    label: React.PropTypes.string, // field label

    // initial value
    value: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.number
    ]),

    // @options is an array of objects with properties `name` and `value`.
    // It is used to build the options for the select input, and also to query for
    // the display text showed when the field is in read-only mode.
    options: React.PropTypes.arrayOf(React.PropTypes.object),

    // @remote is a hash describing the remote endpoint to use in addition or
    // in place of the local data.
    // See https://github.com/twitter/typeahead.js/blob/master/doc/bloodhound.md#remote
    // for information about the keys. The minimum requirement is to include a
    // key `url` with the endpoint to send the query to.
    remote: React.PropTypes.object,

    // if true, when user clear out the input, onChange would be invoked with
    // the change {[keyName]: null}
    allowBlank: React.PropTypes.bool,

    // if true, when user will be forced to select from the dropdown. If false,
    // they will be able to enter whatever they want. The text entered in the box
    // will be used as the value
    forceSelection: React.PropTypes.bool,

    // array of the options' property keys that Bloodhound should search with. Default to just ['name']
    searchKeys: React.PropTypes.arrayOf(React.PropTypes.string),

    // if onChange is provided, when user changes the input, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [value]} where @keyName is from the props and `value` is the value of the option.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,

    // input placeholder
    placeholder: React.PropTypes.string,

    // the larger input size if true
    isLarge: React.PropTypes.bool
  },

  getDefaultProps: function() {
    return {
      searchKeys: ['name'],
      allowBlank: false,
      forceSelection: true,
      remote: null,
      isLarge: false
    };
  },

  getInitialState: function() {
    var selected = _.findWhere(this.props.options, {value: this.props.value}),
        noSelectionValue = this.props.forceSelection ? '' : this.props.value;

    return {
      name: selected ? selected.name : noSelectionValue
    };
  },

  componentDidMount: function() {
    this.$input = $(this.getDOMNode()).find('input');
    this.initTypeAhead();
  },

  componentWillUnmount: function() {
    this.$input.typeahead('destroy');
  },

  componentWillReceiveProps: function(nextProps) {
    var options = nextProps.options,
        selected, noSelectionValue;

    if (nextProps.value !== this.props.value) {
      selected = _.findWhere(options, {value: nextProps.value});
      noSelectionValue = this.props.forceSelection ? '' : nextProps.value;

      this.setState({
        name: selected ? selected.name : noSelectionValue
      });
    }

    if (!_.isEqual(options, this.props.options)) {
      this.resetOptions(options);
    }
  },

  render: function() {
    var props = this.props;
    return (
      <div>
        <label className="col-xs-12 pan" style={{'display': props.editable ? null : 'none'}}>
          <span className={props.label ? 'mrs' : null}>{props.label}</span>
          <input className={'form-control ' + (props.isLarge ? '' : 'input-sm')} type="text" value={this.state.name}
            onFocus={this.handleFocus} onChange={this.handleChange} placeholder={props.placeholder}/>
        </label>
        <div style={{'display': props.editable ? 'none' : null}}>
          <label className="col-xs-12 pan">
            <span className={props.label ? 'mrs' : null}>{props.label}</span>
          </label>
          <p className="form-control-static typeTruncate col-xs-12 pan">{this.state.name}</p>
        </div>
      </div>
    );
  },

  handleChange: function(event) {
    var name = event.target.value;
    if (name === '' && this.props.allowBlank) {
      this.handleSelect(event, {value: null, name: name});
    }

    this.setState({name: name});
  },

  handleSelect: function(event, selection) {
    var change = {};

    this.setState({
      name: selection.name
    });

    change[this.props.keyName] = selection.value;
    if (typeof this.props.onChange == 'function') {
      this.props.onChange(change);
    }
  },

  forceSelection: function() {
    var name = this.$input.val(),
        selected;

    if(this.props.forceSelection) {
      if (!_.findWhere(this.props.options, {name: name})) {
        selected = _.findWhere(this.props.options, {value: this.props.value});
        this.setState({name: selected ? selected.name : ''});
      }
    } else {
      this.handleSelect({}, {
        name: name,
        value: name
      });
    }
  },

  initTypeAhead: function() {
    this.options = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace.apply(null, this.props.searchKeys),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      limit: 10,
      local: []
    });

    this.resetOptions(this.props.options);

    this.$input.typeahead({
      highlight: true
    }, {
      displayKey: 'name',
      source: this.options.ttAdapter()
    }).on('blur', this.forceSelection);

    // hack to get around incompatibility between reactjs and typeahead
    this.$input.prev('input').removeAttr('data-reactid');

    // set state when user selects an option
    this.$input.on('typeahead:selected', this.handleSelect);
  },

  resetOptions: function(options) {
    this.options.clear();
    this.options.local = options;
    if (this.props.remote) {
      this.options.remote = this.props.remote;
    }
    this.options.initialize(true);
  }
});

module.exports = TypeaheadField;
