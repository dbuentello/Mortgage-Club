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

    if (key.indexOf('incomes_type') > -1){
      this.props.onChangeType(value, this.props.index);
    }
    if (key.indexOf('incomes_amount') > -1) {
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
            activateRequiredField={this.props.typeError}
            label='Income Type'
            ref="incomeType"
            keyName={this.props.name + '_type_' + index}
            value={this.props.type}
            options={otherIncomes}
            editable={true}
            onChange={this.onChange}
            allowBlank={true} />
        </div>
        <div className='col-md-5'>
          <TextField
            activateRequiredField={this.props.amountError}
            label='Annual Gross Amount'
            ref="incomeAmount"
            keyName={this.props.name + '_amount_' + index}
            value={this.props.amount}
            editable={true}
            maxLength={15}
            validationTypes={["currency"]}
            onChange={this.onChange}/>
        </div>
        <div className='col-sm-1'>
          <a className="clickable annual-gross-amount-trash-icon" onClick={this.remove.bind(this, index)}>
            <img src="/icons/trash.png"/>
          </a>
        </div>
      </div>
    );
  }
});

module.exports = OtherIncome;