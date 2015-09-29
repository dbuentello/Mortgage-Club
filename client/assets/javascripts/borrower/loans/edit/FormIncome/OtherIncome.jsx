var _ = require('lodash');

var React = require('react/addons');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');

var otherIncomes = [
      {value: 'overtime', name: 'Overtime'},
      {value: 'bonus', name: 'Bonus'},
      {value: 'commission', name: 'Commission'},
      {value: 'interest', name: 'Interest'}
    ];

var OtherIncome = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],

  getInitialState: function() {
    var state = {};
    state.income = this.props.income
    return state;
  },

  onChange: function(change) {
    var key = _.keys(change)[0];
    var value = _.values(change)[0]
    this.setState(this.setValue(this.state, key, value));
  },

  remove: function(index) {
    this.props.onRemove(index);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  render: function() {
    var index = this.props.index;
    return (
      <div className='row'>
        <div className='col-sm-6'>
          <SelectField
            label='Income Type'
            keyName={'income.type'}
            value={this.state.income.type}
            options={otherIncomes}
            editable={true}
            onChange={this.onChange}
            allowBlank={true} />
        </div>

        <div className='col-sm-5'>
          <TextField
            label='Annual Gross Amount'
            keyName={'income.amount'}
            value={this.state.income.amount}
            editable={true}
            onChange={this.onChange}/>
        </div>
        <div className='col-sm-1'>
          <a className="iconTrash clickable" onClick={this.remove.bind(this, index)} />
        </div>
      </div>
    );
  }
});

module.exports = OtherIncome;