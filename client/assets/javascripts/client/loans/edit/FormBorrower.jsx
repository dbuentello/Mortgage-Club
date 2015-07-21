var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');

var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var BooleanRadio = require('components/form/BooleanRadio');

var first_borrower_fields = {
  applyingAs: {label: 'I am applying', name: 'first_borrower_apply_as', fieldName: 'apply_as', helpText: 'I am a helpful text.'},
  email: {label: 'Email', name: 'first_borrower_email', fieldName: 'email', helpText: null},
  firstName: {label: 'First Name', name: 'first_borrower_first_name', fieldName: 'first_name', helpText: null},
  middleName: {label: 'Middle Name', name: 'first_borrower_middle_name', fieldName: 'middle_name', helpText: null},
  lastName: {label: 'Last Name', name: 'first_borrower_last_name', fieldName: 'last_name', helpText: null},
  suffix: {label: 'Suffix', name: 'first_borrower_suffix', fieldName: 'suffix', helpText: null},
  dob: {label: 'Date of Birth', name: 'first_borrower_dob', fieldName: 'dob', helpText: null},
  ssn: {label: 'Social Security Number', name: 'first_borrower_ssn', fieldName: 'ssn', helpText: null},
  phone: {label: 'Phone Number', name: 'first_borrower_phone', fieldName: 'phone', helpText: null},
  yearsInSchool: {label: 'Years in school', name: 'first_borrower_years_in_school', fieldName: 'years_in_school', helpText: null},
  maritalStatus: {label: 'Marital Status', name: 'first_borrower_marital_status', fieldName: 'marital_status', helpText: null},
  numberOfDependents: {label: 'Number of dependents', name: 'first_borrower_dependent_count', fieldName: 'dependent_count', helpText: null},
  dependentAges: {label: 'Please enter the age(s) of your dependents, separated by comma', name: 'first_borrower_dependent_ages', fieldName: 'dependent_ages', helpText: null},
  currentAddress: {label: 'Address of the current property you live in', name: 'first_borrower_current_address', fieldName: 'current_address', helpText: null},
  currentlyOwn: {label: 'Do you own this property?', name: 'first_borrower_currently_own', fieldName: 'currently_own', helpText: null},
  yearsInCurrentAddress: {label: 'Number of years you have lived in this address', name: 'first_borrower_years_in_current_address', fieldName: 'years_in_current_address', helpText: null},
  previousAddress: {label: 'Previous Address', name: 'first_borrower_previous_address', fieldName: 'previous_address', helpText: null},
  previouslyOwn: {label: 'Do you own this property?', name: 'first_borrower_previously_own', fieldName: 'previously_own', helpText: null},
  yearsInPreviousAddress: {label: 'Number of years you have lived in this address', name: 'first_borrower_years_in_previous_address', fieldName: 'years_in_previous_address', helpText: null}
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
  yearsInSchool: {label: 'Years in school', name: 'secondary_borrower_years_in_school', fieldName: 'years_in_school', helpText: null},
  maritalStatus: {label: 'Marital Status', name: 'secondary_borrower_marital_status', fieldName: 'marital_status', helpText: null},
  numberOfDependents: {label: 'Number of dependents', name: 'secondary_borrower_dependent_count', fieldName: 'dependent_count', helpText: null},
  dependentAges: {label: 'Please enter the age(s) of your dependents, separated by comma', name: 'secondary_borrower_dependent_ages', fieldName: 'dependent_ages', helpText: null},
  currentAddress: {label: 'Address of the current property you live in', name: 'secondary_borrower_current_address', fieldName: 'current_address', helpText: null},
  currentlyOwn: {label: 'Do you own this property?', name: 'secondary_borrower_currently_own', fieldName: 'currently_own', helpText: null},
  yearsInCurrentAddress: {label: 'Number of years you have lived in this address', name: 'secondary_borrower_years_in_current_address', fieldName: 'years_in_current_address', helpText: null},
  previousAddress: {label: 'Previous Address', name: 'secondary_borrower_previous_address', fieldName: 'previous_address', helpText: null},
  previouslyOwn: {label: 'Do you own this property?', name: 'secondary_borrower_previously_own', fieldName: 'previously_own', helpText: null},
  yearsInPreviousAddress: {label: 'Number of years you have lived in this address', name: 'secondary_borrower_years_in_previous_address', fieldName: 'years_in_previous_address', helpText: null}
};

var FormBorrower = React.createClass({
  mixins: [TextFormatMixin],

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
    if (event.target.value == 1) {
      this.setState({ hasCoBorrower: false });
    } else {
      this.setState({ hasCoBorrower: true });
    }

    this.setState(change);
  },

  onCoBorrowerEmailChange: function() {
    if (this.props.borrower_type == 0) {
      // console.log("current co-borrower email: " + event.target.value);

      $.ajax({
        url: '/loans/get_co_borrower_info',
        method: 'GET',
        data: {
          email: event.target.value
        },
        dataType: 'json',
        success: function(response) {
          // console.dir(response.secondary_borrower);
          var change = {};
          if (response.secondary_borrower) {
            change = this.buildStateFromSecondaryBorrower(change, response.secondary_borrower);
          } else {
            _.map(secondary_borrower_fields, function (field, index) {
              if (field.name === 'secondary_borrower_email') { return; }
              change[field.name] = null;
            });
          };
          this.setState(change);
        }.bind(this),
        error: function(response, status, error) {
          alert(error);
        }
      })
    };

  },

  render: function() {
    var borrowerCountOptions = [
      {name: 'As an individual', value: 1},
      {name: 'With a co-borrower', value: 2}
    ];

    var maritalStatuses = [
      {name: 'Married (includes registered domestic partners)', value: 'married'},
      {name: 'Unmarried (includes single, divorced, widowed)', value: 'unmarried'},
      {name: 'Separated', value: 'separated'}
    ];

    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mtn'>
              <SelectField
                label={first_borrower_fields.applyingAs.label}
                keyName={first_borrower_fields.applyingAs.name}
                value={this.state[first_borrower_fields.applyingAs.name]}
                options={borrowerCountOptions}
                editable={this.state.borrower_editable}
                onFocus={this.onFocus.bind(this, first_borrower_fields.applyingAs)}
                onChange={this.coBorrowerHanlder}/>

              <TextField
                label={first_borrower_fields.email.label}
                keyName={first_borrower_fields.email.name}
                value={this.state[first_borrower_fields.email.name]}
                editable={this.state.borrower_editable}
                liveFormat={true}
                onFocus={this.onFocus.bind(this, first_borrower_fields.email)}
                onChange={this.onChange}/>

              <div className='row'>
                <div className='col-xs-6'>
                  <TextField
                    label={first_borrower_fields.firstName.label}
                    keyName={first_borrower_fields.firstName.name}
                    value={this.state[first_borrower_fields.firstName.name]}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.firstName)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={first_borrower_fields.middleName.label}
                    keyName={first_borrower_fields.middleName.name}
                    value={this.state[first_borrower_fields.middleName.name]}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.middleName)}
                    onChange={this.onChange}/>
                </div>
              </div>
              <div className='row'>
                <div className='col-xs-6'>
                  <TextField
                    label={first_borrower_fields.lastName.label}
                    keyName={first_borrower_fields.lastName.name}
                    value={this.state[first_borrower_fields.lastName.name]}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.lastName)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={first_borrower_fields.suffix.label}
                    keyName={first_borrower_fields.suffix.name}
                    value={this.state[first_borrower_fields.suffix.name]}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.suffix)}
                    onChange={this.onChange}/>
                </div>
              </div>
              <div className='row'>
                <div className='col-xs-6'>
                  <DateField
                    label={first_borrower_fields.dob.label}
                    keyName={first_borrower_fields.dob.name}
                    value={this.state[first_borrower_fields.dob.name]}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.dob)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={first_borrower_fields.ssn.label}
                    keyName={first_borrower_fields.ssn.name}
                    value={this.state[first_borrower_fields.ssn.name]}
                    editable={this.state.borrower_editable}
                    format={this.formatSSN}
                    liveFormat={true}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.ssn)}
                    onChange={this.onChange}/>
                </div>
              </div>

              <TextField
                label={first_borrower_fields.phone.label}
                keyName={first_borrower_fields.phone.name}
                value={this.state[first_borrower_fields.phone.name]}
                editable={this.state.borrower_editable}
                liveFormat={true}
                format={this.formatPhoneNumber}
                onFocus={this.onFocus.bind(this, first_borrower_fields.phone)}
                onChange={this.onChange}/>
              <TextField
                label={first_borrower_fields.yearsInSchool.label}
                keyName={first_borrower_fields.yearsInSchool.name}
                value={this.state[first_borrower_fields.yearsInSchool.name]}
                editable={this.state.borrower_editable}
                onFocus={this.onFocus.bind(this, first_borrower_fields.yearsInSchool)}
                onChange={this.onChange}/>
              <SelectField
                label={first_borrower_fields.maritalStatus.label}
                keyName={first_borrower_fields.maritalStatus.name}
                value={this.state[first_borrower_fields.maritalStatus.name]}
                options={maritalStatuses}
                editable={this.state.borrower_editable}
                onFocus={this.onFocus.bind(this, first_borrower_fields.maritalStatus)}
                onChange={this.onChange}/>
              <TextField
                label={first_borrower_fields.numberOfDependents.label}
                keyName={first_borrower_fields.numberOfDependents.name}
                value={this.state[first_borrower_fields.numberOfDependents.name]}
                editable={this.state.borrower_editable}
                onFocus={this.onFocus.bind(this, first_borrower_fields.numberOfDependents)}
                onChange={this.onChange}/>
              {parseInt(this.state[first_borrower_fields.numberOfDependents.name], 10) > 0 ?
                <TextField
                  label={first_borrower_fields.dependentAges.label}
                  keyName={first_borrower_fields.dependentAges.name}
                  value={this.state[first_borrower_fields.dependentAges.name]}
                  editable={this.state.borrower_editable}
                  placeholder='e.g. 12, 7, 3'
                  onFocus={this.onFocus.bind(this, first_borrower_fields.dependentAges)}
                  onChange={this.onChange}/>
              : null}
              <AddressField
                label={first_borrower_fields.currentAddress.label}
                address={this.state[first_borrower_fields.currentAddress.name]}
                keyName={first_borrower_fields.currentAddress.name}
                editable={this.state.borrower_editable}
                onFocus={this.onFocus.bind(this, first_borrower_fields.currentAddress)}
                onChange={this.onChange}
                placeholder='Please enter your current address'/>
              <BooleanRadio
                label={first_borrower_fields.currentlyOwn.label}
                checked={this.state[first_borrower_fields.currentlyOwn.name]}
                keyName={first_borrower_fields.currentlyOwn.name}
                editable={this.state.borrower_editable}
                onFocus={this.onFocus.bind(this, first_borrower_fields.currentlyOwn)}
                onChange={this.onChange}/>
              <TextField
                label={first_borrower_fields.yearsInCurrentAddress.label}
                value={this.state[first_borrower_fields.yearsInCurrentAddress.name]}
                keyName={first_borrower_fields.yearsInCurrentAddress.name}
                editable={this.state.borrower_editable}
                onFocus={this.onFocus.bind(this, first_borrower_fields.yearsInCurrentAddress)}
                onChange={this.onChange}/>
              {parseInt(this.state.yearsInCurrentAddress, 10) < 2 ?
                <div>
                  <AddressField
                    label={first_borrower_fields.previousAddress.label}
                    address={this.state[first_borrower_fields.previousAddress.name]}
                    keyName={first_borrower_fields.previousAddress.name}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.previousAddress)}
                    onChange={this.onChange}
                    placeholder='Please enter your current address'/>
                  <BooleanRadio
                    label={first_borrower_fields.previouslyOwn.label}
                    checked={this.state[first_borrower_fields.previouslyOwn.name]}
                    keyName={first_borrower_fields.previouslyOwn.name}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.previouslyOwn)}
                    onChange={this.onChange}
                    placeholder='Please enter your previous address'/>
                  <TextField
                    label={first_borrower_fields.yearsInPreviousAddress.label}
                    value={this.state[first_borrower_fields.yearsInPreviousAddress.name]}
                    keyName={first_borrower_fields.yearsInPreviousAddress.name}
                    editable={this.state.borrower_editable}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.yearsInPreviousAddress)}
                    onChange={this.onChange}/>
                </div>
              : null}
            </div>

            {this.state.hasCoBorrower ?
              <div className='box mtn'>
                <h6>Your co-borrower info</h6>
                <TextField
                  label={secondary_borrower_fields.email.label}
                  keyName={secondary_borrower_fields.email.name}
                  value={this.state[secondary_borrower_fields.email.name]}
                  editable={this.state.secondary_borrower_editable}
                  liveFormat={true}
                  onFocus={this.onFocus.bind(this, secondary_borrower_fields.email)}
                  onChange={this.onChange}
                  onBlur={this.onCoBorrowerEmailChange}/>
                <div className='row'>
                  <div className='col-xs-6'>
                    <TextField
                      label={secondary_borrower_fields.firstName.label}
                      keyName={secondary_borrower_fields.firstName.name}
                      value={this.state[secondary_borrower_fields.firstName.name]}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.firstName)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-6'>
                    <TextField
                      label={secondary_borrower_fields.middleName.label}
                      keyName={secondary_borrower_fields.middleName.name}
                      value={this.state[secondary_borrower_fields.middleName.name]}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.middleName)}
                      onChange={this.onChange}/>
                  </div>
                </div>
                <div className='row'>
                  <div className='col-xs-6'>
                    <TextField
                      label={secondary_borrower_fields.lastName.label}
                      keyName={secondary_borrower_fields.lastName.name}
                      value={this.state[secondary_borrower_fields.lastName.name]}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.lastName)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-6'>
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
                  <div className='col-xs-6'>
                    <DateField
                      label={secondary_borrower_fields.dob.label}
                      keyName={secondary_borrower_fields.dob.name}
                      value={this.state[secondary_borrower_fields.dob.name]}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.dob)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-6'>
                    <TextField
                      label={secondary_borrower_fields.ssn.label}
                      keyName={secondary_borrower_fields.ssn.name}
                      value={this.state[secondary_borrower_fields.ssn.name]}
                      editable={this.state.secondary_borrower_editable}
                      format={this.formatSSN}
                      liveFormat={true}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.ssn)}
                      onChange={this.onChange}/>
                  </div>
                </div>

                <TextField
                  label={secondary_borrower_fields.phone.label}
                  keyName={secondary_borrower_fields.phone.name}
                  value={this.state[secondary_borrower_fields.phone.name]}
                  editable={this.state.secondary_borrower_editable}
                  liveFormat={true}
                  format={this.formatPhoneNumber}
                  onFocus={this.onFocus.bind(this, secondary_borrower_fields.phone)}
                  onChange={this.onChange}/>
                <TextField
                  label={secondary_borrower_fields.yearsInSchool.label}
                  keyName={secondary_borrower_fields.yearsInSchool.name}
                  value={this.state[secondary_borrower_fields.yearsInSchool.name]}
                  editable={this.state.secondary_borrower_editable}
                  onFocus={this.onFocus.bind(this, secondary_borrower_fields.yearsInSchool)}
                  onChange={this.onChange}/>
                <SelectField
                  label={secondary_borrower_fields.maritalStatus.label}
                  keyName={secondary_borrower_fields.maritalStatus.name}
                  value={this.state[secondary_borrower_fields.maritalStatus.name]}
                  options={maritalStatuses}
                  editable={this.state.secondary_borrower_editable}
                  onFocus={this.onFocus.bind(this, secondary_borrower_fields.maritalStatus)}
                  onChange={this.onChange}/>
                <TextField
                  label={secondary_borrower_fields.numberOfDependents.label}
                  keyName={secondary_borrower_fields.numberOfDependents.name}
                  value={this.state[secondary_borrower_fields.numberOfDependents.name]}
                  editable={this.state.secondary_borrower_editable}
                  onFocus={this.onFocus.bind(this, secondary_borrower_fields.numberOfDependents)}
                  onChange={this.onChange}/>
                {parseInt(this.state[secondary_borrower_fields.numberOfDependents.name], 10) > 0 ?
                  <TextField
                    label={secondary_borrower_fields.dependentAges.label}
                    keyName={secondary_borrower_fields.dependentAges.name}
                    value={this.state[secondary_borrower_fields.dependentAges.name]}
                    editable={this.state.secondary_borrower_editable}
                    placeholder='e.g. 12, 7, 3'
                    onFocus={this.onFocus.bind(this, secondary_borrower_fields.dependentAges)}
                    onChange={this.onChange}/>
                : null}
                <AddressField
                  label={secondary_borrower_fields.currentAddress.label}
                  address={this.state[secondary_borrower_fields.currentAddress.name]}
                  keyName={secondary_borrower_fields.currentAddress.name}
                  editable={this.state.secondary_borrower_editable}
                  onFocus={this.onFocus.bind(this, secondary_borrower_fields.currentAddress)}
                  onChange={this.onChange}
                  placeholder='Please enter your current address'/>
                <BooleanRadio
                  label={secondary_borrower_fields.currentlyOwn.label}
                  checked={this.state[secondary_borrower_fields.currentlyOwn.name]}
                  keyName={secondary_borrower_fields.currentlyOwn.name}
                  editable={this.state.secondary_borrower_editable}
                  onFocus={this.onFocus.bind(this, secondary_borrower_fields.currentlyOwn)}
                  onChange={this.onChange}/>
                <TextField
                  label={secondary_borrower_fields.yearsInCurrentAddress.label}
                  value={this.state[secondary_borrower_fields.yearsInCurrentAddress.name]}
                  keyName={secondary_borrower_fields.yearsInCurrentAddress.name}
                  editable={this.state.secondary_borrower_editable}
                  onFocus={this.onFocus.bind(this, secondary_borrower_fields.yearsInCurrentAddress)}
                  onChange={this.onChange}/>
                {parseInt(this.state.yearsInCurrentAddress, 10) < 2 ?
                  <div>
                    <AddressField
                      label={secondary_borrower_fields.previousAddress.label}
                      address={this.state[secondary_borrower_fields.previousAddress.name]}
                      keyName={secondary_borrower_fields.previousAddress.name}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.previousAddress)}
                      onChange={this.onChange}
                      placeholder='Please enter your current address'/>
                    <BooleanRadio
                      label={secondary_borrower_fields.previouslyOwn.label}
                      checked={this.state[secondary_borrower_fields.previouslyOwn.name]}
                      keyName={secondary_borrower_fields.previouslyOwn.name}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.previouslyOwn)}
                      onChange={this.onChange}
                      placeholder='Please enter your previous address'/>
                    <TextField
                      label={secondary_borrower_fields.yearsInPreviousAddress.label}
                      value={this.state[secondary_borrower_fields.yearsInPreviousAddress.name]}
                      keyName={secondary_borrower_fields.yearsInPreviousAddress.name}
                      editable={this.state.secondary_borrower_editable}
                      onFocus={this.onFocus.bind(this, secondary_borrower_fields.yearsInPreviousAddress)}
                      onChange={this.onChange}/>
                  </div>
                : null}
              </div>
            : null}

            <div className='box text-right'>
              <a className='btn btnSml btnPrimary' onClick={this.save} disabled={this.state.saving}>
                {this.state.saving ? 'Saving' : 'Save and Continue'}<i className='icon iconRight mls'/>
              </a>
            </div>
          </div>
        </div>

        <div className='helpSection sticky pull-right overlayRight overlayTop pal bls'>
          {this.state.focusedField && this.state.focusedField.helpText
          ? <div>
              <span className='typeEmphasize'>{this.state.focusedField.label}:</span>
              <br/>{this.state.focusedField.helpText}
            </div>
          : null}
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

    var secondary_borrower = loan.secondary_borrower;
    switch(this.props.borrower_type) {
    case 0:
      state['borrower_editable'] = true;

      if (secondary_borrower) {
        state[first_borrower_fields.applyingAs.name] = 2;
        state['hasCoBorrower'] = true;
        state['secondary_borrower_editable'] = false;

        // build state for secondary borrower
        state = this.buildStateFromSecondaryBorrower(state, secondary_borrower);
      } else {
        state[first_borrower_fields.applyingAs.name] = 1;
        state['hasCoBorrower'] = false;
        state['secondary_borrower_editable'] = true;
      };
      break;

    case 1:
      state[first_borrower_fields.applyingAs.name] = 2;
      state['hasCoBorrower'] = true;
      state['borrower_editable'] = false;
      state['secondary_borrower_editable'] = true;

      // build state for secondary borrower
      state = this.buildStateFromSecondaryBorrower(state, secondary_borrower);
      break;

    default:
      console.log('cannot find proper case for borrower_type');
    };

    state[first_borrower_fields.email.name] = first_borrower_user[first_borrower_fields.email.fieldName];
    state[first_borrower_fields.firstName.name] = borrower[first_borrower_fields.firstName.fieldName];
    state[first_borrower_fields.middleName.name] = borrower[first_borrower_fields.middleName.fieldName];
    state[first_borrower_fields.lastName.name] = borrower[first_borrower_fields.lastName.fieldName];
    state[first_borrower_fields.suffix.name] = borrower[first_borrower_fields.suffix.fieldName];
    state[first_borrower_fields.dob.name] = borrower[first_borrower_fields.dob.fieldName];
    state[first_borrower_fields.ssn.name] = borrower[first_borrower_fields.ssn.fieldName];
    state[first_borrower_fields.phone.name] = borrower[first_borrower_fields.phone.fieldName];
    state[first_borrower_fields.yearsInSchool.name] = borrower[first_borrower_fields.yearsInSchool.fieldName];
    state[first_borrower_fields.maritalStatus.name] = borrower[first_borrower_fields.maritalStatus.fieldName];
    state[first_borrower_fields.numberOfDependents.name] = borrower[first_borrower_fields.numberOfDependents.fieldName];
    state[first_borrower_fields.dependentAges.name] = borrower[first_borrower_fields.dependentAges.fieldName].join(', ');
    if (borrower[first_borrower_fields.currentAddress.fieldName]) {
      state[first_borrower_fields.currentAddress.name] = borrower[first_borrower_fields.currentAddress.fieldName].address;
      state[first_borrower_fields.currentlyOwn.name] = !borrower[first_borrower_fields.currentAddress.fieldName].is_rental;
      state[first_borrower_fields.yearsInCurrentAddress.name] = borrower[first_borrower_fields.currentAddress.fieldName].years_at_address;
    };

    return state;
  },

  buildStateFromSecondaryBorrower: function(state, secondary_borrower) {
    var secondary_borrower_user = secondary_borrower.user;
    state[secondary_borrower_fields.email.name] = secondary_borrower_user[secondary_borrower_fields.email.fieldName];

    state[secondary_borrower_fields.firstName.name] = secondary_borrower[secondary_borrower_fields.firstName.fieldName];
    state[secondary_borrower_fields.middleName.name] = secondary_borrower[secondary_borrower_fields.middleName.fieldName];
    state[secondary_borrower_fields.lastName.name] = secondary_borrower[secondary_borrower_fields.lastName.fieldName];
    state[secondary_borrower_fields.suffix.name] = secondary_borrower[secondary_borrower_fields.suffix.fieldName];
    state[secondary_borrower_fields.dob.name] = secondary_borrower[secondary_borrower_fields.dob.fieldName];
    state[secondary_borrower_fields.ssn.name] = secondary_borrower[secondary_borrower_fields.ssn.fieldName];
    state[secondary_borrower_fields.phone.name] = secondary_borrower[secondary_borrower_fields.phone.fieldName];
    state[secondary_borrower_fields.yearsInSchool.name] = secondary_borrower[secondary_borrower_fields.yearsInSchool.fieldName];
    state[secondary_borrower_fields.maritalStatus.name] = secondary_borrower[secondary_borrower_fields.maritalStatus.fieldName];
    state[secondary_borrower_fields.numberOfDependents.name] = secondary_borrower[secondary_borrower_fields.numberOfDependents.fieldName];
    state[secondary_borrower_fields.dependentAges.name] = secondary_borrower[secondary_borrower_fields.dependentAges.fieldName].join(', ');
    if (secondary_borrower[secondary_borrower_fields.currentAddress.fieldName]) {
      state[secondary_borrower_fields.currentAddress.name] = secondary_borrower[secondary_borrower_fields.currentAddress.fieldName].address;
      state[secondary_borrower_fields.currentlyOwn.name] = !secondary_borrower[secondary_borrower_fields.currentAddress.fieldName].is_rental;
      state[secondary_borrower_fields.yearsInCurrentAddress.name] = secondary_borrower[secondary_borrower_fields.currentAddress.fieldName].years_at_address;
    };

    return state;
  },

  buildLoanFromState: function() {
    var loan = {};

    loan.borrower_attributes = {id: this.props.loan.borrower.id};
    loan.borrower_attributes[first_borrower_fields.email.fieldName] = this.state[first_borrower_fields.email.name];
    loan.borrower_attributes[first_borrower_fields.firstName.fieldName] = this.state[first_borrower_fields.firstName.name];
    loan.borrower_attributes[first_borrower_fields.middleName.fieldName] = this.state[first_borrower_fields.middleName.name];
    loan.borrower_attributes[first_borrower_fields.lastName.fieldName] = this.state[first_borrower_fields.lastName.name];
    loan.borrower_attributes[first_borrower_fields.suffix.fieldName] = this.state[first_borrower_fields.suffix.name];
    loan.borrower_attributes[first_borrower_fields.dob.fieldName] = this.state[first_borrower_fields.dob.name];
    loan.borrower_attributes[first_borrower_fields.ssn.fieldName] = this.state[first_borrower_fields.ssn.name];
    loan.borrower_attributes[first_borrower_fields.phone.fieldName] = this.state[first_borrower_fields.phone.name];
    loan.borrower_attributes[first_borrower_fields.yearsInSchool.fieldName] = this.state[first_borrower_fields.yearsInSchool.name];
    loan.borrower_attributes[first_borrower_fields.maritalStatus.fieldName] = this.state[first_borrower_fields.maritalStatus.name];
    loan.borrower_attributes[first_borrower_fields.numberOfDependents.fieldName] = this.state[first_borrower_fields.numberOfDependents.name];

    if ( this.state[first_borrower_fields.numberOfDependents.name] > 0 ) {
      loan.borrower_attributes[first_borrower_fields.dependentAges.fieldName] = _.map(this.state[first_borrower_fields.dependentAges.name].split(','), _.trim);
    };

    // borrower_addresses data
    var borrower_address_id = null;
    if (this.props.loan.borrower.current_address) {
      borrower_address_id = this.props.loan.borrower.current_address.id;
    };
    loan.borrower_attributes.borrower_addresses_attributes = [{
      id: borrower_address_id,
      is_rental: !this.state[first_borrower_fields.currentlyOwn.name],
      years_at_address: this.state[first_borrower_fields.yearsInCurrentAddress.name],
      address_attributes: this.state[first_borrower_fields.currentAddress.name] ? this.state[first_borrower_fields.currentAddress.name] : [],
      is_current: true
    }];

    if (this.state[first_borrower_fields.applyingAs.name] == 1) {
      // remove secondary borrower if user select to apply as individual borrower
      loan.secondary_borrower_attributes = {
        _remove: true
      };
    } else {
      // update secondary borrower
      if ( typeof this.props.loan.secondary_borrower !== 'undefined' ) {
        loan.secondary_borrower_attributes = {id: this.props.loan.secondary_borrower.id};
      } else {
        loan.secondary_borrower_attributes = {};
      };

      loan.secondary_borrower_attributes[secondary_borrower_fields.email.fieldName] = this.state[secondary_borrower_fields.email.name];
      loan.secondary_borrower_attributes[secondary_borrower_fields.firstName.fieldName] = this.state[secondary_borrower_fields.firstName.name];
      loan.secondary_borrower_attributes[secondary_borrower_fields.middleName.fieldName] = this.state[secondary_borrower_fields.middleName.name];
      loan.secondary_borrower_attributes[secondary_borrower_fields.lastName.fieldName] = this.state[secondary_borrower_fields.lastName.name];
      loan.secondary_borrower_attributes[secondary_borrower_fields.suffix.fieldName] = this.state[secondary_borrower_fields.suffix.name];
      loan.secondary_borrower_attributes[secondary_borrower_fields.dob.fieldName] = this.state[secondary_borrower_fields.dob.name];
      loan.secondary_borrower_attributes[secondary_borrower_fields.ssn.fieldName] = this.state[secondary_borrower_fields.ssn.name];
      loan.secondary_borrower_attributes[secondary_borrower_fields.phone.fieldName] = this.state[secondary_borrower_fields.phone.name];
      loan.secondary_borrower_attributes[secondary_borrower_fields.yearsInSchool.fieldName] = this.state[secondary_borrower_fields.yearsInSchool.name];
      loan.secondary_borrower_attributes[secondary_borrower_fields.maritalStatus.fieldName] = this.state[secondary_borrower_fields.maritalStatus.name];
      loan.secondary_borrower_attributes[secondary_borrower_fields.numberOfDependents.fieldName] = this.state[secondary_borrower_fields.numberOfDependents.name];

      if (this.state[secondary_borrower_fields.numberOfDependents.name] > 0) {
        loan.secondary_borrower_attributes[secondary_borrower_fields.dependentAges.fieldName] = _.map(this.state[secondary_borrower_fields.dependentAges.name].split(','), _.trim);
      };

      // borrower_addresses data
      var borrower_address_id = null;
      if (typeof this.props.loan.secondary_borrower !== 'undefined' && this.props.loan.secondary_borrower.current_address) {
        borrower_address_id = this.props.loan.secondary_borrower.current_address.id;
      };
      loan.secondary_borrower_attributes.borrower_addresses_attributes = [{
        id: borrower_address_id,
        is_rental: !this.state[secondary_borrower_fields.currentlyOwn.name],
        years_at_address: this.state[secondary_borrower_fields.yearsInCurrentAddress.name],
        address_attributes: this.state[secondary_borrower_fields.currentAddress.name] ? this.state[secondary_borrower_fields.currentAddress.name] : [],
        is_current: true
      }];
    }

    return loan;
  },

  save: function() {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 1);
  }
});

module.exports = FormBorrower;
