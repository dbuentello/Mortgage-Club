var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');
var ValidationObject = require("mixins/ValidationMixins");

var AddressField = require('components/form/NewAddressField');
var DateField = require('components/form/NewDateField');
var TextField = require('components/form/NewTextField');
var SelectField = require('components/form/NewSelectField');
var Income = require('./Income');

var borrowerFields = {
  currentEmployerName: {label: 'Name of current employer', name: 'current_employer_name', helpText: 'I am a helpful text.', error: "current_employer_name_error"},
  currentEmployerAddress: {label: 'Address of current employer', name: 'current_address', helpText: null, error: "current_address_error"},
  currentEmployerFullTextAddress: {name: 'current_full_text_address', helpText: null, error: "current_full_text_address_error"},
  currentJobTitle: {label: 'Job Title', name: 'current_job_title', helpText: null, error: "current_job_title_error"},
  currentYearsAtEmployer: {label: 'Years at this employer', name: 'current_duration', helpText: null, error: "current_duration_error"},
  previousEmployerName: {label: 'Name of previous employer', name: 'previous_employer_name', helpText: 'I am a helpful text.', error: "previous_employer_name_error"},
  previousJobTitle: {label: 'Job Title', name: 'previous_job_title', helpText: null, error: "previous_job_title_error"},
  previousYearsAtEmployer: {label: 'Years at this employer', name: 'previous_duration', helpText: null, error: "previous_duration_error"},
  previousMonthlyIncome: {label: 'Monthly Income', name: 'previous_monthly_income', helpText: null, error: "previous_monthly_income_error"},
  employerContactName: {label: 'Contact Name', name: 'employer_contact_name', helpText: null, error: "employer_contact_name_error"},
  employerContactNumber: {label: 'Contact Phone Number', name: 'employer_contact_number', helpText: null, error: "employer_contact_number_error"},
  baseIncome: {label: 'Base Income', name: 'current_salary', helpText: null, error: "current_salary_error"},
  grossOvertime: {label: 'Annual Gross Overtime', name: 'gross_overtime', helpText: null, error: "gross_overtime_error"},
  grossBonus: {label: 'Annual Gross Bonus', name: 'gross_bonus', helpText: null, error: "gross_bonus_error"},
  grossCommission: {label: 'Annual Gross Commission', name: 'gross_commission', helpText: null, error: "gross_commission_error"},
  grossInterest: {label: 'Annual Gross Interest', name: 'gross_interest', helpText: null, error: "gross_interest_error"},
  incomeFrequency: {label: 'Income frequency', name: 'pay_frequency', helpText: null, error: "pay_frequency_error"},
  otherIncomes: {name: 'borrower_other_incomes'}
};

var secondaryBorrowerFields = {
  currentEmployerName: {label: 'Name of current employer', name: 'secondary_current_employer_name', helpText: 'I am a helpful text.', error: "secondary_current_employer_name_error"},
  currentEmployerAddress: {label: 'Address of current employer', name: 'secondary_current_address', helpText: null, error: "secondary_current_address_error"},
  currentEmployerFullTextAddress: {name: 'secondary_current_full_text_address', helpText: null, error: "secondary_current_full_text_address_error"},
  currentJobTitle: {label: 'Job Title', name: 'secondary_current_job_title', helpText: null, error: "secondary_current_job_title_error"},
  currentYearsAtEmployer: {label: 'Years at this employer', name: 'secondary_current_duration', helpText: null, error: "secondary_current_duration_error"},
  previousEmployerName: {label: 'Name of previous employer', name: 'secondary_previous_employer_name', helpText: 'I am a helpful text.', error: "secondary_previous_employer_name_error"},
  previousJobTitle: {label: 'Job Title', name: 'secondary_previous_job_title', helpText: null, error: "secondary_previous_job_title_error"},
  previousYearsAtEmployer: {label: 'Years at this employer', name: 'secondary_previous_duration', helpText: null, error: "secondary_previous_duration_error"},
  previousMonthlyIncome: {label: 'Monthly Income', name: 'secondary_previous_monthly_income', helpText: null, error: "secondary_previous_monthly_income_error"},
  employerContactName: {label: 'Contact Name', name: 'secondary_employer_contact_name', helpText: null, error: "secondary_employer_contact_name_error"},
  employerContactNumber: {label: 'Contact Phone Number', name: 'secondary_employer_contact_number', helpText: null, error: "secondary_employer_contact_number_error"},
  baseIncome: {label: 'Base Income', name: 'secondary_current_salary', helpText: null, error: "secondary_current_salary_error"},
  grossOvertime: {label: 'Annual Gross Overtime', name: 'secondary_gross_overtime', helpText: null, error: "secondary_gross_overtime_error"},
  grossBonus: {label: 'Annual Gross Bonus', name: 'secondary_gross_bonus', helpText: null, error: "secondary_gross_bonus_error"},
  grossCommission: {label: 'Annual Gross Commission', name: 'secondary_gross_commission', helpText: null, error: "secondary_gross_commission_error"},
  grossInterest: {label: 'Annual Gross Interest', name: 'secondary_gross_interest', helpText: null, error: "secondary_gross_interest_error"},
  incomeFrequency: {label: 'Income frequency', name: 'secondary_pay_frequency', helpText: null, error: "secondary_pay_frequency_error"},
  otherIncomes: {name: 'secondary_borrower_other_incomes'}
};

var Form = React.createClass({
  mixins: [TextFormatMixin, ValidationObject],

  getInitialState: function() {
    var state = this.buildStateFromLoan(this.props.loan);
    state.activateError = false;
    return state;
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

  render: function() {
    return (
      <div className='col-xs-9 account-content'>
        <form className="form-horizontal">
          <Income
            fields={borrowerFields}
            currentEmployerName={this.state[borrowerFields.currentEmployerName.name]}
            currentEmployerFullTextAddress={this.state[borrowerFields.currentEmployerFullTextAddress.name]}
            currentJobTitle={this.state[borrowerFields.currentJobTitle.name]}
            currentYearsAtEmployer={this.state[borrowerFields.currentYearsAtEmployer.name]}
            previousEmployerName={this.state[borrowerFields.previousEmployerName.name]}
            previousJobTitle={this.state[borrowerFields.previousJobTitle.name]}
            previousYearsAtEmployer={this.state[borrowerFields.previousYearsAtEmployer.name]}
            previousMonthlyIncome={this.state[borrowerFields.previousMonthlyIncome.name]}
            employerContactName={this.state[borrowerFields.employerContactName.name]}
            employerContactNumber={this.state[borrowerFields.employerContactNumber.name]}
            baseIncome={this.state[borrowerFields.baseIncome.name]}
            incomeFrequency={this.state[borrowerFields.incomeFrequency.name]}
            otherIncomes={this.state[borrowerFields.otherIncomes.name]}

            currentEmployerNameError={this.state[borrowerFields.currentEmployerName.error]}
            currentEmployerFullTextAddressError={this.state[borrowerFields.currentEmployerFullTextAddress.error]}
            currentJobTitleError={this.state[borrowerFields.currentJobTitle.error]}
            currentYearsAtEmployerError={this.state[borrowerFields.currentYearsAtEmployer.error]}
            previousEmployerNameError={this.state[borrowerFields.previousEmployerName.error]}
            previousJobTitleError={this.state[borrowerFields.previousJobTitle.error]}
            previousYearsAtEmployerError={this.state[borrowerFields.previousYearsAtEmployer.error]}
            previousMonthlyIncomeError={this.state[borrowerFields.previousMonthlyIncome.error]}
            employerContactNameError={this.state[borrowerFields.employerContactName.error]}
            employerContactNumberError={this.state[borrowerFields.employerContactNumber.error]}
            baseIncomeError={this.state[borrowerFields.baseIncome.error]}
            incomeFrequencyError={this.state[borrowerFields.incomeFrequency.error]}

            onFocus={this.onFocus}
            onChange={this.onChange}
            updateOtheIncomes={this.updateOtheIncomes}/>
          {
            this.props.loan.secondary_borrower
            ?
            <div className='box mtn'>
              <hr/>
              <br/>
              <h3>Please provide income information of your co-borrower</h3>
              <Income
                fields={secondaryBorrowerFields}
                currentEmployerName={this.state[secondaryBorrowerFields.currentEmployerName.name]}
                currentEmployerFullTextAddress={this.state[secondaryBorrowerFields.currentEmployerFullTextAddress.name]}
                currentJobTitle={this.state[secondaryBorrowerFields.currentJobTitle.name]}
                currentYearsAtEmployer={this.state[secondaryBorrowerFields.currentYearsAtEmployer.name]}
                previousEmployerName={this.state[secondaryBorrowerFields.previousEmployerName.name]}
                previousJobTitle={this.state[secondaryBorrowerFields.previousJobTitle.name]}
                previousYearsAtEmployer={this.state[secondaryBorrowerFields.previousYearsAtEmployer.name]}
                previousMonthlyIncome={this.state[secondaryBorrowerFields.previousMonthlyIncome.name]}
                employerContactName={this.state[secondaryBorrowerFields.employerContactName.name]}
                employerContactNumber={this.state[secondaryBorrowerFields.employerContactNumber.name]}
                baseIncome={this.state[secondaryBorrowerFields.baseIncome.name]}
                incomeFrequency={this.state[secondaryBorrowerFields.incomeFrequency.name]}
                otherIncomes={this.state[secondaryBorrowerFields.otherIncomes.name]}

                currentEmployerNameError={this.state[secondaryBorrowerFields.currentEmployerName.error]}
                currentEmployerFullTextAddressError={this.state[secondaryBorrowerFields.currentEmployerFullTextAddress.error]}
                currentJobTitleError={this.state[secondaryBorrowerFields.currentJobTitle.error]}
                currentYearsAtEmployerError={this.state[secondaryBorrowerFields.currentYearsAtEmployer.error]}
                previousEmployerNameError={this.state[secondaryBorrowerFields.previousEmployerName.error]}
                previousJobTitleError={this.state[secondaryBorrowerFields.previousJobTitle.error]}
                previousYearsAtEmployerError={this.state[secondaryBorrowerFields.previousYearsAtEmployer.error]}
                previousMonthlyIncomeError={this.state[secondaryBorrowerFields.previousMonthlyIncome.error]}
                employerContactNameError={this.state[secondaryBorrowerFields.employerContactName.error]}
                employerContactNumberError={this.state[secondaryBorrowerFields.employerContactNumber.error]}
                baseIncomeError={this.state[secondaryBorrowerFields.baseIncome.error]}
                incomeFrequencyError={this.state[secondaryBorrowerFields.incomeFrequency.error]}

                onFocus={this.onFocus}
                onChange={this.onChange}
                updateOtheIncomes={this.updateOtheIncomes}/>
            </div>
            : null
          }
          <div className="form-group">
            <div className="col-md-12">
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

  buildStateFromLoan: function(loan) {
    var state = {};
    state = this.buildStateFromBorrower(loan.borrower, borrowerFields, state);
    if (loan.secondary_borrower) {
      state = this.buildStateFromBorrower(loan.secondary_borrower, secondaryBorrowerFields, state);
    }
    return state;
  },

  buildStateFromBorrower: function(borrower, fields, state) {
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
      state[fields.previousMonthlyIncome.name] = this.formatCurrency(previousEmployment.monthly_income);
    }

    state[fields.employerContactName.name] = currentEmployment.employer_contact_name;
    state[fields.employerContactNumber.name] = currentEmployment.employer_contact_number;
    state[fields.baseIncome.name] = this.formatCurrency(currentEmployment.current_salary);
    state[fields.incomeFrequency.name] = currentEmployment.pay_frequency;
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
    var borrower = this.props.loan.borrower;
    var secondaryBorrower = this.props.loan.secondary_borrower;

    loan.borrower_attributes = _.extend(this.getIncomes(borrowerFields), {id: borrower.id});
    loan.borrower_attributes.employments_attributes = this.getEmployments(this.props.loan.borrower, borrowerFields);
    if (this.props.loan.secondary_borrower) {
      loan.secondary_borrower_attributes = _.extend(this.getIncomes(secondaryBorrowerFields), {id: secondaryBorrower.id});
      loan.secondary_borrower_attributes.employments_attributes = this.getEmployments(secondaryBorrower, secondaryBorrowerFields);
    }
    return loan;
  },

  getGrossIncome: function(frequency, salary) {
    var grossIncome = 0;
    switch(frequency) {
      case "monthly":
        grossIncome = salary * 12;
        break;
      case "semimonthly":
        grossIncome = salary * 24;
        break;
      case "biweekly":
        grossIncome = salary * 26;
        break;
      case "weekly":
        grossIncome = salary * 52;
        break;
    }
    return grossIncome;
  },

  getIncomes: function(fields) {
    var incomes = {
      gross_overtime: this.getOtherIncome(fields, 'overtime'),
      gross_bonus: this.getOtherIncome(fields, 'bonus'),
      gross_commission: this.getOtherIncome(fields, 'commission'),
      gross_interest: this.getOtherIncome(fields, 'interest'),
      gross_income: this.getGrossIncome(
        this.state[fields.incomeFrequency.name],
        this.currencyToNumber(this.state[fields.baseIncome.name])
        )
    }
    return incomes;
  },

  getEmployments: function(borrower, fields) {
    var currentEmployment = borrower.current_employment;
    var previousEmployment = borrower.previous_employment;
    var employment = [{
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
      employment.push({
        id: previousEmployment ? previousEmployment.id : null,
        employer_name: this.state[fields.previousEmployerName.name],
        job_title: this.state[fields.previousJobTitle.name],
        duration: this.state[fields.previousYearsAtEmployer.name],
        monthly_income: this.currencyToNumber(this.state[fields.previousMonthlyIncome.name]),
        is_current: false
      })
    }
    return employment;
  },

  getOtherIncome: function(fields, type) {
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
  valid: function(){
    var state = {};
    var isValid = true;

    if(this.elementIsEmpty(this.state[borrowerFields.currentEmployerName.name])){
      state[borrowerFields.currentEmployerName.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[borrowerFields.currentEmployerFullTextAddress.name])){
      state[borrowerFields.currentEmployerFullTextAddress.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[borrowerFields.currentJobTitle.name])){
      state[borrowerFields.currentJobTitle.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[borrowerFields.currentYearsAtEmployer.name])){
      state[borrowerFields.currentYearsAtEmployer.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[borrowerFields.employerContactName.name])){
      state[borrowerFields.employerContactName.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[borrowerFields.employerContactNumber.name])){
      state[borrowerFields.employerContactNumber.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[borrowerFields.baseIncome.name])){
      state[borrowerFields.baseIncome.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[borrowerFields.incomeFrequency.name])){
      state[borrowerFields.incomeFrequency.error] = true;
      isValid = false;
    }

    if(!this.elementIsEmpty(this.state[borrowerFields.currentYearsAtEmployer.name]) && this.state[borrowerFields.currentYearsAtEmployer.name] < 2){
      if(this.elementIsEmpty(this.state[borrowerFields.previousEmployerName.name])){
        state[borrowerFields.previousEmployerName.error] = true;
        isValid = false;
      }

      if(this.elementIsEmpty(this.state[borrowerFields.previousJobTitle.name])){
        state[borrowerFields.previousJobTitle.error] = true;
        isValid = false;
      }

      if(this.elementIsEmpty(this.state[borrowerFields.previousYearsAtEmployer.name])){
        state[borrowerFields.previousYearsAtEmployer.error] = true;
        isValid = false;
      }

      if(this.elementIsEmpty(this.state[borrowerFields.previousMonthlyIncome.name])){
        state[borrowerFields.previousMonthlyIncome.error] = true;
        isValid = false;
      }
    }

    //secondary borrower
    if(this.elementIsEmpty(this.state[secondaryBorrowerFields.currentEmployerName.name])){
      state[secondaryBorrowerFields.currentEmployerName.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[secondaryBorrowerFields.currentEmployerFullTextAddress.name])){
      state[secondaryBorrowerFields.currentEmployerFullTextAddress.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[secondaryBorrowerFields.currentJobTitle.name])){
      state[secondaryBorrowerFields.currentJobTitle.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[secondaryBorrowerFields.currentYearsAtEmployer.name])){
      state[secondaryBorrowerFields.currentYearsAtEmployer.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[secondaryBorrowerFields.employerContactName.name])){
      state[secondaryBorrowerFields.employerContactName.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[secondaryBorrowerFields.employerContactNumber.name])){
      state[secondaryBorrowerFields.employerContactNumber.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[secondaryBorrowerFields.baseIncome.name])){
      state[secondaryBorrowerFields.baseIncome.error] = true;
      isValid = false;
    }

    if(this.elementIsEmpty(this.state[secondaryBorrowerFields.incomeFrequency.name])){
      state[secondaryBorrowerFields.incomeFrequency.error] = true;
      isValid = false;
    }

    if(!this.elementIsEmpty(this.state[secondaryBorrowerFields.currentYearsAtEmployer.name]) && this.state[secondaryBorrowerFields.currentYearsAtEmployer.name] < 2){
      if(this.elementIsEmpty(this.state[secondaryBorrowerFields.previousEmployerName.name])){
        state[secondaryBorrowerFields.previousEmployerName.error] = true;
        isValid = false;
      }

      if(this.elementIsEmpty(this.state[secondaryBorrowerFields.previousJobTitle.name])){
        state[secondaryBorrowerFields.previousJobTitle.error] = true;
        isValid = false;
      }

      if(this.elementIsEmpty(this.state[secondaryBorrowerFields.previousYearsAtEmployer.name])){
        state[secondaryBorrowerFields.previousYearsAtEmployer.error] = true;
        isValid = false;
      }

      if(this.elementIsEmpty(this.state[secondaryBorrowerFields.previousMonthlyIncome.name])){
        state[secondaryBorrowerFields.previousMonthlyIncome.error] = true;
        isValid = false;
      }
    }

    _.each(this.state[borrowerFields.otherIncomes.name], function(otherIncome){
      if(otherIncome.type === null){
        otherIncome.typeError = true;
      }
      if(otherIncome.amount === null){
        otherIncome.amountError = true;
      }
    });
    state[borrowerFields.otherIncomes.name] = this.state[borrowerFields.otherIncomes.name];

    _.each(this.state[secondaryBorrowerFields.otherIncomes.name], function(otherIncome){
      if(otherIncome.type === null){
        otherIncome.typeError = true;
      }
      if(otherIncome.amount === null){
        otherIncome.amountError = true;
      }
    });
    state[secondaryBorrowerFields.otherIncomes.name] = this.state[secondaryBorrowerFields.otherIncomes.name];

    // console.log(this.state[secondaryBorrowerFields.otherIncomes.name]);
    if(!isValid)
      this.setState(state);
    return isValid;
  },

  save: function(event) {
    if(this.valid() == false) {
      this.setState({activateError: true, saving: false});
      return false;
    }
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 3);
    event.preventDefault();
  }
});

module.exports = Form;