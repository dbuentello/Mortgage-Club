var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');
var FlashHandler = require('mixins/FlashHandler');

var ValidationObject = require("mixins/ValidationMixins");

var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/NewSelectField');
var TextField = require('components/form/TextField');
var BooleanRadio = require('components/form/NewBooleanRadio');
var CheckCompletedLoanMixin = require('mixins/CheckCompletedLoanMixin');
var Borrower = require('./Borrower');
var borrowerCountOptions = [
  {name: 'As an individual', value: 1},
  {name: 'With a co-borrower', value: 2}
];

var borrower_fields = {
  email: {label: 'Email', name: 'first_borrower_email', fieldName: 'email', helpText: null, error: "emailError"},
  applyingAs: {label: 'I am applying', name: 'first_borrower_apply_as', fieldName: 'apply_as', helpText: 'I am a helpful text.', error: "applyingAsError"},
  firstName: {label: 'First Name', name: 'first_borrower_first_name', fieldName: 'first_name', helpText: null, error: "firstNameError"},
  middleName: {label: 'Middle Name', name: 'first_borrower_middle_name', fieldName: 'middle_name', helpText: null},
  lastName: {label: 'Last Name', name: 'first_borrower_last_name', fieldName: 'last_name', helpText: null, error: "lastNameError"},
  suffix: {label: 'Suffix', name: 'first_borrower_suffix', fieldName: 'suffix', helpText: null},
  dob: {label: 'Date of Birth', name: 'first_borrower_dob', fieldName: 'dob', helpText: null, error: "dobError"},
  ssn: {label: 'Social Security Number', name: 'first_borrower_ssn', fieldName: 'ssn', helpText: null, error: "ssnError"},
  phone: {label: 'Phone Number', name: 'first_borrower_phone', fieldName: 'phone', helpText: null},
  yearsInSchool: {label: 'Years in School', name: 'first_borrower_years_in_school', fieldName: 'years_in_school', helpText: null, error: "yearsInSchoolError"},
  maritalStatus: {label: 'Marital Status', name: 'first_borrower_marital_status', fieldName: 'marital_status', helpText: 'Married (includes registered domestic partners), Unmarried (includes single, divorced, widowed)', error: "maritalStatusError"},
  numberOfDependents: {label: 'Number of dependents', name: 'first_borrower_dependent_count', fieldName: 'dependent_count', helpText: null, error: "numberOfDependencesError"},
  dependentAges: {label: 'Ages of Dependents', name: 'first_borrower_dependent_ages', fieldName: 'dependent_ages', helpText: null, error: "dependentAgesError"},
  currentAddress: {label: 'Your Current Address', name: 'first_borrower_current_address', fieldName: 'current_address', helpText: null, error: "currentAddressError"},
  currentlyOwn: {label: 'Own or rent?', name: 'first_borrower_currently_own', fieldName: 'currently_own', helpText: null, error: "currentlyOwnError"},
  selfEmployed: {label: 'Are you self-employed?', name: 'first_borrower_self_employed', fieldName: 'self_employed', helpText: null, error: "selfEmployedError"},
  yearsInCurrentAddress: {label: 'Number of years you have lived here', name: 'first_borrower_years_in_current_address', fieldName: 'years_in_current_address', helpText: null, error: "yearsInCurrentAddressError"},
  previousAddress: {label: 'Your previous address', name: 'first_borrower_previous_address', fieldName: 'previous_address', helpText: null, error: "previousAddressError"},
  previouslyOwn: {label: 'Do you own or rent?', name: 'first_borrower_previously_own', fieldName: 'previously_own', helpText: null, error: "previouslyOwnError"},
  yearsInPreviousAddress: {label: 'Number of years you have lived here', name: 'first_borrower_years_in_previous_address', fieldName: 'years_in_previous_address', helpText: null, error: "yearsInPreviousAddressError"},
  currentMonthlyRent: {label: 'Monthly Rent', name: 'first_borrower_current_monthly_rent', fieldName: 'current_monthly_rent', helpText: null, error: "currentMonthlyRentError"},
  previousMonthlyRent: {label: 'Monthly Rent', name: 'first_borrower_previous_monthly_rent', fieldName: 'previous_monthly_rent', helpText: null, error: "previousMonthlyRentError"}
};

var secondary_borrower_fields = {
  email: {label: 'Email', name: 'secondary_borrower_email', fieldName: 'email', helpText: null, error: "coEmailError"},
  firstName: {label: 'First Name', name: 'secondary_borrower_first_name', fieldName: 'first_name', helpText: null, error: "coFirstNameError" },
  middleName: {label: 'Middle Name', name: 'secondary_borrower_middle_name', fieldName: 'middle_name', helpText: null, error: null },
  lastName: {label: 'Last Name', name: 'secondary_borrower_last_name', fieldName: 'last_name', helpText: null, error: "coLastNameError" },
  suffix: {label: 'Suffix', name: 'secondary_borrower_suffix', fieldName: 'suffix', helpText: null, error: null },
  dob: {label: 'Date of Birth', name: 'secondary_borrower_dob', fieldName: 'dob', helpText: null, error: "coDobError"},
  ssn: {label: 'Social Security Number', name: 'secondary_borrower_ssn', fieldName: 'ssn', helpText: null, error: "coSsnError"},
  phone: {label: 'Phone Number', name: 'secondary_borrower_phone', fieldName: 'phone', helpText: null, error: null},
  yearsInSchool: {label: 'Years in School', name: 'secondary_borrower_years_in_school', fieldName: 'years_in_school', helpText: null, error: "coYearsInSchoolError" },
  maritalStatus: {label: 'Marital Status', name: 'secondary_borrower_marital_status', fieldName: 'marital_status', helpText: null, error: "coMarialStatusError"},
  numberOfDependents: {label: 'Number of dependents', name: 'secondary_borrower_dependent_count', fieldName: 'dependent_count', helpText: null, error: "coNumberOfdependencesError"},
  dependentAges: {label: 'Ages of Dependents', name: 'secondary_borrower_dependent_ages', fieldName: 'dependent_ages', helpText: null, error: null},
  currentAddress: {label: 'Your co-borrower current address', name: 'secondary_borrower_current_address', fieldName: 'current_address', helpText: null, error: "coCurrentAddressError"},
  currentlyOwn: {label: 'Own or rent?', name: 'secondary_borrower_currently_own', fieldName: 'currently_own', helpText: null, error: "coCurrentlyOwnError"},
  selfEmployed: {label: 'Is your co-borrower self-employed?', name: 'secondary_borrower_self_employed', fieldName: 'self_employed', helpText: null, error: "coSelfEmployError"},
  yearsInCurrentAddress: {label: 'Number of years your co-borrower has lived here', name: 'secondary_borrower_years_in_current_address', fieldName: 'years_in_current_address', helpText: null, error: "coYearsInCurrentAddressError"},
  previousAddress: {label: 'Your previous address', name: 'secondary_borrower_previous_address', fieldName: 'previous_address', helpText: null, error: "coPreviousAddressError"},
  previouslyOwn: {label: 'Do you own or rent?', name: 'secondary_borrower_previously_own', fieldName: 'previously_own', helpText: null, error: "coPreviousOwnError"},
  yearsInPreviousAddress: {label: 'Number of years your co-borrower has lived here', name: 'secondary_borrower_years_in_previous_address', fieldName: 'years_in_previous_address', helpText: null, error: "coYearsInPreviousAddressError"},
  currentMonthlyRent: {label: 'Monthly Rent', name: 'secondary_borrower_current_monthly_rent', fieldName: 'current_monthly_rent', helpText: null, error: "coCurrentlyMonthlyRentError"},
  previousMonthlyRent: {label: 'Monthly Rent', name: 'secondary_borrower_previous_monthly_rent', fieldName: 'previous_monthly_rent', helpText: null, error: "coPreviousMonthlyRentError"}
};

var Form = React.createClass({
  mixins: [TextFormatMixin, FlashHandler, ValidationObject],

  getInitialState: function() {
    var state = this.buildStateFromLoan(this.props.loan);
    state.activateError = false;
    state.isValid = true;
    return state;
  },

  componentDidUpdate: function(){
    if(!this.state.isValid)
      this.scrollTopError();
  },

  onChange: function(change) {
    this.setState(change);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  coBorrowerHanlder: function(change) {
    if (change.first_borrower_apply_as == "1") {
      this.setState({ hasSecondaryBorrower: false });
    } else {
      this.setState({ hasSecondaryBorrower: true });
    }

    this.setState(change);
  },

  render: function() {
    return (
      <div className="col-xs-9 account-content">
        <form className="form-horizontal">
          <div className="form-group">
            <div className="col-md-6">
              <SelectField
              label={borrower_fields.applyingAs.label}
              keyName={borrower_fields.applyingAs.name}
              value={this.state[borrower_fields.applyingAs.name]}
              options={borrowerCountOptions}
              editable={this.state.borrower_editable}
              onFocus={this.onFocus.bind(this, borrower_fields.applyingAs)}
              onChange={this.coBorrowerHanlder}/>
            </div>
          </div>
          <Borrower
            activateError={this.state.activateError}
            loan={this.props.loan}
            fields={borrower_fields}
            firstName={this.state[borrower_fields.firstName.name]}
            firstNameError={this.state[borrower_fields.firstName.error]}
            middleName={this.state[borrower_fields.middleName.name]}
            lastName={this.state[borrower_fields.lastName.name]}
            lastNameError={this.state[borrower_fields.lastName.error]}
            suffix={this.state[borrower_fields.suffix.name]}
            dob={this.state[borrower_fields.dob.name]}
            dobError={this.state[borrower_fields.dob.error]}
            ssn={this.state[borrower_fields.ssn.name]}
            ssnError={this.state[borrower_fields.ssn.error]}
            phone={this.state[borrower_fields.phone.name]}
            yearsInSchool={this.state[borrower_fields.yearsInSchool.name]}
            yearsInSchoolError={this.state[borrower_fields.yearsInSchool.error]}
            maritalStatus={this.state[borrower_fields.maritalStatus.name]}
            maritalStatusEror={this.state[borrower_fields.maritalStatus.error]}
            numberOfDependents={this.state[borrower_fields.numberOfDependents.name]}
            numberOfDependencesError={this.state[borrower_fields.numberOfDependents.error]}
            dependentAges={this.state[borrower_fields.dependentAges.name]}
            dependentAgesError={this.state[borrower_fields.dependentAges.error]}
            currentMonthlyRent={this.state[borrower_fields.currentMonthlyRent.name]}
            currentMonthlyRentError={this.state[borrower_fields.currentMonthlyRent.error]}
            yearsInCurrentAddress={this.state[borrower_fields.yearsInCurrentAddress.name]}
            yearsInCurrentAddressError={this.state[borrower_fields.yearsInCurrentAddress.error]}
            previousMonthlyRent={this.state[borrower_fields.previousMonthlyRent.name]}
            previousMonthlyRentError={this.state[borrower_fields.previousMonthlyRent.error]}
            yearsInPreviousAddress={this.state[borrower_fields.yearsInPreviousAddress.name]}
            yearsInPreviousAddressError={this.state[borrower_fields.yearsInPreviousAddress.error]}
            currentAddress={this.state[borrower_fields.currentAddress.name]}
            currentAddressError={this.state[borrower_fields.currentAddress.error]}
            previousAddress={this.state[borrower_fields.previousAddress.name]}
            previousAddressError={this.state[borrower_fields.previousAddress.error]}
            currentlyOwn={this.state[borrower_fields.currentlyOwn.name]}
            currentlyOwnError={this.state[borrower_fields.currentlyOwn.error]}
            previouslyOwn={this.state[borrower_fields.previouslyOwn.name]}
            previouslyOwnError={this.state[borrower_fields.previouslyOwn.error]}
            selfEmployed={this.state[borrower_fields.selfEmployed.name]}
            selfEmployedErorr={this.state[borrower_fields.selfEmployed.error]}
            onChange={this.onChange}
            onFocus={this.onFocus}/>

            { this.state.hasSecondaryBorrower ?
              <div className="box mtn">
                <hr/>
                <br/>
                <h3>Please provide information about your co-borrower</h3>
                <Borrower
                  activateError={this.state.activateError}
                  loan={this.props.loan}
                  fields={secondary_borrower_fields}
                  firstName={this.state[secondary_borrower_fields.firstName.name]}
                  firstNameError={this.state[secondary_borrower_fields.firstName.error]}
                  middleName={this.state[secondary_borrower_fields.middleName.name]}
                  lastName={this.state[secondary_borrower_fields.lastName.name]}
                  lastNameError={this.state[secondary_borrower_fields.lastName.error]}
                  suffix={this.state[secondary_borrower_fields.suffix.name]}
                  dob={this.state[secondary_borrower_fields.dob.name]}
                  dobError={this.state[secondary_borrower_fields.dob.error]}
                  ssn={this.state[secondary_borrower_fields.ssn.name]}
                  ssnError={this.state[secondary_borrower_fields.ssn.error]}
                  phone={this.state[secondary_borrower_fields.phone.name]}
                  email={this.state[secondary_borrower_fields.email.name]}
                  emailError={this.state[secondary_borrower_fields.email.error]}
                  yearsInSchool={this.state[secondary_borrower_fields.yearsInSchool.name]}
                  yearsInSchoolError={this.state[secondary_borrower_fields.yearsInSchool.error]}
                  maritalStatus={this.state[secondary_borrower_fields.maritalStatus.name]}
                  maritalStatusError={this.state[secondary_borrower_fields.maritalStatus.error]}
                  numberOfDependents={this.state[secondary_borrower_fields.numberOfDependents.name]}
                  numberOfDependencesError={this.state[secondary_borrower_fields.numberOfDependents.error]}
                  dependentAges={this.state[secondary_borrower_fields.dependentAges.name]}
                  dependentAgesError={this.state[secondary_borrower_fields.dependentAges.error]}
                  currentMonthlyRent={this.state[secondary_borrower_fields.currentMonthlyRent.name]}
                  currentMonthlyRentError={this.state[secondary_borrower_fields.currentMonthlyRent.error]}
                  yearsInCurrentAddress={this.state[secondary_borrower_fields.yearsInCurrentAddress.name]}
                  yearsInCurrentAddressError={this.state[secondary_borrower_fields.yearsInCurrentAddress.error]}
                  previousMonthlyRent={this.state[secondary_borrower_fields.previousMonthlyRent.name]}
                  previousMonthlyRentError={this.state[secondary_borrower_fields.previousMonthlyRent.error]}
                  yearsInPreviousAddress={this.state[secondary_borrower_fields.yearsInPreviousAddress.name]}
                  yearsInPreviousAddressError={this.state[secondary_borrower_fields.yearsInPreviousAddress.error]}
                  currentAddress={this.state[secondary_borrower_fields.currentAddress.name]}
                  currentAddressError={this.state[secondary_borrower_fields.currentAddress.error]}
                  previousAddress={this.state[secondary_borrower_fields.previousAddress.name]}
                  previousAddressError={this.state[secondary_borrower_fields.previousAddress.error]}
                  currentlyOwn={this.state[secondary_borrower_fields.currentlyOwn.name]}
                  currentlyOwnError={this.state[secondary_borrower_fields.currentlyOwn.error]}
                  previouslyOwn={this.state[secondary_borrower_fields.previouslyOwn.name]}
                  previouslyOwnError={this.state[secondary_borrower_fields.previouslyOwn.error]}
                  selfEmployed={this.state[secondary_borrower_fields.selfEmployed.name]}
                  selfEmployedError={this.state[secondary_borrower_fields.selfEmployed.error]}
                  isSecondary={true}
                  onChange={this.onChange}
                  onFocus={this.onFocus}/>
              </div>
            : null }
            <div className="form-group">
              <div className="col-md-12">
                <button type="submit" className="btn theBtn text-uppercase" id="continueBtn" onClick={this.save}>{ this.state.saving ? 'Saving' : 'Save and Continue' }<img src="/icons/arrowRight.png" alt="arrow"/></button>
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
    var borrower = loan.borrower;
    var first_borrower_user = borrower.user;

    // For now just make them all editable
    state['borrower_editable'] = true;
    state['secondary_borrower_editable'] = true;

    var secondary_borrower = loan.secondary_borrower;

    switch(this.props.borrower_type) {
    case "borrower":
      // state['borrower_editable'] = true;

      if (secondary_borrower) {
        state[borrower_fields.applyingAs.name] = 2;
        state['hasSecondaryBorrower'] = true;
        // state['secondary_borrower_editable'] = false;
        // build state for secondary borrower
        state = this.buildStateFromBorrower(state, secondary_borrower, secondary_borrower.user, secondary_borrower_fields);
      } else {
        state[borrower_fields.applyingAs.name] = 1;
        state['hasSecondaryBorrower'] = false;
        // state['secondary_borrower_editable'] = true;
      };
      break;

    case "secondary_borrower":
      state[borrower_fields.applyingAs.name] = 2;
      state['hasSecondaryBorrower'] = true;
      // state['borrower_editable'] = false;
      // state['secondary_borrower_editable'] = true;

      if (secondary_borrower) {
        // build state for secondary borrower
        state = this.buildStateFromBorrower(state, secondary_borrower, secondary_borrower.user, secondary_borrower_fields);
      }
      break;

    default:
      console.log('cannot find proper case for borrower_type');
    };

    // build state for borrower
    state = this.buildStateFromBorrower(state, borrower, first_borrower_user, borrower_fields);

    return state;
  },

  buildStateFromBorrower: function(state, borrower, borrower_user, fields) {
    state[fields.email.name] = borrower_user[fields.email.fieldName];
    state[fields.firstName.name] = borrower[fields.firstName.fieldName];
    state[fields.middleName.name] = borrower[fields.middleName.fieldName];
    state[fields.lastName.name] = borrower[fields.lastName.fieldName];
    state[fields.suffix.name] = borrower[fields.suffix.fieldName];
    state[fields.dob.name] = borrower[fields.dob.fieldName];
    state[fields.ssn.name] = borrower[fields.ssn.fieldName];
    state[fields.phone.name] = borrower[fields.phone.fieldName];
    state[fields.yearsInSchool.name] = borrower[fields.yearsInSchool.fieldName];
    state[fields.maritalStatus.name] = borrower[fields.maritalStatus.fieldName];
    state[fields.numberOfDependents.name] = borrower[fields.numberOfDependents.fieldName];
    state[fields.dependentAges.name] = borrower[fields.dependentAges.fieldName].join(', ');
    state[fields.selfEmployed.name] = borrower[fields.selfEmployed.fieldName];

    var currentBorrowerAddress = borrower[fields.currentAddress.fieldName];
    if (currentBorrowerAddress) {
      state[fields.currentAddress.name] = currentBorrowerAddress.cached_address;
      state[fields.yearsInCurrentAddress.name] = currentBorrowerAddress.years_at_address;
      state[fields.currentlyOwn.name] = !currentBorrowerAddress.is_rental;
      if (currentBorrowerAddress.is_rental) {
        state[fields.currentMonthlyRent.name] = this.formatCurrency(currentBorrowerAddress.monthly_rent);
      }
    };

    var previousBorrowerAddress = borrower[fields.previousAddress.fieldName];
    if (previousBorrowerAddress) {
      state[fields.previousAddress.name] = previousBorrowerAddress.cached_address;
      state[fields.previouslyOwn.name] = !previousBorrowerAddress.is_rental;
      state[fields.yearsInPreviousAddress.name] = previousBorrowerAddress.years_at_address;
      if (previousBorrowerAddress.is_rental) {
        state[fields.previousMonthlyRent.name] = this.formatCurrency(previousBorrowerAddress.monthly_rent);
      }
    };

    return state;
  },

  valid: function() {
    var isValid = true;
    var state = {};
    var borrowerOutputFields = [
      borrower_fields.email.error,
      borrower_fields.firstName.error,
      borrower_fields.lastName.error,
      borrower_fields.dob.error,
      borrower_fields.ssn.error,
      borrower_fields.yearsInSchool.error,
      borrower_fields.currentlyOwn.error,
      borrower_fields.currentAddress.error,
      borrower_fields.yearsInCurrentAddress.error,
      borrower_fields.selfEmployed.error,
      borrower_fields.maritalStatus.error,
      borrower_fields.numberOfDependents.error,
      borrower_fields.selfEmployed.error
    ];
    var stateArray = [
      this.state[borrower_fields.email.name],
      this.state[borrower_fields.firstName.name],
      this.state[borrower_fields.lastName.name],
      this.state[borrower_fields.dob.name],
      this.state[borrower_fields.ssn.name],
      this.state[borrower_fields.yearsInSchool.name],
      this.state[borrower_fields.currentlyOwn.name],
      this.state[borrower_fields.currentAddress.name],
      this.state[borrower_fields.yearsInCurrentAddress.name],
      this.state[borrower_fields.selfEmployed.name],
      this.state[borrower_fields.maritalStatus.name],
      this.state[borrower_fields.numberOfDependents.name],
      this.state[borrower_fields.selfEmployed.name]
    ];
    var validationResult = this.requiredFieldsHasEmptyElement(stateArray, borrowerOutputFields);
    if (validationResult.hasEmptyElement == true){
      this.setState(validationResult.state);
      isValid = false;
    }
    if(this.state[borrower_fields.currentlyOwn.name]==false){
        if(this.elementIsEmpty(this.state[borrower_fields.currentMonthlyRent.name])){
          state[borrower_fields.currentMonthlyRent.error] = true;
          isValid = false;
        }
    }
    if(this.state[borrower_fields.applyingAs.name] == 2){
        var coBorrowerOutputFields = [
        secondary_borrower_fields.email.error,
        secondary_borrower_fields.firstName.error,
        secondary_borrower_fields.lastName.error,
        secondary_borrower_fields.dob.error,
        secondary_borrower_fields.ssn.error,
        secondary_borrower_fields.yearsInSchool.error,
        secondary_borrower_fields.currentlyOwn.error,
        secondary_borrower_fields.currentAddress.error,
        secondary_borrower_fields.yearsInCurrentAddress.error,
        secondary_borrower_fields.selfEmployed.error,
        secondary_borrower_fields.maritalStatus.error,
        secondary_borrower_fields.numberOfDependents.error
      ];
      var coStateArray = [
        this.state[secondary_borrower_fields.email.name],
        this.state[secondary_borrower_fields.firstName.name],
        this.state[secondary_borrower_fields.lastName.name],
        this.state[secondary_borrower_fields.dob.name],
        this.state[secondary_borrower_fields.ssn.name],
        this.state[secondary_borrower_fields.yearsInSchool.name],
        this.state[secondary_borrower_fields.currentlyOwn.name],
        this.state[secondary_borrower_fields.currentAddress.name],
        this.state[secondary_borrower_fields.yearsInCurrentAddress.name],
        this.state[secondary_borrower_fields.selfEmployed.name],
        this.state[secondary_borrower_fields.maritalStatus.name],
        this.state[secondary_borrower_fields.numberOfDependents.name]
      ];
      validationResult = this.requiredFieldsHasEmptyElement(coStateArray, coBorrowerOutputFields);
      if (validationResult.hasEmptyElement == true){
        this.setState(validationResult.state);
        isValid = false;
      }
      if(this.state[secondary_borrower_fields.currentlyOwn.name]==false){
          if(this.elementIsEmpty(this.state[secondary_borrower_fields.currentMonthlyRent.name])){
            state[secondary_borrower_fields.currentMonthlyRent.error] = true;
            isValid = false;
          }
      }
      if(this.state[secondary_borrower_fields.yearsInCurrentAddress.name] < 2){
        if(this.elementIsEmpty(this.state[secondary_borrower_fields.previousAddress.name])){
          state[secondary_borrower_fields.previousAddress.error] = true;
          isValid = false;
        }
        if(this.elementIsEmpty(this.state[secondary_borrower_fields.yearsInPreviousAddress.name])){
          state[secondary_borrower_fields.yearsInPreviousAddress.error] = true;
          isValid = false;
        }
        if(this.elementIsEmpty(this.state[secondary_borrower_fields.previouslyOwn.name])){
          state[secondary_borrower_fields.previouslyOwn.error] = true;
          isValid = false;
        }else {
          if(this.elementIsEmpty(this.state[secondary_borrower_fields.yearsInPreviousAddress.name])){
            state[secondary_borrower_fields.yearsInPreviousAddress.error] = true;
            isValid = false;
          }
        }
        if(this.state[secondary_borrower_fields.previouslyOwn.name] ==false){
          if(this.elementIsEmpty(this.state[secondary_borrower_fields.previousMonthlyRent.name])){
            state[secondary_borrower_fields.previousMonthlyRent.error] = true;
            isValid = false;
          }
        }
      }

    }
    if(this.state[borrower_fields.yearsInCurrentAddress.name] < 2){
      if(this.elementIsEmpty(this.state[borrower_fields.previousAddress.name])){
        state[borrower_fields.previousAddress.error] = true;
        isValid = false;
      }
      if(this.elementIsEmpty(this.state[borrower_fields.yearsInPreviousAddress.name])){
        state[borrower_fields.yearsInPreviousAddress.error] = true;
        isValid = false;
      }
      if(this.elementIsEmpty(this.state[borrower_fields.previouslyOwn.name])){
        state[borrower_fields.previouslyOwn.error] = true;
        isValid = false;
      }else {
        if(this.elementIsEmpty(this.state[borrower_fields.yearsInPreviousAddress.name])){
          state[borrower_fields.yearsInPreviousAddress.error] = true;
          isValid = false;
        }
      }
      if(this.state[borrower_fields.previouslyOwn.name]==false){
        if(this.elementIsEmpty(this.state[borrower_fields.previousMonthlyRent.name])){
          state[borrower_fields.previousMonthlyRent.error] = true;
          isValid = false;
        }
      }

    }


    if(isValid==false){
      state.saving =false;
    }
    this.setState(state);

    return isValid;
  },

  scrollTopError: function(){
    var offset = $(".tooltip").first().parents(".form-group").offset();
    var top = offset === undefined ? 0 : offset.top;
    $('html, body').animate({scrollTop: top}, 1000);
    this.setState({isValid: true});
  },

  save: function(event) {
    if (this.valid() == false) {
      this.setState({activateError: true, saving: false, isValid: false})
      return false;
    }

    this.setState({saving: true, isValid: true});
    $.ajax({
      url: '/borrowers/' + this.props.loan.borrower.id,
      method: 'PATCH',
      context: this,
      dataType: 'json',
      data: {
        borrower: {
          current_borrower_address_id: this.getCurrentBorrowerAddressID(this.props.loan.borrower),
          current_address: this.getCurrentAddress(borrower_fields),
          previous_address: this.getPreviousAddress(borrower_fields),
          current_borrower_address: this.getCurrentBorrowerAddress(borrower_fields),
          previous_borrower_address: this.getPreviousBorrowerAddress(borrower_fields),
          borrower: this.getBorrower(borrower_fields)
        },
        secondary_borrower: {
          current_borrower_address_id: this.getCurrentBorrowerAddressID(this.props.loan.secondary_borrower),
          current_address: this.getCurrentAddress(secondary_borrower_fields),
          previous_address: this.getPreviousAddress(secondary_borrower_fields),
          current_borrower_address: this.getCurrentBorrowerAddress(secondary_borrower_fields),
          previous_borrower_address: this.getPreviousBorrowerAddress(secondary_borrower_fields),
          borrower: this.getBorrower(secondary_borrower_fields),
        },
        remove_secondary_borrower: !this.state.hasSecondaryBorrower,
        has_secondary_borrower: this.state.hasSecondaryBorrower,
        loan_id: this.props.loan.id,
      },
      success: function(response) {
        if (this.loanIsCompleted(response.loan)) {
          this.props.goToAllDonePage();
        }
        else {
          this.props.setupMenu(response, 1);
        }
      },
      error: function(response, status, error) {
        alert(error);
        this.setState({saving: false});
      }
    });

    event.preventDefault();
  },

  getCurrentAddress: function(fields) {
    return this.state[fields.currentAddress.name] ? this.state[fields.currentAddress.name] : {no_data: true};
  },

  getPreviousAddress: function(fields) {
    return this.state[fields.previousAddress.name] ? this.state[fields.previousAddress.name] : {no_data: true};
  },

  getCurrentBorrowerAddress: function(fields) {
    return {
      is_rental: !this.state[fields.currentlyOwn.name],
      years_at_address: this.state[fields.yearsInCurrentAddress.name],
      monthly_rent: this.currencyToNumber(this.state[fields.currentMonthlyRent.name]),
      is_current: true
    };
  },

  getPreviousBorrowerAddress: function(fields) {
    return {
      is_rental: !this.state[fields.previouslyOwn.name],
      years_at_address: this.state[fields.yearsInPreviousAddress.name],
      monthly_rent: this.currencyToNumber(this.state[fields.previousMonthlyRent.name]),
      is_current: false
    };
  },

  getCurrentBorrowerAddressID: function(borrower) {
    if (borrower && borrower.current_address) {
      return borrower.current_address.id;
    };
  },

  getBorrower: function(fields) {
    var dependentAges;
    var borrower = {};
    if ( this.state[fields.numberOfDependents.name] > 0 ) {
      dependentAges = _.map(this.state[fields.dependentAges.name].split(','), _.trim);
    };

    borrower[fields.email.fieldName] = this.state[fields.email.name];
    borrower[fields.firstName.fieldName] = this.state[fields.firstName.name];
    borrower[fields.middleName.fieldName] = this.state[fields.middleName.name];
    borrower[fields.lastName.fieldName] = this.state[fields.lastName.name];
    borrower[fields.suffix.fieldName] = this.state[fields.suffix.name];
    borrower[fields.dob.fieldName] = this.state[fields.dob.name];
    borrower[fields.ssn.fieldName] = this.state[fields.ssn.name];
    borrower[fields.phone.fieldName] = this.state[fields.phone.name];
    borrower[fields.yearsInSchool.fieldName] = this.state[fields.yearsInSchool.name];
    borrower[fields.maritalStatus.fieldName] = this.state[fields.maritalStatus.name];
    borrower[fields.numberOfDependents.fieldName] = this.state[fields.numberOfDependents.name];
    if (!this.state[fields.numberOfDependents.name]) {
      borrower[fields.numberOfDependents.fieldName] = 0;
    }
    borrower[fields.dependentAges.fieldName] = dependentAges;
    borrower[fields.selfEmployed.fieldName] = this.state[fields.selfEmployed.name];
    return borrower;
  }
});

module.exports = Form;