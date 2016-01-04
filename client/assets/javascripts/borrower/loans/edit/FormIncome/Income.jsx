var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');
var AddressField = require('components/form/NewAddressField');
var DateField = require('components/form/NewDateField');
var TextField = require('components/form/NewTextField');
var SelectField = require('components/form/NewSelectField');
var OtherIncome = require('./OtherIncome');

var incomeFrequencies = [
  {value: 'semimonthly', name: 'Semi-monthly'},
  {value: 'biweekly', name: 'Bi-weekly'},
  {value: 'weekly', name: 'Weekly'}
];

var Income = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    return {
      otherIncomes: this.props.otherIncomes
    }
  },

  eachOtherIncome: function(income, index) {
    return (
      <OtherIncome
        key={index}
        index={index}
        type={income.type}
        amount={income.amount}
        onChangeType={this.changeIncomeType}
        onChangeAmount={this.changeIncomeAmount}
        onRemove={this.removeOtherIncome}/>
    );
  },

  changeIncomeType: function(value, i) {
    var arr = this.state.otherIncomes;
    arr[i].type = value;
    this.setState({otherIncomes: arr});
    this.props.updateOtheIncomes(this.props.fields, arr);
  },

  changeIncomeAmount: function(value, i) {
    var arr = this.state.otherIncomes;
    arr[i].amount = value;
    this.setState({otherIncomes: arr});
    this.props.updateOtheIncomes(this.props.fields, arr);
  },

  addOtherIncome: function() {
    var arr = this.state.otherIncomes.concat(this.getDefaultOtherIncomes());
    this.setState({otherIncomes: arr});
    this.props.updateOtheIncomes(this.props.fields, arr);
  },

  getDefaultOtherIncomes: function() {
    return [{
      type: null,
      amount: null
    }];
  },

  removeOtherIncome: function(index) {
    var arr = this.state.otherIncomes;
    arr.splice(index, 1);
    this.setState({otherIncomes: arr});
  },

  render: function() {
    return (
      <form className='form-horizontal'>
        <div className='form-group'>
          <div className='col-md-6'>
            <TextField
              label={this.props.fields.employerName.label}
              keyName={this.props.fields.employerName.name}
              value={this.props.employerName}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.employerName)}
              onChange={this.props.onChange}/>
          </div>
          <div className='col-md-6'>
            <TextField
              label={this.props.fields.employerAddress.label}
              keyName={this.props.fields.employerFullTextAddress.name}
              value={this.props.employerFullTextAddress}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.employerFullTextAddress)}
              onChange={this.props.onChange}/>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-md-6'>
            <TextField
              label={this.props.fields.jobTitle.label}
              keyName={this.props.fields.jobTitle.name}
              value={this.props.jobTitle}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.jobTitle)}
              onChange={this.props.onChange}/>
          </div>
          <div className='col-md-6'>
            <TextField
              label={this.props.fields.monthsAtEmployer.label}
              keyName={this.props.fields.monthsAtEmployer.name}
              value={this.props.monthsAtEmployer}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.monthsAtEmployer)}
              onChange={this.props.onChange}/>
          </div>
        </div>
        <h3 className="text-uppercase">best contact to confirm employment</h3>
        <div className='form-group'>
          <div className='col-md-6'>
            <TextField
              label={this.props.fields.employerContactName.label}
              keyName={this.props.fields.employerContactName.name}
              value={this.props.employerContactName}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.employerContactName)}
              onChange={this.props.onChange}/>
          </div>
          <div className='col-md-6'>
            <TextField
              label={this.props.fields.employerContactNumber.label}
              keyName={this.props.fields.employerContactNumber.name}
              value={this.props.employerContactNumber}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.employerContactNumber)}
              onChange={this.props.onChange}/>
          </div>
        </div>
        <h3 className="text-uppercase">income details</h3>
        <div className='form-group'>
          <div className='col-md-6'>
            <TextField
              label={this.props.fields.baseIncome.label}
              keyName={this.props.fields.baseIncome.name}
              value={this.props.baseIncome}
              liveFormat={true}
              format={this.formatCurrency}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.baseIncome)}
              onChange={this.props.onChange}
              placeholder='e.g. 99,000'/>
          </div>
          <div className='col-md-6'>
            <SelectField
              label={this.props.fields.incomeFrequency.label}
              keyName={this.props.fields.incomeFrequency.name}
              value={this.props.incomeFrequency}
              options={incomeFrequencies}
              editable={true}
              onChange={this.props.onChange}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.incomeFrequency)}
              allowBlank={true}/>
          </div>
        </div>

        {this.state.otherIncomes.map(this.eachOtherIncome)}

        <div className='form-group'>
          <div className='col-md-12 clickable' onClick={this.addOtherIncome}>
            <h5>
              <span className="glyphicon glyphicon-plus-sign"></span>
                Add other income
            </h5>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-md-12'>
            <button className="btn theBtn text-uppercase" id="continueBtn" onClick={this.props.save}>{ this.state.saving ? 'Saving' : 'Save and Continue' }<img src="/icons/arrowRight.png" alt="arrow"/></button>
          </div>
        </div>
      </form>
    )
  }
})

module.exports = Income;