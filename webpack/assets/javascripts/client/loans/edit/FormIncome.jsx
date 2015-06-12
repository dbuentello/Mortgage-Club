var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');

var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var Dropzone = require('components/form/Dropzone');

var fields = {
  firstW2: {label: 'W2 - Most recent tax year', name:  'first_paystub', placeholder: 'drap file here or browse', helpText: 'Document uploader.'},
  secondW2: {label: 'W2 - Previous tax year', name:  'first_paystub', placeholder: 'drap file here or browse', helpText: 'Document uploader.'},
  firstPaystub: {label: 'Paystub - Most recent month', name:  'first_paystub', placeholder: 'drap file here or browse', helpText: 'Document uploader.'},
  secondPaystub: {label: 'Paystub - Previous month', name:  'first_paystub', placeholder: 'drap file here or browse', helpText: 'Document uploader.'},
  firstBankStatement: {label: 'Bank statement - Most recent month', name:  'first_bank_statement', placeholder: 'drap file here or browse', helpText: 'Document uploader.'},
  secondBankStatement: {label: 'Bank statement - Previous month', name:  'second_bank_statement', placeholder: 'drap file here or browse', helpText: 'Document uploader.'},

  employerName: {label: 'Name of current employer', name: 'employer_name', helpText: 'I am a helpful text.'},
  employerAddress: {label: 'Address of current employer', name: 'address', helpText: null},
  jobTitle: {label: 'Job Title', name: 'job_title', helpText: null},
  monthsAtEmployer: {label: 'Months at this employer', name: 'duration', helpText: null},
  employerContactName: {label: 'Contact Name', name: 'employer_contact_name', helpText: null},
  employerContactNumber: {label: 'Contact Phone Number', name: 'employer_contact_number', helpText: null},
  grossIncome: {label: 'Annual Gross Income', name: 'gross_income', helpText: null},
  grossOvertime: {label: 'Annual Gross Overtime', name: 'gross_overtime', helpText: null},
  grossBonus: {label: 'Annual Gross Bonus', name: 'gross_bonus', helpText: null},
  grossCommission: {label: 'Annual Gross Commission', name: 'gross_commission', helpText: null}
};

var FormIncome = React.createClass({
  mixins: [TextFormatMixin],
  getInitialState: function() {
    return this.buildStateFromLoan(this.props.loan);
  },

  onChange: function(change) {
    this.setState(change);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  onDrop: function (files) {
    console.log('Received files: ', files[0].size);
    var valueName = fields.firstBankStatement.name;

    console.log('valueName: ', valueName);
    this.setState({
      first_bank_statement: files[0].name
    });

    console.log('this.state[fields.firstBankStatement.name] ', this.state);
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

    var dropzoneStyle = {};

    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mtn'>
              <div className='row'>
                <label className='col-xs-6'>
                  <span className='h7 typeBold'>{fields.firstW2.label}</span>
                </label>
                <div className='col-xs-6'>
                  <div>
                    <Dropzone onDrop={this.onDrop} style={dropzoneStyle}>
                      <div className='tip'>{this.state[fields.firstW2.name]}</div>
                    </Dropzone>
                  </div>
                </div>

                <label className='col-xs-6'>
                  <span className='h7 typeBold'>{fields.secondW2.label}</span>
                </label>
                <div className='col-xs-6'>
                  <div>
                    <Dropzone onDrop={this.onDrop} style={dropzoneStyle}>
                      <div className='tip'>{this.state[fields.secondW2.name]}</div>
                    </Dropzone>
                  </div>
                </div>

                <label className='col-xs-6'>
                  <span className='h7 typeBold'>{fields.firstPaystub.label}</span>
                </label>
                <div className='col-xs-6'>
                  <div>
                    <Dropzone onDrop={this.onDrop} style={dropzoneStyle}>
                      <div className='tip'>{this.state[fields.firstPaystub.name]}</div>
                    </Dropzone>
                  </div>
                </div>

                <label className='col-xs-6'>
                  <span className='h7 typeBold'>{fields.secondPaystub.label}</span>
                </label>
                <div className='col-xs-6'>
                  <div>
                    <Dropzone onDrop={this.onDrop} style={dropzoneStyle}>
                      <div className='tip'>{this.state[fields.secondPaystub.name]}</div>
                    </Dropzone>
                  </div>
                </div>

                <label className='col-xs-6'>
                  <span className='h7 typeBold'>{fields.firstBankStatement.label}</span>
                </label>
                <div className='col-xs-6'>
                  <div>
                    <Dropzone onDrop={this.onDrop} style={dropzoneStyle}>
                      <div className='tip'>{this.state[fields.firstBankStatement.name]}</div>
                    </Dropzone>
                  </div>
                </div>

                <label className='col-xs-6'>
                  <span className='h7 typeBold'>{fields.secondBankStatement.label}</span>
                </label>
                <div className='col-xs-6'>
                  <div>
                    <Dropzone onDrop={this.onDrop} style={dropzoneStyle}>
                      <div className='tip'>{this.state[fields.secondBankStatement.name]}</div>
                    </Dropzone>
                  </div>
                </div>
              </div>

              <div className='row'>
                <div className='col-sm-6'>
                  <TextField
                    label={fields.employerName.label}
                    keyName={fields.employerName.name}
                    value={this.state[fields.employerName.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.employerName)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-sm-6'>
                  <AddressField
                    label={fields.employerAddress.label}
                    address={this.state[fields.employerAddress.name]}
                    keyName={fields.employerAddress.name}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.employerAddress)}
                    onChange={this.onChange}
                    placeholder='Please enter the address of the employer'/>
                </div>
              </div>

              <div className='row'>
                <div className='col-sm-6'>
                  <TextField
                    label={fields.jobTitle.label}
                    keyName={fields.jobTitle.name}
                    value={this.state[fields.jobTitle.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.jobTitle)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-sm-6'>
                  <TextField
                    label={fields.monthsAtEmployer.label}
                    keyName={fields.monthsAtEmployer.name}
                    value={this.state[fields.monthsAtEmployer.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.monthsAtEmployer)}
                    onChange={this.onChange}/>
                </div>
              </div>
              <div className='h5 typeDeemphasize'>Best contact to confirm employment:</div>
              <div className='row'>
                <div className='col-sm-6'>
                  <TextField
                    label={fields.employerContactName.label}
                    keyName={fields.employerContactName.name}
                    value={this.state[fields.employerContactName.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.employerContactName)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-sm-6'>
                  <TextField
                    label={fields.employerContactNumber.label}
                    keyName={fields.employerContactNumber.name}
                    value={this.state[fields.employerContactNumber.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.employerContactNumber)}
                    onChange={this.onChange}/>
                </div>
              </div>

              <div className='h5 typeDeemphasize'>Income details:</div>
              <div className='row'>
                <div className='col-sm-6'>
                  <TextField
                    label={fields.grossIncome.label}
                    keyName={fields.grossIncome.name}
                    value={this.state[fields.grossIncome.name]}
                    liveFormat={true}
                    format={this.formatCurrency}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.grossIncome)}
                    onChange={this.onChange}
                    placeholder='e.g. 99,000'/>
                </div>
                <div className='col-sm-6'>
                  <TextField
                    label={fields.grossOvertime.label}
                    keyName={fields.grossOvertime.name}
                    value={this.state[fields.grossOvertime.name]}
                    liveFormat={true}
                    format={this.formatCurrency}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.grossOvertime)}
                    onChange={this.onChange}
                    placeholder='e.g. 99,000'/>
                </div>
              </div>
              <div className='row'>
                <div className='col-sm-6'>
                  <TextField
                    label={fields.grossBonus.label}
                    keyName={fields.grossBonus.name}
                    value={this.state[fields.grossBonus.name]}
                    liveFormat={true}
                    format={this.formatCurrency}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.grossBonus)}
                    onChange={this.onChange}
                    placeholder='e.g. 99,000'/>
                </div>
                <div className='col-sm-6'>
                  <TextField
                    label={fields.grossCommission.label}
                    keyName={fields.grossCommission.name}
                    value={this.state[fields.grossCommission.name]}
                    liveFormat={true}
                    format={this.formatCurrency}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.grossCommission)}
                    onChange={this.onChange}
                    placeholder='e.g. 99,000'/>
                </div>
              </div>
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
    var currentEmployment = borrower.current_employment || {};

    state[fields.firstW2.name] = fields.firstW2.placeholder;
    state[fields.secondW2.name] = fields.secondW2.placeholder;
    state[fields.firstPaystub.name] = fields.firstPaystub.placeholder;
    state[fields.secondPaystub.name] = fields.secondPaystub.placeholder;
    state[fields.firstBankStatement.name] = fields.firstBankStatement.placeholder;
    state[fields.secondBankStatement.name] = fields.secondBankStatement.placeholder;

    state[fields.employerName.name] = currentEmployment[fields.employerName.name];
    state[fields.employerAddress.name] = currentEmployment[fields.employerAddress.name];
    state[fields.jobTitle.name] = currentEmployment[fields.jobTitle.name];
    state[fields.monthsAtEmployer.name] = currentEmployment[fields.monthsAtEmployer.name];
    state[fields.employerContactName.name] = currentEmployment[fields.employerContactName.name];
    state[fields.employerContactNumber.name] = currentEmployment[fields.employerContactNumber.name];

    state[fields.grossIncome.name] = this.formatCurrency(borrower[fields.grossIncome.name]);
    state[fields.grossOvertime.name] = this.formatCurrency(borrower[fields.grossOvertime.name]);
    state[fields.grossBonus.name] = this.formatCurrency(borrower[fields.grossBonus.name]);
    state[fields.grossCommission.name] = this.formatCurrency(borrower[fields.grossCommission.name]);
    return state;
  },

  buildLoanFromState: function() {
    var loan = {};
    var currentEmployment = this.props.loan.borrower.current_employment;

    loan.borrower_attributes = {id: this.props.loan.borrower.id};
    loan.borrower_attributes[fields.grossIncome.name] = this.currencyToNumber(this.state[fields.grossIncome.name]);
    loan.borrower_attributes[fields.grossOvertime.name] = this.currencyToNumber(this.state[fields.grossOvertime.name]);
    loan.borrower_attributes[fields.grossBonus.name] = this.currencyToNumber(this.state[fields.grossBonus.name]);
    loan.borrower_attributes[fields.grossCommission.name] = this.currencyToNumber(this.state[fields.grossCommission.name]);

    loan.borrower_attributes.employments_attributes = [{
      id: currentEmployment ? currentEmployment.id : null,
      employer_name: this.state[fields.employerName.name],
      address_attributes: this.state[fields.employerAddress.name],
      job_title: this.state[fields.jobTitle.name],
      duration: this.state[fields.monthsAtEmployer.name],
      employer_contact_name: this.state[fields.employerContactName.name],
      employer_contact_number: this.state[fields.employerContactNumber.name],
      is_current: true
    }];
    return loan;
  },

  save: function() {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 2);
  }
});

module.exports = FormIncome;
