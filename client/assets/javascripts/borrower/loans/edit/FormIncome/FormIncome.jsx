var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');

var AddressField = require('components/form/NewAddressField');
var DateField = require('components/form/NewDateField');
var TextField = require('components/form/NewTextField');
var SelectField = require('components/form/NewSelectField');
var OtherIncome = require('./OtherIncome');

var fields = {
  employerName: {label: 'Name of current employer', name: 'employer_name', helpText: 'I am a helpful text.'},
  employerAddress: {label: 'Address of current employer', name: 'address', helpText: null},
  employerFullTextAddress: {name: 'full_text', helpText: null},
  jobTitle: {label: 'Job Title', name: 'job_title', helpText: null},
  monthsAtEmployer: {label: 'Years at this employer', name: 'duration', helpText: null},
  employerContactName: {label: 'Contact Name', name: 'employer_contact_name', helpText: null},
  employerContactNumber: {label: 'Contact Phone Number', name: 'employer_contact_number', helpText: null},
  baseIncome: {label: 'Base Income', name: 'current_salary', helpText: null},
  grossOvertime: {label: 'Annual Gross Overtime', name: 'gross_overtime', helpText: null},
  grossBonus: {label: 'Annual Gross Bonus', name: 'gross_bonus', helpText: null},
  grossCommission: {label: 'Annual Gross Commission', name: 'gross_commission', helpText: null},
  grossInterest: {label: 'Annual Gross Interest', name: 'gross_interest', helpText: null},
  incomeFrequency: {label: 'Income frequency', name: 'pay_frequency', helpText: null}
};

var incomeFrequencies = [
  {value: 'semimonthly', name: 'Semi-monthly'},
  {value: 'biweekly', name: 'Bi-weekly'},
  {value: 'weekly', name: 'Weekly'}
];

var FormIncome = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    return this.buildStateFromLoan(this.props.loan);
  },

  onChange: function(change) {
    var key = Object.keys(change)[0];
    var value = change[key];
    if (key == 'address' && value == null) {
      change['address'] = '';
    }
    this.setState(change);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  changeIncomeType: function(value, i) {
    var arr = this.state.otherIncomes;
    arr[i].type = value;
    this.setState({otherIncomes: arr});
  },

  changeIncomeAmount: function(value, i) {
    var arr = this.state.otherIncomes;
    arr[i].amount = value;
    this.setState({otherIncomes: arr});
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

  render: function() {
    return (
      <div className='col-xs-9 account-content'>
        <form className='form-horizontal'>
          <div className='form-group'>
            <div className='col-md-6'>
              <TextField
                label={fields.employerName.label}
                keyName={fields.employerName.name}
                value={this.state[fields.employerName.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.employerName)}
                onChange={this.onChange}/>
            </div>
            <div className='col-md-6'>
              <TextField
                label={fields.employerAddress.label}
                keyName={fields.employerFullTextAddress.name}
                value={this.state[fields.employerFullTextAddress.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.employerFullTextAddress)}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className='form-group'>
            <div className='col-md-6'>
              <TextField
                label={fields.jobTitle.label}
                keyName={fields.jobTitle.name}
                value={this.state[fields.jobTitle.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.jobTitle)}
                onChange={this.onChange}/>
            </div>
            <div className='col-md-6'>
              <TextField
                label={fields.monthsAtEmployer.label}
                keyName={fields.monthsAtEmployer.name}
                value={this.state[fields.monthsAtEmployer.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.monthsAtEmployer)}
                onChange={this.onChange}/>
            </div>
          </div>
          <h3 className="text-uppercase">best contact to confirm employment</h3>
          <div className='form-group'>
            <div className='col-md-6'>
              <TextField
                label={fields.employerContactName.label}
                keyName={fields.employerContactName.name}
                value={this.state[fields.employerContactName.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.employerContactName)}
                onChange={this.onChange}/>
            </div>
            <div className='col-md-6'>
              <TextField
                label={fields.employerContactNumber.label}
                keyName={fields.employerContactNumber.name}
                value={this.state[fields.employerContactNumber.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.employerContactNumber)}
                onChange={this.onChange}/>
            </div>
          </div>
          <h3 className="text-uppercase">income details</h3>
          <div className='form-group'>
            <div className='col-md-6'>
              <TextField
                label={fields.baseIncome.label}
                keyName={fields.baseIncome.name}
                value={this.state[fields.baseIncome.name]}
                liveFormat={true}
                format={this.formatCurrency}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.baseIncome)}
                onChange={this.onChange}
                placeholder='e.g. 99,000'/>
            </div>
            <div className='col-md-6'>
              <SelectField
                label={fields.incomeFrequency.label}
                keyName={fields.incomeFrequency.name}
                value={this.state[fields.incomeFrequency.name]}
                options={incomeFrequencies}
                editable={true}
                onChange={this.onChange}
                onFocus={this.onFocus.bind(this, fields.incomeFrequency)}
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
              <button className="btn theBtn text-uppercase" id="continueBtn" onClick={this.save}>{ this.state.saving ? 'Saving' : 'Save and Continue' }<img src="/icons/arrowRight.png" alt="arrow"/></button>
            </div>
          </div>
        </form>
      </div>
    );
  },

  componentWillReceiveProps: function(nextProps) {
    this.setState(_.extend(this.buildStateFromLoan(nextProps.loan), {
      saving: false
    }));
  },

  display_document: function(file_name) {
    return;
  },

  buildStateFromLoan: function(loan) {
    var borrower = loan.borrower;
    var state = {};
    var currentEmployment = borrower.current_employment || {};
    state[fields.employerName.name] = currentEmployment[fields.employerName.name];
    state[fields.employerAddress.name] = currentEmployment[fields.employerAddress.name];
    state[fields.jobTitle.name] = currentEmployment[fields.jobTitle.name];
    state[fields.monthsAtEmployer.name] = currentEmployment[fields.monthsAtEmployer.name];
    state[fields.employerContactName.name] = currentEmployment[fields.employerContactName.name];
    state[fields.employerContactNumber.name] = currentEmployment[fields.employerContactNumber.name];
    state[fields.baseIncome.name] = this.formatCurrency(currentEmployment[fields.baseIncome.name]);
    state[fields.incomeFrequency.name] = currentEmployment[fields.incomeFrequency.name];

    state.otherIncomes = []

    if (borrower.gross_overtime){
      state.otherIncomes.push({
        type: 'overtime',
        amount: borrower.gross_overtime
      });
    }
    if (borrower.gross_bonus){
      state.otherIncomes.push({
        type: 'bonus',
        amount: borrower.gross_bonus
      });
    }
    if (borrower.gross_commission){
      state.otherIncomes.push({
        type: 'commission',
        amount: borrower.gross_commission
      });
    }
    if (borrower.gross_interest){
      state.otherIncomes.push({
        type: 'interest',
        amount: borrower.gross_interest
      });
    }

    if (!state[fields.employerAddress.name]) {
      state[fields.employerAddress.name] = {full_text: ''};
    }
    state[fields.employerFullTextAddress.name] = state[fields.employerAddress.name].full_text;
    return state;
  },

  buildLoanFromState: function() {
    var loan = {};
    var currentEmployment = this.props.loan.borrower.current_employment;

    loan.borrower_attributes = {id: this.props.loan.borrower.id};
    loan.borrower_attributes[fields.grossOvertime.name] = this.getOtherIncome('overtime');
    loan.borrower_attributes[fields.grossBonus.name] = this.getOtherIncome('bonus');
    loan.borrower_attributes[fields.grossCommission.name] = this.getOtherIncome('commission');
    loan.borrower_attributes[fields.grossInterest.name] = this.getOtherIncome('interest');

    loan.borrower_attributes.employments_attributes = [{
      id: currentEmployment ? currentEmployment.id : null,
      employer_name: this.state[fields.employerName.name],
      address_attributes: { 'full_text': this.state[fields.employerFullTextAddress.name]},
      job_title: this.state[fields.jobTitle.name],
      duration: this.state[fields.monthsAtEmployer.name],
      employer_contact_name: this.state[fields.employerContactName.name],
      employer_contact_number: this.state[fields.employerContactNumber.name],
      pay_frequency: this.state[fields.incomeFrequency.name],
      current_salary: this.currencyToNumber(this.state[fields.baseIncome.name]),
      is_current: true
    }];

    return loan;
  },

  getOtherIncome: function(type) {
    var amount = null;
    _.each(this.state.otherIncomes, function(income) {
      if (income.type == type)
        return amount = income.amount;
    });
    return amount;
  },

  getDefaultOtherIncomes: function() {
    return [{
      type: null,
      amount: null
    }];
  },

  addOtherIncome: function() {
    this.setState({otherIncomes: this.state.otherIncomes.concat(this.getDefaultOtherIncomes())});
  },

  removeOtherIncome: function(index) {
    var arr = this.state.otherIncomes;
    arr.splice(index, 1);
    this.setState({otherIncomes: arr});
  },

  save: function(event) {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 3);
    event.preventDefault();
  }
});

module.exports = FormIncome;