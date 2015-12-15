var _ = require('lodash');

var React = require('react/addons');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var SelectField = require('components/form/NewSelectField');
var TextField = require('components/form/NewTextField');

var otherIncomes = [
      {value: 'overtime', name: 'Overtime'},
      {value: 'bonus', name: 'Bonus'},
      {value: 'commission', name: 'Commission'},
      {value: 'interest', name: 'Interest'}
    ];

var OtherIncome = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],

  onChange: function(change) {
    var key = Object.keys(change)[0];
    var value = change[key];
    if (key == 'income.type') {
      this.props.onChangeType(value, this.props.index);
    }
    if (key == 'income.amount') {
      this.props.onChangeAmount(value, this.props.index);
    }
  },

  remove: function(index) {
    this.props.onRemove(index);
  },

  render: function() {
    var index = this.props.index;
    return (
      <div className={this.props.type + ' form-group'}>
        <div className='col-md-6'>
          <SelectField
            label='Income Type'
            ref="incomeType"
            keyName={'income.type'}
            value={this.props.type}
            options={otherIncomes}
            editable={true}
            onChange={this.onChange}
            allowBlank={true} />
        </div>
        <div className='col-md-5'>
          <TextField
            label='Annual Gross Amount'
            ref="incomeAmount"
            keyName={'income.amount'}
            value={this.props.amount}
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