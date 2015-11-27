var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');
var FlashHandler = require('mixins/FlashHandler');

var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var BooleanRadio = require('components/form/BooleanRadio')

var borrower_fields = {
  email: {label: 'Email', name: 'first_borrower_email', fieldName: 'email', helpText: null},
  applyingAs: {label: 'I am applying', name: 'first_borrower_apply_as', fieldName: 'apply_as', helpText: 'I am a helpful text.'},
  firstName: {label: 'First Name', name: 'first_borrower_first_name', fieldName: 'first_name', helpText: null},
  middleName: {label: 'Middle Name', name: 'first_borrower_middle_name', fieldName: 'middle_name', helpText: null},
  lastName: {label: 'Last Name', name: 'first_borrower_last_name', fieldName: 'last_name', helpText: null},
  suffix: {label: 'Suffix', name: 'first_borrower_suffix', fieldName: 'suffix', helpText: null},
  dob: {label: 'Date of Birth', name: 'first_borrower_dob', fieldName: 'dob', helpText: null},
  ssn: {label: 'Social Security Number', name: 'first_borrower_ssn', fieldName: 'ssn', helpText: null},
  phone: {label: 'Phone Number', name: 'first_borrower_phone', fieldName: 'phone', helpText: null},
  yearsInSchool: {label: 'Years in School', name: 'first_borrower_years_in_school', fieldName: 'years_in_school', helpText: null},
  maritalStatus: {label: 'Marital Status', name: 'first_borrower_marital_status', fieldName: 'marital_status', helpText: 'Married (includes registered domestic partners), Unmarried (includes single, divorced, widowed)'},
  numberOfDependents: {label: 'Number of dependents', name: 'first_borrower_dependent_count', fieldName: 'dependent_count', helpText: null},
  dependentAges: {label: 'Ages of Dependents', name: 'first_borrower_dependent_ages', fieldName: 'dependent_ages', helpText: null},
  currentAddress: {label: 'Your Current Address', name: 'first_borrower_current_address', fieldName: 'current_address', helpText: null},
  currentlyOwn: {label: 'Own or rent?', name: 'first_borrower_currently_own', fieldName: 'currently_own', helpText: null},
  selfEmployed: {label: 'Are you self-employed?', name: 'first_borrower_self_employed', fieldName: 'self_employed', helpText: null},
  yearsInCurrentAddress: {label: 'Number of years you have lived in this address', name: 'first_borrower_years_in_current_address', fieldName: 'years_in_current_address', helpText: null},
  previousAddress: {label: 'Your previous address', name: 'first_borrower_previous_address', fieldName: 'previous_address', helpText: null},
  previouslyOwn: {label: 'Do you own or rent?', name: 'first_borrower_previously_own', fieldName: 'previously_own', helpText: null},
  yearsInPreviousAddress: {label: 'Number of years you have lived in this address', name: 'first_borrower_years_in_previous_address', fieldName: 'years_in_previous_address', helpText: null},
  currentMonthlyRent: {label: 'Monthly Rent', name: 'first_borrower_current_monthly_rent', fieldName: 'current_monthly_rent', helpText: null},
  previousMonthlyRent: {label: 'Monthly Rent', name: 'first_borrower_previous_monthly_rent', fieldName: 'previous_monthly_rent', helpText: null}
};

var secondary_borrower_fields = {
  email: {label: 'Email', name: 'secondary_borrower_email', fieldName: 'email', helpText: null},
  firstName: {label: 'First Name', name: 'secondary_borrower_first_name', fieldName: 'first_name', helpText: null},
  middleName: {label: 'Middle Name', name: 'secondary_borrower_middle_name', fieldName: 'middle_name', helpText: null},
  lastName: {label: 'Last Name', name: 'secondary_borrower_last_name', fieldName: 'last_name', helpText: null},
  suffix: {label: 'Suffix', name: 'secondary_borrower_suffix', fieldName: 'suffix', helpText: null},
  dob: {label: 'Date of Birth', name: 'secondary_borrower_dob', fieldName: 'dob', helpText: null},
  ssn: {label: 'Social Security Number', name: 'secondary_borrower_ssn', fieldName: 'ssn', helpText: null},
  phone: {label: 'Phone Number', name: 'secondary_borrower_phone', fieldName: 'phone', helpText: null},
  yearsInSchool: {label: 'Years in School', name: 'secondary_borrower_years_in_school', fieldName: 'years_in_school', helpText: null},
  maritalStatus: {label: 'Marital Status', name: 'secondary_borrower_marital_status', fieldName: 'marital_status', helpText: null},
  numberOfDependents: {label: 'Number of dependents', name: 'secondary_borrower_dependent_count', fieldName: 'dependent_count', helpText: null},
  dependentAges: {label: 'Ages of Dependents', name: 'secondary_borrower_dependent_ages', fieldName: 'dependent_ages', helpText: null},
  currentAddress: {label: 'Your co-borrower current address', name: 'secondary_borrower_current_address', fieldName: 'current_address', helpText: null},
  currentlyOwn: {label: 'Own or rent?', name: 'secondary_borrower_currently_own', fieldName: 'currently_own', helpText: null},
  selfEmployed: {label: 'Is your co-borrower self-employed?', name: 'secondary_borrower_self_employed', fieldName: 'self_employed', helpText: null},
  yearsInCurrentAddress: {label: 'Number of years your co-borrower has lived in this address', name: 'secondary_borrower_years_in_current_address', fieldName: 'years_in_current_address', helpText: null},
  previousAddress: {label: 'Your previous address', name: 'secondary_borrower_previous_address', fieldName: 'previous_address', helpText: null},
  previouslyOwn: {label: 'Do you own or rent?', name: 'secondary_borrower_previously_own', fieldName: 'previously_own', helpText: null},
  yearsInPreviousAddress: {label: 'Number of years your co-borrower has lived in this address', name: 'secondary_borrower_years_in_previous_address', fieldName: 'years_in_previous_address', helpText: null},
  currentMonthlyRent: {label: 'Monthly Rent', name: 'secondary_borrower_current_monthly_rent', fieldName: 'current_monthly_rent', helpText: null},
  previousMonthlyRent: {label: 'Monthly Rent', name: 'secondary_borrower_previous_monthly_rent', fieldName: 'previous_monthly_rent', helpText: null}
};

var borrowerCountOptions = [
  {name: 'As an individual', value: 1},
  {name: 'With a co-borrower', value: 2}
];

var maritalStatuses = [
  {name: 'Married', value: 'married'},
  {name: 'Unmarried', value: 'unmarried'},
  {name: 'Separated', value: 'separated'}
];

var FormBorrower = React.createClass({
  mixins: [TextFormatMixin, FlashHandler],

  getInitialState: function() {
    var state = this.buildStateFromLoan(this.props.loan);

    return state;
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

  onCoBorrowerChange: function(event) {
    // var shouldAutoComplete = (this.props.borrower_type == "borrower") &&
    //   (this.state[secondary_borrower_fields.email.name] != null) &&
    //   (this.state[secondary_borrower_fields.dob.name] != null) &&
    //   (this.state[secondary_borrower_fields.ssn.name] != null);

    // if (shouldAutoComplete) {
    //   $.ajax({
    //     url: '/loans/get_secondary_borrower_info',
    //     method: 'GET',
    //     data: {
    //       email: this.state[secondary_borrower_fields.email.name],
    //       dob: this.state[secondary_borrower_fields.dob.name],
    //       ssn: this.state[secondary_borrower_fields.ssn.name]
    //     },
    //     dataType: 'json',
    //     success: function(response) {
    //       var change = {};
    //       if (response.secondary_borrower) {
    //         change = this.buildStateFromBorrower(change, response.secondary_borrower, response.secondary_borrower.user, secondary_borrower_fields);
    //       } else {
    //         _.map(secondary_borrower_fields, function (field, index) {
    //           if (field.name == 'secondary_borrower_email' || field.name == 'secondary_borrower_dob' || field.name == 'secondary_borrower_ssn') { return; }
    //           change[field.name] = null;
    //         });
    //       };
    //       this.setState(change);

    //       // state['secondary_borrower_editable'] = false;
    //     }.bind(this),
    //     error: function(response, status, error) {
    //       alert(error);
    //     }
    //   })
    // };
  },

  render: function() {
    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mtn'>
              <div className='row'>
                <div className='col-xs-6'>
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
              <div className='row'>
                <div className='col-xs-3'>
                  <TextField
                    label={borrower_fields.firstName.label}
                    keyName={borrower_fields.firstName.name}
                    value={this.state[borrower_fields.firstName.name]}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, borrower_fields.firstName)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-3'>
                  <TextField
                    label={borrower_fields.middleName.label}
                    keyName={borrower_fields.middleName.name}
                    value={this.state[borrower_fields.middleName.name]}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, borrower_fields.middleName)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-3'>
                  <TextField
                    label={borrower_fields.lastName.label}
                    keyName={borrower_fields.lastName.name}
                    value={this.state[borrower_fields.lastName.name]}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, borrower_fields.lastName)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-3'>
                  <TextField
                    label={borrower_fields.suffix.label}
                    keyName={borrower_fields.suffix.name}
                    value={this.state[borrower_fields.suffix.name]}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, borrower_fields.suffix)}
                    onChange={this.onChange}/>
                </div>
              </div>
              <div className='row'>
                <div className='col-xs-3'>
                  <DateField
                    label={borrower_fields.dob.label}
                    keyName={borrower_fields.dob.name}
                    value={this.state[borrower_fields.dob.name]}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, borrower_fields.dob)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-3'>
                  <TextField
                    label={borrower_fields.ssn.label}
                    keyName={borrower_fields.ssn.name}
                    value={this.state[borrower_fields.ssn.name]}
                    editable={this.state.borrower_editable}
                    format={this.formatSSN}
                    liveFormat={true}
                    onFocus={this.onFocus.bind(this, borrower_fields.ssn)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-3'>
                  <TextField
                    label={borrower_fields.phone.label}
                    keyName={borrower_fields.phone.name}
                    value={this.state[borrower_fields.phone.name]}
                    editable={this.state.borrower_editable}
                    liveFormat={true}
                    format={this.formatPhoneNumber}
                    onFocus={this.onFocus.bind(this, borrower_fields.phone)}
                    onChange={this.onChange}/>
                </div>
              </div>
              <div className='row'>
                <div className='col-xs-3'>
                  <TextField
                    label={borrower_fields.yearsInSchool.label}
                    keyName={borrower_fields.yearsInSchool.name}
                    value={this.state[borrower_fields.yearsInSchool.name]}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, borrower_fields.yearsInSchool)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-3'>
                  <SelectField
                    label={borrower_fields.maritalStatus.label}
                    keyName={borrower_fields.maritalStatus.name}
                    value={this.state[borrower_fields.maritalStatus.name]}
                    options={maritalStatuses}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, borrower_fields.maritalStatus)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-3'>
                  <TextField
                    label={borrower_fields.numberOfDependents.label}
                    keyName={borrower_fields.numberOfDependents.name}
                    value={this.state[borrower_fields.numberOfDependents.name]}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, borrower_fields.numberOfDependents)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-3'>
                  { parseInt(this.state[borrower_fields.numberOfDependents.name], 10) > 0 ?
                    <TextField
                      label={borrower_fields.dependentAges.label}
                      keyName={borrower_fields.dependentAges.name}
                      value={this.state[borrower_fields.dependentAges.name]}
                      editable={this.state.borrower_editable}
                      placeholder='e.g. 12, 7, 3'
                      onFocus={this.onFocus.bind(this, borrower_fields.dependentAges)}
                      onChange={this.onChange}/>
                  : null }
                </div>
              </div>
              <AddressField
                label={borrower_fields.currentAddress.label}
                address={this.state[borrower_fields.currentAddress.name]}
                keyName={borrower_fields.currentAddress.name}
                editable={this.state.borrower_editable}
                onFocus={this.onFocus.bind(this, borrower_fields.currentAddress)}
                onChange={this.onChange}
                placeholder=''/>
              <div className='row'>
                <div className='col-xs-3'>
                  <BooleanRadio
                    label={borrower_fields.currentlyOwn.label}
                    checked={this.state[borrower_fields.currentlyOwn.name]}
                    keyName={borrower_fields.currentlyOwn.name}
                    yesLabel={"Own"}
                    noLabel={"Rent"}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, borrower_fields.currentlyOwn)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-3'>
                  { this.state[borrower_fields.currentlyOwn.name] ? null
                    :
                      <TextField
                        label={borrower_fields.currentMonthlyRent.label}
                        value={this.state[borrower_fields.currentMonthlyRent.name]}
                        keyName={borrower_fields.currentMonthlyRent.name}
                        editable={this.state.borrower_editable}
                        liveFormat={true}
                        format={this.formatCurrency}
                        onFocus={this.onFocus.bind(this, borrower_fields.currentMonthlyRent)}
                        onChange={this.onChange}/>
                  }
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={borrower_fields.yearsInCurrentAddress.label}
                    value={this.state[borrower_fields.yearsInCurrentAddress.name]}
                    keyName={borrower_fields.yearsInCurrentAddress.name}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, borrower_fields.yearsInCurrentAddress)}
                    onChange={this.onChange}/>
                </div>
              </div>
              { parseInt(this.state[borrower_fields.yearsInCurrentAddress.name], 10) < 2 ?
                <div>
                  <AddressField
                    label={borrower_fields.previousAddress.label}
                    address={this.state[borrower_fields.previousAddress.name]}
                    keyName={borrower_fields.previousAddress.name}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, borrower_fields.previousAddress)}
                    onChange={this.onChange}
                    placeholder=''/>
                  <div className='row'>
                    <div className='col-xs-3'>
                      <BooleanRadio
                        label={borrower_fields.previouslyOwn.label}
                        checked={this.state[borrower_fields.previouslyOwn.name]}
                        keyName={borrower_fields.previouslyOwn.name}
                        yesLabel={"Own"}
                        noLabel={"Rent"}
                        editable={this.state.borrower_editable}
                        onFocus={this.onFocus.bind(this, borrower_fields.previouslyOwn)}
                        onChange={this.onChange}/>
                    </div>
                    <div className='col-xs-3'>
                      { this.state[borrower_fields.previouslyOwn.name] ? null
                        :
                          <TextField
                            label={borrower_fields.previousMonthlyRent.label}
                            value={this.state[borrower_fields.previousMonthlyRent.name]}
                            keyName={borrower_fields.previousMonthlyRent.name}
                            editable={this.state.borrower_editable}
                            liveFormat={true}
                            format={this.formatCurrency}
                            onFocus={this.onFocus.bind(this, borrower_fields.previousMonthlyRent)}
                            onChange={this.onChange}/>
                      }
                    </div>
                    <div className='col-xs-6'>
                      <TextField
                        label={borrower_fields.yearsInPreviousAddress.label}
                        value={this.state[borrower_fields.yearsInPreviousAddress.name]}
                        keyName={borrower_fields.yearsInPreviousAddress.name}
                        editable={this.state.borrower_editable}
                        onFocus={this.onFocus.bind(this, borrower_fields.yearsInPreviousAddress)}
                        onChange={this.onChange}/>
                    </div>
                  </div>
                </div>
              : null }
              <div className='row'>
                <div className='col-xs-12'>
                  <BooleanRadio
                    label={borrower_fields.selfEmployed.label}
                    checked={this.state[borrower_fields.selfEmployed.name]}
                    keyName={borrower_fields.selfEmployed.name}
                    yesLabel={"Yes"}
                    noLabel={"No"}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, borrower_fields.selfEmployed)}
                    onChange={this.onChange}/>
                </div>
              </div>
            </div>
            <hr/>
            { this.state.hasSecondaryBorrower ?
              <div className='box mtn'>
                <h5>Please provide information about your co-borrower</h5>
                <div className='row'>
                  <div className='col-xs-3'>
                    <TextField
                      label={secondary_borrower_fields.firstName.label}
                      keyName={secondary_borrower_fields.firstName.name}
                      value={this.state[secondary_borrower_fields.firstName.name]}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.firstName)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-3'>
                    <TextField
                      label={secondary_borrower_fields.middleName.label}
                      keyName={secondary_borrower_fields.middleName.name}
                      value={this.state[secondary_borrower_fields.middleName.name]}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.middleName)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-3'>
                    <TextField
                      label={secondary_borrower_fields.lastName.label}
                      keyName={secondary_borrower_fields.lastName.name}
                      value={this.state[secondary_borrower_fields.lastName.name]}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.lastName)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-3'>
                    <TextField
                      label={secondary_borrower_fields.suffix.label}
                      keyName={secondary_borrower_fields.suffix.name}
                      value={this.state[secondary_borrower_fields.suffix.name]}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.suffix)}
                      onChange={this.onChange}/>
                  </div>
                </div>
                <div className='row'>
                  <div className='col-xs-3'>
                    <DateField
                      label={secondary_borrower_fields.dob.label}
                      keyName={secondary_borrower_fields.dob.name}
                      value={this.state[secondary_borrower_fields.dob.name]}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.dob)}
                      onChange={this.onChange}
                      onBlur={this.onCoBorrowerChange}/>
                  </div>
                  <div className='col-xs-3'>
                    <TextField
                      label={secondary_borrower_fields.ssn.label}
                      keyName={secondary_borrower_fields.ssn.name}
                      value={this.state[secondary_borrower_fields.ssn.name]}
                      editable={this.state.secondary_borrower_editable}
                      format={this.formatSSN}
                      liveFormat={true}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.ssn)}
                      onChange={this.onChange}
                      onBlur={this.onCoBorrowerChange}/>
                  </div>
                  <div className='col-xs-3'>
                    <TextField
                      label={secondary_borrower_fields.phone.label}
                      keyName={secondary_borrower_fields.phone.name}
                      value={this.state[secondary_borrower_fields.phone.name]}
                      editable={this.state.secondary_borrower_editable}
                      liveFormat={true}
                      format={this.formatPhoneNumber}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.phone)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-3'>
                    <TextField
                      label={secondary_borrower_fields.email.label}
                      keyName={secondary_borrower_fields.email.name}
                      value={this.state[secondary_borrower_fields.email.name]}
                      editable={this.state.secondary_borrower_editable}
                      liveFormat={true}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.email)}
                      onChange={this.onChange}
                      onBlur={this.onCoBorrowerChange}/>
                  </div>
                </div>
                <div className='row'>
                  <div className='col-xs-3'>
                    <TextField
                      label={secondary_borrower_fields.yearsInSchool.label}
                      keyName={secondary_borrower_fields.yearsInSchool.name}
                      value={this.state[secondary_borrower_fields.yearsInSchool.name]}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.yearsInSchool)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-3'>
                    <SelectField
                      label={secondary_borrower_fields.maritalStatus.label}
                      keyName={secondary_borrower_fields.maritalStatus.name}
                      value={this.state[secondary_borrower_fields.maritalStatus.name]}
                      options={maritalStatuses}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.maritalStatus)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-3'>
                    <TextField
                      label={secondary_borrower_fields.numberOfDependents.label}
                      keyName={secondary_borrower_fields.numberOfDependents.name}
                      value={this.state[secondary_borrower_fields.numberOfDependents.name]}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.numberOfDependents)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-3'>
                    { parseInt(this.state[secondary_borrower_fields.numberOfDependents.name], 10) > 0 ?
                      <TextField
                        label={secondary_borrower_fields.dependentAges.label}
                        keyName={secondary_borrower_fields.dependentAges.name}
                        value={this.state[secondary_borrower_fields.dependentAges.name]}
                        editable={this.state.secondary_borrower_editable}
                        placeholder='e.g. 12, 7, 3'
                        onFocus={this.onFocus.bind(this, secondary_borrower_fields.dependentAges)}
                        onChange={this.onChange}/>
                    : null }
                  </div>
                </div>
                <AddressField
                  label={secondary_borrower_fields.currentAddress.label}
                  address={this.state[secondary_borrower_fields.currentAddress.name]}
                  keyName={secondary_borrower_fields.currentAddress.name}
                  editable={this.state.secondary_borrower_editable}
                  onFocus={this.onFocus.bind(this, secondary_borrower_fields.currentAddress)}
                  onChange={this.onChange}
                  placeholder=''/>
                <div className='row'>
                  <div className='col-xs-3'>
                    <BooleanRadio
                      label={secondary_borrower_fields.currentlyOwn.label}
                      checked={this.state[secondary_borrower_fields.currentlyOwn.name]}
                      keyName={secondary_borrower_fields.currentlyOwn.name}
                      yesLabel={"Own"}
                      noLabel={"Rent"}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.currentlyOwn)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-3'>
                    { this.state[secondary_borrower_fields.currentlyOwn.name] ? null
                      :
                        <TextField
                          label={secondary_borrower_fields.currentMonthlyRent.label}
                          value={this.state[secondary_borrower_fields.currentMonthlyRent.name]}
                          keyName={secondary_borrower_fields.currentMonthlyRent.name}
                          editable={this.state.secondary_borrower_editable}
                          liveFormat={true}
                          format={this.formatCurrency}
                          onFocus={this.onFocus.bind(this, secondary_borrower_fields.currentMonthlyRent)}
                          onChange={this.onChange}/>
                    }
                  </div>
                  <div className='col-xs-6'>
                    <TextField
                      label={secondary_borrower_fields.yearsInCurrentAddress.label}
                      value={this.state[secondary_borrower_fields.yearsInCurrentAddress.name]}
                      keyName={secondary_borrower_fields.yearsInCurrentAddress.name}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.yearsInCurrentAddress)}
                      onChange={this.onChange}/>
                  </div>
                </div>
                { parseInt(this.state[secondary_borrower_fields.yearsInCurrentAddress.name], 10) < 2 ?
                  <div>
                    <AddressField
                      label={secondary_borrower_fields.previousAddress.label}
                      address={this.state[secondary_borrower_fields.previousAddress.name]}
                      keyName={secondary_borrower_fields.previousAddress.name}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.previousAddress)}
                      onChange={this.onChange}
                      placeholder=''/>
                    <div className='row'>
                      <div className='col-xs-3'>
                        <BooleanRadio
                          label={secondary_borrower_fields.previouslyOwn.label}
                          checked={this.state[secondary_borrower_fields.previouslyOwn.name]}
                          keyName={secondary_borrower_fields.previouslyOwn.name}
                          yesLabel={"Own"}
                          noLabel={"Rent"}
                          editable={this.state.secondary_borrower_editable}
                          onFocus={this.onFocus.bind(this, secondary_borrower_fields.previouslyOwn)}
                          onChange={this.onChange}/>
                      </div>
                      <div className='col-xs-3'>
                        { this.state[secondary_borrower_fields.currentlyOwn.name] ? null
                          :
                            <TextField
                              label={secondary_borrower_fields.previousMonthlyRent.label}
                              value={this.state[secondary_borrower_fields.previousMonthlyRent.name]}
                              keyName={secondary_borrower_fields.previousMonthlyRent.name}
                              editable={this.state.secondary_borrower_editable}
                              onFocus={this.onFocus.bind(this, secondary_borrower_fields.previousMonthlyRent)}
                              onChange={this.onChange}/>
                        }
                      </div>
                      <div className='col-xs-6'>
                        <TextField
                          label={secondary_borrower_fields.yearsInPreviousAddress.label}
                          value={this.state[secondary_borrower_fields.yearsInPreviousAddress.name]}
                          keyName={secondary_borrower_fields.yearsInPreviousAddress.name}
                          editable={this.state.secondary_borrower_editable}
                          onFocus={this.onFocus.bind(this, secondary_borrower_fields.yearsInPreviousAddress)}
                          onChange={this.onChange}/>
                      </div>
                    </div>
                  </div>
                : null }
                <div className='row'>
                  <div className='col-xs-12'>
                    <BooleanRadio
                      label={secondary_borrower_fields.selfEmployed.label}
                      checked={this.state[secondary_borrower_fields.selfEmployed.name]}
                      keyName={secondary_borrower_fields.selfEmployed.name}
                      yesLabel={"Yes"}
                      noLabel={"No"}
                      editable={this.state.borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.selfEmployed)}
                      onChange={this.onChange}/>
                  </div>
                </div>
              </div>
            : null }

            <div className='box text-right'>
              <a className='btn btnSml btnPrimary' onClick={this.save}>
                { this.state.saving ? 'Saving' : 'Save and Continue' }<i className='icon iconRight mls'/>
              </a>
            </div>
          </div>
        </div>

        <div className='helpSection sticky pull-right overlayRight overlayTop pal bls'>
          { this.state.focusedField && this.state.focusedField.helpText
          ? <div>
              <span className='typeEmphasize'>{this.state.focusedField.label}:</span>
              <br/>{this.state.focusedField.helpText}
            </div>
          : null }
        </div>
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
    // don't allow submit when missing co-borrower info
    if ((this.state[borrower_fields.email.name] == null) ||
          (this.state[borrower_fields.firstName.name] == null) ||
          (this.state[borrower_fields.lastName.name] == null ||
          (this.state[borrower_fields.dob.name] == null) ||
          (this.state[borrower_fields.ssn.name] == null) ||
          (this.state[borrower_fields.phone.name] == null) ||
          (this.state[borrower_fields.yearsInSchool.name] == null) ||
          (this.state[borrower_fields.currentAddress.name] == null) ||
          (this.state[borrower_fields.currentlyOwn.name] == null) ||
          (this.state[borrower_fields.yearsInCurrentAddress.name] == null) ||
          (this.state[borrower_fields.selfEmployed.name] == null))
        ) {
      var flash = { "alert-danger": 'You have to type at least email, first name and last name of you.' };
      this.showFlashes(flash);
      return false;
    }
    if (this.state[borrower_fields.applyingAs.name] == 2 && (
          (this.state[secondary_borrower_fields.email.name] == null) ||
          (this.state[secondary_borrower_fields.firstName.name] == null) ||
          (this.state[secondary_borrower_fields.lastName.name] == null ||
          (this.state[secondary_borrower_fields.dob.name] == null) ||
          (this.state[secondary_borrower_fields.ssn.name] == null) ||
          (this.state[secondary_borrower_fields.phone.name] == null) ||
          (this.state[secondary_borrower_fields.yearsInSchool.name] == null) ||
          (this.state[secondary_borrower_fields.currentAddress.name] == null) ||
          (this.state[secondary_borrower_fields.currentlyOwn.name] == null) ||
          (this.state[secondary_borrower_fields.yearsInCurrentAddress.name] == null) ||
          (this.state[secondary_borrower_fields.selfEmployed.name] == null))
        )) {
      var flash = { "alert-danger": 'You have to type at least email, first name and last name of the co-borrower.' };
      this.showFlashes(flash);
      return false;
    }
    return true
  },

  save: function() {
    if (this.valid() == false) {
      return;
    }
    this.setState({saving: true});
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
        remove_secondary_borrower: this.state[borrower_fields.applyingAs.name] == 1,
        has_secondary_borrower: this.state[borrower_fields.applyingAs.name] == 2,
        loan_id: this.props.loan.id,
      },
      success: function(response) {
        this.props.setupMenu(response, 1);
        this.setState({saving: false});
      },
      error: function(response, status, error) {
        alert(error);
        this.setState({saving: false});
      }
    });
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
    borrower[fields.selfEmployed.fieldName] = this.state[fields.selfEmployed.name];;
    return borrower;
  }
});

module.exports = FormBorrower;