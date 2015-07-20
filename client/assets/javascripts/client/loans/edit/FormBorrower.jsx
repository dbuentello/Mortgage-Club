var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');

var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var BooleanRadio = require('components/form/BooleanRadio');

var fields = {
  applyingAs: {label: 'I am applying', name: 'apply_as', helpText: 'I am a helpful text.'},
  coBorrowerName: {label: 'Your co-borrower name', name: 'co_borrower_name', helpText: 'type the name of your co-borrower here'},
  coBorrowerEmail: {label: 'Your co-borrower email', name: 'co_borrower_email', helpText: 'type the email of your co-borrower here'},
  coBorrowerStatus: {label: 'Link to your co-borrower status', name: 'co_borrower_status', helpText: null},
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
                label={fields.applyingAs.label}
                keyName={fields.applyingAs.name}
                value={this.state[fields.applyingAs.name]}
                options={borrowerCountOptions}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.applyingAs)}
                onChange={this.coBorrowerHanlder}/>
              {this.state.hasCoBorrower ?
                <div className='row'>
                  <div className='col-xs-12'>
                    <label>
                      <span className='h7 typeBold'>{fields.coBorrowerStatus.label}</span>
                    </label>
                    <p className='typeReversed'>
                      <i className='icon iconMail paxs bas circle xsm backgroundLightBlue'/>
                      <h7>An email has been sent to let your co-borrower confirm</h7>
                    </p>
                  </div>
                  <div className='col-xs-6'>
                    <TextField
                      label={fields.coBorrowerName.label}
                      keyName={fields.coBorrowerName.name}
                      value={this.state[fields.coBorrowerName.name]}
                      editable={true}
                      onFocus={this.onFocus.bind(this, fields.coBorrowerName)}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-6'>
                    <TextField
                      label={fields.coBorrowerEmail.label}
                      keyName={fields.coBorrowerEmail.name}
                      value={this.state[fields.coBorrowerEmail.name]}
                      editable={true}
                      onFocus={this.onFocus.bind(this, fields.coBorrowerEmail)}
                      onChange={this.onChange}/>
                  </div>
                </div>
              : null}
              <div className='row'>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.firstName.label}
                    keyName={fields.firstName.name}
                    value={this.state[fields.firstName.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.firstName)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.middleName.label}
                    keyName={fields.middleName.name}
                    value={this.state[fields.middleName.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.middleName)}
                    onChange={this.onChange}/>
                </div>
              </div>
              <div className='row'>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.lastName.label}
                    keyName={fields.lastName.name}
                    value={this.state[fields.lastName.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.lastName)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.suffix.label}
                    keyName={fields.suffix.name}
                    value={this.state[fields.suffix.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.suffix)}
                    onChange={this.onChange}/>
                </div>
              </div>

              <div className='row'>
                <div className='col-xs-6'>
                  <DateField
                    label={fields.dob.label}
                    keyName={fields.dob.name}
                    value={this.state[fields.dob.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.dob)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.ssn.label}
                    keyName={fields.ssn.name}
                    value={this.state[fields.ssn.name]}
                    editable={true}
                    format={this.formatSSN}
                    liveFormat={true}
                    onFocus={this.onFocus.bind(this, fields.ssn)}
                    onChange={this.onChange}/>
                </div>
              </div>

              <TextField
                label={fields.phone.label}
                keyName={fields.phone.name}
                value={this.state[fields.phone.name]}
                editable={true}
                liveFormat={true}
                format={this.formatPhoneNumber}
                onFocus={this.onFocus.bind(this, fields.phone)}
                onChange={this.onChange}/>
              <TextField
                label={fields.yearsInSchool.label}
                keyName={fields.yearsInSchool.name}
                value={this.state[fields.yearsInSchool.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.yearsInSchool)}
                onChange={this.onChange}/>
              <SelectField
                label={fields.maritalStatus.label}
                keyName={fields.maritalStatus.name}
                value={this.state[fields.maritalStatus.name]}
                options={maritalStatuses}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.maritalStatus)}
                onChange={this.onChange}/>
              <TextField
                label={fields.numberOfDependents.label}
                keyName={fields.numberOfDependents.name}
                value={this.state[fields.numberOfDependents.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.numberOfDependents)}
                onChange={this.onChange}/>
              {parseInt(this.state[fields.numberOfDependents.name], 10) > 0 ?
                <TextField
                  label={fields.dependentAges.label}
                  keyName={fields.dependentAges.name}
                  value={this.state[fields.dependentAges.name]}
                  editable={true}
                  placeholder='e.g. 12, 7, 3'
                  onFocus={this.onFocus.bind(this, fields.dependentAges)}
                  onChange={this.onChange}/>
              : null}
              <AddressField
                label={fields.currentAddress.label}
                address={this.state[fields.currentAddress.name]}
                keyName={fields.currentAddress.name}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.currentAddress)}
                onChange={this.onChange}
                placeholder='Please enter your current address'/>
              <BooleanRadio
                label={fields.currentlyOwn.label}
                checked={this.state[fields.currentlyOwn.name]}
                keyName={fields.currentlyOwn.name}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.currentlyOwn)}
                onChange={this.onChange}/>
              <TextField
                label={fields.yearsInCurrentAddress.label}
                value={this.state[fields.yearsInCurrentAddress.name]}
                keyName={fields.yearsInCurrentAddress.name}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.yearsInCurrentAddress)}
                onChange={this.onChange}/>
              {parseInt(this.state.yearsInCurrentAddress, 10) < 2 ?
                <div>
                  <AddressField
                    label={fields.previousAddress.label}
                    address={this.state[fields.previousAddress.name]}
                    keyName={fields.previousAddress.name}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.previousAddress)}
                    onChange={this.onChange}
                    placeholder='Please enter your current address'/>
                  <BooleanRadio
                    label={fields.previouslyOwn.label}
                    checked={this.state[fields.previouslyOwn.name]}
                    keyName={fields.previouslyOwn.name}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.previouslyOwn)}
                    onChange={this.onChange}
                    placeholder='Please enter your previous address'/>
                  <TextField
                    label={fields.yearsInPreviousAddress.label}
                    value={this.state[fields.yearsInPreviousAddress.name]}
                    keyName={fields.yearsInPreviousAddress.name}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.yearsInPreviousAddress)}
                    onChange={this.onChange}/>
                </div>
              : null}
            </div>

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

    borrower.current_address = borrower.current_address || {};

    state[fields.firstName.name] = borrower[fields.firstName.name];
    state[fields.middleName.name] = borrower[fields.middleName.name];
    state[fields.lastName.name] = borrower[fields.lastName.name];
    state[fields.suffix.name] = borrower[fields.suffix.name];
    state[fields.dob.name] = borrower[fields.dob.name];
    state[fields.ssn.name] = borrower[fields.ssn.name];
    state[fields.phone.name] = borrower[fields.phone.name];
    state[fields.yearsInSchool.name] = borrower[fields.yearsInSchool.name];
    state[fields.maritalStatus.name] = borrower[fields.maritalStatus.name];
    state[fields.numberOfDependents.name] = borrower[fields.numberOfDependents.name];
    state[fields.dependentAges.name] = borrower[fields.dependentAges.name].join(', ');
    state[fields.currentAddress.name] = borrower[fields.currentAddress.name].address;
    state[fields.currentlyOwn.name] = !borrower[fields.currentAddress.name].is_rental;
    state[fields.yearsInCurrentAddress.name] = borrower[fields.currentAddress.name].years_at_address;
    return state;
  },

  buildLoanFromState: function() {
    var loan = {};
    loan.borrower_attributes = {id: this.props.loan.borrower.id};
    loan.borrower_attributes[fields.firstName.name] = this.state[fields.firstName.name];
    loan.borrower_attributes[fields.middleName.name] = this.state[fields.middleName.name];
    loan.borrower_attributes[fields.lastName.name] = this.state[fields.lastName.name];
    loan.borrower_attributes[fields.suffix.name] = this.state[fields.suffix.name];
    loan.borrower_attributes[fields.dob.name] = this.state[fields.dob.name];
    loan.borrower_attributes[fields.ssn.name] = this.state[fields.ssn.name];
    loan.borrower_attributes[fields.phone.name] = this.state[fields.phone.name];
    loan.borrower_attributes[fields.yearsInSchool.name] = this.state[fields.yearsInSchool.name];
    loan.borrower_attributes[fields.maritalStatus.name] = this.state[fields.maritalStatus.name];
    loan.borrower_attributes[fields.numberOfDependents.name] = this.state[fields.numberOfDependents.name];
    loan.borrower_attributes[fields.dependentAges.name] = _.map(this.state[fields.dependentAges.name].split(','), _.trim);
    loan.borrower_attributes.borrower_addresses_attributes = [{
      id: this.props.loan.borrower.current_address.id,
      is_rental: !this.state[fields.currentlyOwn.name],
      years_at_address: this.state[fields.yearsInCurrentAddress.name],
      address_attributes: this.state[fields.currentAddress.name],
      is_current: true
    }];

    if (this.state[fields.applyingAs.name] == 1) {
      loan.pending_secondary_borrower_attributes = {
        _destroy: true
      };
    } else {
      loan.pending_secondary_borrower_attributes = {
        first_name: this.state[fields.coBorrowerFirstName.name],
        last_name: this.state[fields.coBorrowerSecondName.name],
        email: this.state[fields.coBorrowerEmail.name]
      };
    }

    return loan;
  },

  save: function() {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 1);
  }
});

module.exports = FormBorrower;
