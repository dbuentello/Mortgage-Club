var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');

var AddressField = require('components/form/NewAddressField');
var DateField = require('components/form/NewDateField');
var TextField = require('components/form/NewTextField');
var SelectField = require('components/form/NewSelectField');
var Income = require('./Income');

var fields = {
  currentEmployerName: {label: 'Name of current employer', name: 'current_employer_name', helpText: 'I am a helpful text.'},
  currentEmployerAddress: {label: 'Address of current employer', name: 'current_address', helpText: null},
  currentEmployerFullTextAddress: {name: 'current_full_text_address', helpText: null},
  currentJobTitle: {label: 'Job Title', name: 'current_job_title', helpText: null},
  currentYearsAtEmployer: {label: 'Years at this employer', name: 'current_duration', helpText: null},
  previousEmployerName: {label: 'Name of previous employer', name: 'previous_employer_name', helpText: 'I am a helpful text.'},
  previousJobTitle: {label: 'Job Title', name: 'previous_job_title', helpText: null},
  previousYearsAtEmployer: {label: 'Years at this employer', name: 'previous_duration', helpText: null},
  previousMonthlyIncome: {label: 'Monthly Income', name: 'previous_monthly_income', helpText: null},
  employerContactName: {label: 'Contact Name', name: 'employer_contact_name', helpText: null},
  employerContactNumber: {label: 'Contact Phone Number', name: 'employer_contact_number', helpText: null},
  baseIncome: {label: 'Base Income', name: 'current_salary', helpText: null},
  grossOvertime: {label: 'Annual Gross Overtime', name: 'gross_overtime', helpText: null},
  grossBonus: {label: 'Annual Gross Bonus', name: 'gross_bonus', helpText: null},
  grossCommission: {label: 'Annual Gross Commission', name: 'gross_commission', helpText: null},
  grossInterest: {label: 'Annual Gross Interest', name: 'gross_interest', helpText: null},
  incomeFrequency: {label: 'Income frequency', name: 'pay_frequency', helpText: null},
  otherIncomes: {name: 'borrower_other_incomes'}
};

var FormIncome = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    return this.buildStateFromLoan(this.props.loan);
  },

  onChange: function(change) {
    var key = Object.keys(change)[0];
    var value = change[key];
    if (key == 'address' && value == null) {
      change['a ddress'] = '';
    }
    this.setState(change);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  render: function() {
    return (
      <div className='col-xs-9 account-content'>
        <Income
          fields={fields}
          currentEmployerName={this.state[fields.currentEmployerName.name]}
          currentEmployerFullTextAddress={this.state[fields.currentEmployerFullTextAddress.name]}
          currentJobTitle={this.state[fields.currentJobTitle.name]}
          currentYearsAtEmployer={this.state[fields.currentYearsAtEmployer.name]}
          previousEmployerName={this.state[fields.previousEmployerName.name]}
          previousJobTitle={this.state[fields.previousJobTitle.name]}
          previousYearsAtEmployer={this.state[fields.previousYearsAtEmployer.name]}
          previousMonthlyIncome={this.state[fields.previousMonthlyIncome.name]}
          employerContactName={this.state[fields.employerContactName.name]}
          employerContactNumber={this.state[fields.employerContactNumber.name]}
          baseIncome={this.state[fields.baseIncome.name]}
          incomeFrequency={this.state[fields.incomeFrequency.name]}
          otherIncomes={this.state[fields.otherIncomes.name]}
          save={this.save}
          saving={this.state.saving}
          onFocus={this.onFocus}
          onChange={this.onChange}
          updateOtheIncomes={this.updateOtheIncomes}/>
      </div>
    );
  },

  componentWillReceiveProps: function(nextProps) {
    this.setState(_.extend(this.buildStateFromLoan(nextProps.loan), {
      saving: false
    }));
  },

  buildStateFromLoan: function(loan) {
    var borrower = loan.borrower;
    var state = {};
    var currentEmployment = borrower.current_employment || {};
    var previousEmployment = borrower.previous_employment;

    state[fields.currentEmployerName.name] = currentEmployment.employer_name;
    state[fields.currentEmployerAddress.name] = currentEmployment.address;
    state[fields.currentJobTitle.name] = currentEmployment.job_title;
    state[fields.currentYearsAtEmployer.name] = currentEmployment.duration;
    if (!state[fields.currentEmployerAddress.name]) {
      state[fields.currentEmployerAddress.name] = {full_text: ''};
    }
    state[fields.currentEmployerFullTextAddress.name] = state[fields.currentEmployerAddress.name].full_text;

    if (previousEmployment) {
      state[fields.previousEmployerName.name] = previousEmployment.employer_name;
      state[fields.previousJobTitle.name] = previousEmployment.job_title;
      state[fields.previousYearsAtEmployer.name] = previousEmployment.duration;
      state[fields.previousMonthlyIncome.name] = previousEmployment.monthly_income;
    }

    state[fields.employerContactName.name] = currentEmployment[fields.employerContactName.name];
    state[fields.employerContactNumber.name] = currentEmployment[fields.employerContactNumber.name];
    state[fields.baseIncome.name] = this.formatCurrency(currentEmployment[fields.baseIncome.name]);
    state[fields.incomeFrequency.name] = currentEmployment[fields.incomeFrequency.name];
    state[fields.otherIncomes.name] = []

    if (borrower.gross_overtime){
      state[fields.otherIncomes.name].push({
        type: 'overtime',
        amount: borrower.gross_overtime
      });
    }
    if (borrower.gross_bonus){
      state[fields.otherIncomes.name].push({
        type: 'bonus',
        amount: borrower.gross_bonus
      });
    }
    if (borrower.gross_commission){
      state[fields.otherIncomes.name].push({
        type: 'commission',
        amount: borrower.gross_commission
      });
    }
    if (borrower.gross_interest){
      state[fields.otherIncomes.name].push({
        type: 'interest',
        amount: borrower.gross_interest
      });
    }

    return state;
  },

  buildLoanFromState: function() {
    var loan = {};
    var currentEmployment = this.props.loan.borrower.current_employment;
    var previousEmployment = this.props.loan.borrower.previous_employment;

    loan.borrower_attributes = {id: this.props.loan.borrower.id};
    loan.borrower_attributes[fields.grossOvertime.name] = this.getOtherIncome('overtime');
    loan.borrower_attributes[fields.grossBonus.name] = this.getOtherIncome('bonus');
    loan.borrower_attributes[fields.grossCommission.name] = this.getOtherIncome('commission');
    loan.borrower_attributes[fields.grossInterest.name] = this.getOtherIncome('interest');

    loan.borrower_attributes.employments_attributes = [{
      id: currentEmployment ? currentEmployment.id : null,
      employer_name: this.state[fields.currentEmployerName.name],
      address_attributes: { 'full_text': this.state[fields.currentEmployerFullTextAddress.name]},
      job_title: this.state[fields.currentJobTitle.name],
      duration: this.state[fields.currentYearsAtEmployer.name],
      employer_contact_name: this.state[fields.employerContactName.name],
      employer_contact_number: this.state[fields.employerContactNumber.name],
      pay_frequency: this.state[fields.incomeFrequency.name],
      current_salary: this.currencyToNumber(this.state[fields.baseIncome.name]),
      is_current: true
    }];

    if (this.state[fields.currentYearsAtEmployer.name] < 2) {
      loan.borrower_attributes.employments_attributes.push({
        id: previousEmployment ? previousEmployment.id : null,
        employer_name: this.state[fields.previousEmployerName.name],
        job_title: this.state[fields.previousJobTitle.name],
        duration: this.state[fields.previousYearsAtEmployer.name],
        monthly_income: this.state[fields.previousMonthlyIncome.name],
        is_current: false
      })
    }

    return loan;
  },

  getOtherIncome: function(type) {
    var amount = null;
    _.each(this.state[fields.otherIncomes.name], function(income) {
      if (income.type == type)
        return amount = income.amount;
    });
    return amount;
  },

  updateOtheIncomes: function(fields, newOtherIncomes) {
    var state = {};
    state[fields.otherIncomes.name] = newOtherIncomes;
    this.setState(state);
  },

  save: function(event) {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 3);

    event.preventDefault();
  }
});

module.exports = FormIncome;