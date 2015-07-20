var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');

var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var BooleanRadio = require('components/form/BooleanRadio');

var first_borrower_fields = {
  applyingAs: {label: 'I am applying', name: 'apply_as', helpText: 'I am a helpful text.'},
  firstName: {label: 'First Name', name: 'first_name', helpText: null},
  middleName: {label: 'Middle Name', name: 'middle_name', helpText: null},
  lastName: {label: 'Last Name', name: 'last_name', helpText: null},
  suffix: {label: 'Suffix', name: 'suffix', helpText: null},
  dob: {label: 'Date of Birth', name: 'dob', helpText: null},
  ssn: {label: 'Social Security Number', name: 'ssn', helpText: null},
  phone: {label: 'Phone Number', name: 'phone', helpText: null},
  yearsInSchool: {label: 'Years in school', name: 'years_in_school', helpText: null},
  maritalStatus: {label: 'Marital Status', name: 'marital_status', helpText: null},
  numberOfDependents: {label: 'Number of dependents', name: 'dependent_count', helpText: null},
  dependentAges: {label: 'Please enter the age(s) of your dependents, separated by comma', name: 'dependent_ages', helpText: null},
  currentAddress: {label: 'Address of the current property you live in', name: 'current_address', helpText: null},
  currentlyOwn: {label: 'Do you own this property?', name: 'currently_own', helpText: null},
  yearsInCurrentAddress: {label: 'Number of years you have lived in this address', name: 'years_in_current_address', helpText: null},
  previousAddress: {label: 'Previous Address', name: 'previous_address', helpText: null},
  previouslyOwn: {label: 'Do you own this property?', name: 'previously_own', helpText: null},
  yearsInPreviousAddress: {label: 'Number of years you have lived in this address', name: 'years_in_previous_address', helpText: null}
};

var second_borrower_fields = {
  applyingAs: {label: 'I am applying', name: 'apply_as', helpText: 'I am a helpful text.'},
  firstName: {label: 'First Name', name: 'first_name', helpText: null},
  middleName: {label: 'Middle Name', name: 'middle_name', helpText: null},
  lastName: {label: 'Last Name', name: 'last_name', helpText: null},
  suffix: {label: 'Suffix', name: 'suffix', helpText: null},
  dob: {label: 'Date of Birth', name: 'dob', helpText: null},
  ssn: {label: 'Social Security Number', name: 'ssn', helpText: null},
  phone: {label: 'Phone Number', name: 'phone', helpText: null},
  yearsInSchool: {label: 'Years in school', name: 'years_in_school', helpText: null},
  maritalStatus: {label: 'Marital Status', name: 'marital_status', helpText: null},
  numberOfDependents: {label: 'Number of dependents', name: 'dependent_count', helpText: null},
  dependentAges: {label: 'Please enter the age(s) of your dependents, separated by comma', name: 'dependent_ages', helpText: null},
  currentAddress: {label: 'Address of the current property you live in', name: 'current_address', helpText: null},
  currentlyOwn: {label: 'Do you own this property?', name: 'currently_own', helpText: null},
  yearsInCurrentAddress: {label: 'Number of years you have lived in this address', name: 'years_in_current_address', helpText: null},
  previousAddress: {label: 'Previous Address', name: 'previous_address', helpText: null},
  previouslyOwn: {label: 'Do you own this property?', name: 'previously_own', helpText: null},
  yearsInPreviousAddress: {label: 'Number of years you have lived in this address', name: 'years_in_previous_address', helpText: null}
};

var FormBorrower = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    var state = this.buildStateFromLoan(this.props.loan);
    state['hasCoBorrower'] = false;

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
                editable={true}
                onFocus={this.onFocus.bind(this, first_borrower_fields.applyingAs)}
                onChange={this.coBorrowerHanlder}/>

              <div className='row'>
                <div className='col-xs-6'>
                  <TextField
                    label={first_borrower_fields.firstName.label}
                    keyName={first_borrower_fields.firstName.name}
                    value={this.state[first_borrower_fields.firstName.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.firstName)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={first_borrower_fields.middleName.label}
                    keyName={first_borrower_fields.middleName.name}
                    value={this.state[first_borrower_fields.middleName.name]}
                    editable={true}
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
                    editable={true}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.lastName)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={first_borrower_fields.suffix.label}
                    keyName={first_borrower_fields.suffix.name}
                    value={this.state[first_borrower_fields.suffix.name]}
                    editable={true}
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
                    editable={true}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.dob)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={first_borrower_fields.ssn.label}
                    keyName={first_borrower_fields.ssn.name}
                    value={this.state[first_borrower_fields.ssn.name]}
                    editable={true}
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
                editable={true}
                liveFormat={true}
                format={this.formatPhoneNumber}
                onFocus={this.onFocus.bind(this, first_borrower_fields.phone)}
                onChange={this.onChange}/>
              <TextField
                label={first_borrower_fields.yearsInSchool.label}
                keyName={first_borrower_fields.yearsInSchool.name}
                value={this.state[first_borrower_fields.yearsInSchool.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, first_borrower_fields.yearsInSchool)}
                onChange={this.onChange}/>
              <SelectField
                label={first_borrower_fields.maritalStatus.label}
                keyName={first_borrower_fields.maritalStatus.name}
                value={this.state[first_borrower_fields.maritalStatus.name]}
                options={maritalStatuses}
                editable={true}
                onFocus={this.onFocus.bind(this, first_borrower_fields.maritalStatus)}
                onChange={this.onChange}/>
              <TextField
                label={first_borrower_fields.numberOfDependents.label}
                keyName={first_borrower_fields.numberOfDependents.name}
                value={this.state[first_borrower_fields.numberOfDependents.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, first_borrower_fields.numberOfDependents)}
                onChange={this.onChange}/>
              {parseInt(this.state[first_borrower_fields.numberOfDependents.name], 10) > 0 ?
                <TextField
                  label={first_borrower_fields.dependentAges.label}
                  keyName={first_borrower_fields.dependentAges.name}
                  value={this.state[first_borrower_fields.dependentAges.name]}
                  editable={true}
                  placeholder='e.g. 12, 7, 3'
                  onFocus={this.onFocus.bind(this, first_borrower_fields.dependentAges)}
                  onChange={this.onChange}/>
              : null}
              <AddressField
                label={first_borrower_fields.currentAddress.label}
                address={this.state[first_borrower_fields.currentAddress.name]}
                keyName={first_borrower_fields.currentAddress.name}
                editable={true}
                onFocus={this.onFocus.bind(this, first_borrower_fields.currentAddress)}
                onChange={this.onChange}
                placeholder='Please enter your current address'/>
              <BooleanRadio
                label={first_borrower_fields.currentlyOwn.label}
                checked={this.state[first_borrower_fields.currentlyOwn.name]}
                keyName={first_borrower_fields.currentlyOwn.name}
                editable={true}
                onFocus={this.onFocus.bind(this, first_borrower_fields.currentlyOwn)}
                onChange={this.onChange}/>
              <TextField
                label={first_borrower_fields.yearsInCurrentAddress.label}
                value={this.state[first_borrower_fields.yearsInCurrentAddress.name]}
                keyName={first_borrower_fields.yearsInCurrentAddress.name}
                editable={true}
                onFocus={this.onFocus.bind(this, first_borrower_fields.yearsInCurrentAddress)}
                onChange={this.onChange}/>
              {parseInt(this.state.yearsInCurrentAddress, 10) < 2 ?
                <div>
                  <AddressField
                    label={first_borrower_fields.previousAddress.label}
                    address={this.state[first_borrower_fields.previousAddress.name]}
                    keyName={first_borrower_fields.previousAddress.name}
                    editable={true}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.previousAddress)}
                    onChange={this.onChange}
                    placeholder='Please enter your current address'/>
                  <BooleanRadio
                    label={first_borrower_fields.previouslyOwn.label}
                    checked={this.state[first_borrower_fields.previouslyOwn.name]}
                    keyName={first_borrower_fields.previouslyOwn.name}
                    editable={true}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.previouslyOwn)}
                    onChange={this.onChange}
                    placeholder='Please enter your previous address'/>
                  <TextField
                    label={first_borrower_fields.yearsInPreviousAddress.label}
                    value={this.state[first_borrower_fields.yearsInPreviousAddress.name]}
                    keyName={first_borrower_fields.yearsInPreviousAddress.name}
                    editable={true}
                    onFocus={this.onFocus.bind(this, first_borrower_fields.yearsInPreviousAddress)}
                    onChange={this.onChange}/>
                </div>
              : null}
            </div>

            {this.state.hasCoBorrower ?
              <div>
                <h6>Your co-borrower info</h6>
                <div className='row'>
                  <div className='col-xs-6'>
                    <TextField
                      label={second_borrower_fields.firstName.label}
                      keyName={second_borrower_fields.firstName.name}
                      value={this.state[second_borrower_fields.firstName.name]}
                      editable={true}
                      onFocus={this.onFocus.bind(this, second_borrower_fields.firstName)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-6'>
                    <TextField
                      label={second_borrower_fields.middleName.label}
                      keyName={second_borrower_fields.middleName.name}
                      value={this.state[second_borrower_fields.middleName.name]}
                      editable={true}
                      onFocus={this.onFocus.bind(this, second_borrower_fields.middleName)}
                      onChange={this.onChange}/>
                  </div>
                </div>
                <div className='row'>
                  <div className='col-xs-6'>
                    <TextField
                      label={second_borrower_fields.lastName.label}
                      keyName={second_borrower_fields.lastName.name}
                      value={this.state[second_borrower_fields.lastName.name]}
                      editable={true}
                      onFocus={this.onFocus.bind(this, second_borrower_fields.lastName)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-6'>
                    <TextField
                      label={second_borrower_fields.suffix.label}
                      keyName={second_borrower_fields.suffix.name}
                      value={this.state[second_borrower_fields.suffix.name]}
                      editable={true}
                      onFocus={this.onFocus.bind(this, second_borrower_fields.suffix)}
                      onChange={this.onChange}/>
                  </div>
                </div>
                <div className='row'>
                  <div className='col-xs-6'>
                    <DateField
                      label={second_borrower_fields.dob.label}
                      keyName={second_borrower_fields.dob.name}
                      value={this.state[second_borrower_fields.dob.name]}
                      editable={true}
                      onFocus={this.onFocus.bind(this, second_borrower_fields.dob)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-6'>
                    <TextField
                      label={second_borrower_fields.ssn.label}
                      keyName={second_borrower_fields.ssn.name}
                      value={this.state[second_borrower_fields.ssn.name]}
                      editable={true}
                      format={this.formatSSN}
                      liveFormat={true}
                      onFocus={this.onFocus.bind(this, second_borrower_fields.ssn)}
                      onChange={this.onChange}/>
                  </div>
                </div>

                <TextField
                  label={second_borrower_fields.phone.label}
                  keyName={second_borrower_fields.phone.name}
                  value={this.state[second_borrower_fields.phone.name]}
                  editable={true}
                  liveFormat={true}
                  format={this.formatPhoneNumber}
                  onFocus={this.onFocus.bind(this, second_borrower_fields.phone)}
                  onChange={this.onChange}/>
                <TextField
                  label={second_borrower_fields.yearsInSchool.label}
                  keyName={second_borrower_fields.yearsInSchool.name}
                  value={this.state[second_borrower_fields.yearsInSchool.name]}
                  editable={true}
                  onFocus={this.onFocus.bind(this, second_borrower_fields.yearsInSchool)}
                  onChange={this.onChange}/>
                <SelectField
                  label={second_borrower_fields.maritalStatus.label}
                  keyName={second_borrower_fields.maritalStatus.name}
                  value={this.state[second_borrower_fields.maritalStatus.name]}
                  options={maritalStatuses}
                  editable={true}
                  onFocus={this.onFocus.bind(this, second_borrower_fields.maritalStatus)}
                  onChange={this.onChange}/>
                <TextField
                  label={second_borrower_fields.numberOfDependents.label}
                  keyName={second_borrower_fields.numberOfDependents.name}
                  value={this.state[second_borrower_fields.numberOfDependents.name]}
                  editable={true}
                  onFocus={this.onFocus.bind(this, second_borrower_fields.numberOfDependents)}
                  onChange={this.onChange}/>
                {parseInt(this.state[second_borrower_fields.numberOfDependents.name], 10) > 0 ?
                  <TextField
                    label={second_borrower_fields.dependentAges.label}
                    keyName={second_borrower_fields.dependentAges.name}
                    value={this.state[second_borrower_fields.dependentAges.name]}
                    editable={true}
                    placeholder='e.g. 12, 7, 3'
                    onFocus={this.onFocus.bind(this, second_borrower_fields.dependentAges)}
                    onChange={this.onChange}/>
                : null}
                <AddressField
                  label={second_borrower_fields.currentAddress.label}
                  address={this.state[second_borrower_fields.currentAddress.name]}
                  keyName={second_borrower_fields.currentAddress.name}
                  editable={true}
                  onFocus={this.onFocus.bind(this, second_borrower_fields.currentAddress)}
                  onChange={this.onChange}
                  placeholder='Please enter your current address'/>
                <BooleanRadio
                  label={second_borrower_fields.currentlyOwn.label}
                  checked={this.state[second_borrower_fields.currentlyOwn.name]}
                  keyName={second_borrower_fields.currentlyOwn.name}
                  editable={true}
                  onFocus={this.onFocus.bind(this, second_borrower_fields.currentlyOwn)}
                  onChange={this.onChange}/>
                <TextField
                  label={second_borrower_fields.yearsInCurrentAddress.label}
                  value={this.state[second_borrower_fields.yearsInCurrentAddress.name]}
                  keyName={second_borrower_fields.yearsInCurrentAddress.name}
                  editable={true}
                  onFocus={this.onFocus.bind(this, second_borrower_fields.yearsInCurrentAddress)}
                  onChange={this.onChange}/>
                {parseInt(this.state.yearsInCurrentAddress, 10) < 2 ?
                  <div>
                    <AddressField
                      label={second_borrower_fields.previousAddress.label}
                      address={this.state[second_borrower_fields.previousAddress.name]}
                      keyName={second_borrower_fields.previousAddress.name}
                      editable={true}
                      onFocus={this.onFocus.bind(this, second_borrower_fields.previousAddress)}
                      onChange={this.onChange}
                      placeholder='Please enter your current address'/>
                    <BooleanRadio
                      label={second_borrower_fields.previouslyOwn.label}
                      checked={this.state[second_borrower_fields.previouslyOwn.name]}
                      keyName={second_borrower_fields.previouslyOwn.name}
                      editable={true}
                      onFocus={this.onFocus.bind(this, second_borrower_fields.previouslyOwn)}
                      onChange={this.onChange}
                      placeholder='Please enter your previous address'/>
                    <TextField
                      label={second_borrower_fields.yearsInPreviousAddress.label}
                      value={this.state[second_borrower_fields.yearsInPreviousAddress.name]}
                      keyName={second_borrower_fields.yearsInPreviousAddress.name}
                      editable={true}
                      onFocus={this.onFocus.bind(this, second_borrower_fields.yearsInPreviousAddress)}
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
    var borrower = loan.borrower;
    var state = {};

    state[first_borrower_fields.firstName.name] = borrower[first_borrower_fields.firstName.name];
    state[first_borrower_fields.middleName.name] = borrower[first_borrower_fields.middleName.name];
    state[first_borrower_fields.lastName.name] = borrower[first_borrower_fields.lastName.name];
    state[first_borrower_fields.suffix.name] = borrower[first_borrower_fields.suffix.name];
    state[first_borrower_fields.dob.name] = borrower[first_borrower_fields.dob.name];
    state[first_borrower_fields.ssn.name] = borrower[first_borrower_fields.ssn.name];
    state[first_borrower_fields.phone.name] = borrower[first_borrower_fields.phone.name];
    state[first_borrower_fields.yearsInSchool.name] = borrower[first_borrower_fields.yearsInSchool.name];
    state[first_borrower_fields.maritalStatus.name] = borrower[first_borrower_fields.maritalStatus.name];
    state[first_borrower_fields.numberOfDependents.name] = borrower[first_borrower_fields.numberOfDependents.name];
    state[first_borrower_fields.dependentAges.name] = borrower[first_borrower_fields.dependentAges.name].join(', ');
    state[first_borrower_fields.currentAddress.name] = borrower[first_borrower_fields.currentAddress.name].address;
    state[first_borrower_fields.currentlyOwn.name] = !borrower[first_borrower_fields.currentAddress.name].is_rental;
    state[first_borrower_fields.yearsInCurrentAddress.name] = borrower[first_borrower_fields.currentAddress.name].years_at_address;

    return state;
  },

  buildLoanFromState: function() {
    var loan = {};

    loan.borrower_attributes = {id: this.props.loan.borrower.id};
    loan.borrower_attributes[first_borrower_fields.firstName.name] = this.state[first_borrower_fields.firstName.name];
    loan.borrower_attributes[first_borrower_fields.middleName.name] = this.state[first_borrower_fields.middleName.name];
    loan.borrower_attributes[first_borrower_fields.lastName.name] = this.state[first_borrower_fields.lastName.name];
    loan.borrower_attributes[first_borrower_fields.suffix.name] = this.state[first_borrower_fields.suffix.name];
    loan.borrower_attributes[first_borrower_fields.dob.name] = this.state[first_borrower_fields.dob.name];
    loan.borrower_attributes[first_borrower_fields.ssn.name] = this.state[first_borrower_fields.ssn.name];
    loan.borrower_attributes[first_borrower_fields.phone.name] = this.state[first_borrower_fields.phone.name];
    loan.borrower_attributes[first_borrower_fields.yearsInSchool.name] = this.state[first_borrower_fields.yearsInSchool.name];
    loan.borrower_attributes[first_borrower_fields.maritalStatus.name] = this.state[first_borrower_fields.maritalStatus.name];
    loan.borrower_attributes[first_borrower_fields.numberOfDependents.name] = this.state[first_borrower_fields.numberOfDependents.name];
    loan.borrower_attributes[first_borrower_fields.dependentAges.name] = _.map(this.state[first_borrower_fields.dependentAges.name].split(','), _.trim);
    loan.borrower_attributes.borrower_addresses_attributes = [{
      id: this.props.loan.borrower.current_address.id,
      is_rental: !this.state[first_borrower_fields.currentlyOwn.name],
      years_at_address: this.state[first_borrower_fields.yearsInCurrentAddress.name],
      address_attributes: this.state[first_borrower_fields.currentAddress.name],
      is_current: true
    }];

    if (this.state[first_borrower_fields.applyingAs.name] == 1) {
      // remove secondary borrower if user select to apply as individual borrower
      loan.pending_secondary_borrower_attributes = {
        _destroy: true
      };
    } else {
      // update secondary borrower
      loan.secondary_borrower_attributes = {id: this.props.loan.borrower.id};
      loan.secondary_borrower_attributes[first_borrower_fields.firstName.name] = this.state[first_borrower_fields.firstName.name];
      loan.secondary_borrower_attributes[first_borrower_fields.middleName.name] = this.state[first_borrower_fields.middleName.name];
      loan.secondary_borrower_attributes[first_borrower_fields.lastName.name] = this.state[first_borrower_fields.lastName.name];
      loan.secondary_borrower_attributes[first_borrower_fields.suffix.name] = this.state[first_borrower_fields.suffix.name];
      loan.secondary_borrower_attributes[first_borrower_fields.dob.name] = this.state[first_borrower_fields.dob.name];
      loan.secondary_borrower_attributes[first_borrower_fields.ssn.name] = this.state[first_borrower_fields.ssn.name];
      loan.secondary_borrower_attributes[first_borrower_fields.phone.name] = this.state[first_borrower_fields.phone.name];
      loan.secondary_borrower_attributes[first_borrower_fields.yearsInSchool.name] = this.state[first_borrower_fields.yearsInSchool.name];
      loan.secondary_borrower_attributes[first_borrower_fields.maritalStatus.name] = this.state[first_borrower_fields.maritalStatus.name];
      loan.secondary_borrower_attributes[first_borrower_fields.numberOfDependents.name] = this.state[first_borrower_fields.numberOfDependents.name];
      loan.secondary_borrower_attributes[first_borrower_fields.dependentAges.name] = _.map(this.state[first_borrower_fields.dependentAges.name].split(','), _.trim);
      loan.secondary_borrower_attributes.borrower_addresses_attributes = [{
        id: this.props.loan.borrower.current_address.id,
        is_rental: !this.state[first_borrower_fields.currentlyOwn.name],
        years_at_address: this.state[first_borrower_fields.yearsInCurrentAddress.name],
        address_attributes: this.state[first_borrower_fields.currentAddress.name],
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

// <div className='col-xs-12'>
//   <label>
//     <span className='h7 typeBold'>{fields.coBorrowerStatus.label}</span>
//   </label>
//   <p className='typeReversed'>
//     <i className='icon iconMail paxs bas circle xsm backgroundLightBlue'/>
//     &nbsp;
//     <h7 style={{color: 'black'}}>An email has been sent to let your co-borrower confirm</h7>
//   </p>
// </div>
