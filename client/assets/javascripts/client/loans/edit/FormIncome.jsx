var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');

var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var TextField = require('components/form/TextField');
var Dropzone = require('components/form/Dropzone');

var fields = {
  firstW2: {label: 'W2 - Most recent tax year', name:  'first_w2', placeholder: 'drap file here or browse', helpText: 'Document uploader.', value: 'first_w2_value'},
  secondW2: {label: 'W2 - Previous tax year', name:  'second_w2', placeholder: 'drap file here or browse', helpText: 'Document uploader.', value: 'second_w2_value'},
  firstPaystub: {label: 'Paystub - Most recent month', name:  'first_paystub', placeholder: 'drap file here or browse', helpText: 'Document uploader.', value: 'first_paystub_value'},
  secondPaystub: {label: 'Paystub - Previous month', name:  'second_paystub', placeholder: 'drap file here or browse', helpText: 'Document uploader.', value: 'second_paystub_value'},
  firstBankStatement: {label: 'Bank statement - Most recent month', name:  'first_bank_statement', placeholder: 'drap file here or browse', helpText: 'Document uploader.', value: 'first_bank_statement_value'},
  secondBankStatement: {label: 'Bank statement - Previous month', name:  'second_bank_statement', placeholder: 'drap file here or browse', helpText: 'Document uploader.', value: 'second_bank_statement_value'},

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

  onDrop: function(files, field) {
    this.refresh();
  },

  refresh: function() {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 2, true);
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
              <div className='row'>
                <Dropzone onDrop={this.onDrop} field={fields.firstW2}
                  uploadUrl={this.state.first_w2_url}
                  downloadUrl={this.state.download_first_w2_url}
                  removeUrl={this.state.remove_first_w2_url}
                  afterRemove={this.refresh}
                  tip={this.state[fields.firstW2.name]}
                  maxSize={10000000}/>

                <Dropzone onDrop={this.onDrop} field={fields.secondW2}
                  uploadUrl={this.state.second_w2_url}
                  downloadUrl={this.state.download_second_w2_url}
                  removeUrl={this.state.remove_second_w2_url}
                  afterRemove={this.refresh}
                  tip={this.state[fields.secondW2.name]}
                  maxSize={10000000}/>

                <Dropzone onDrop={this.onDrop} field={fields.firstPaystub}
                  uploadUrl={this.state.first_paystub_url}
                  downloadUrl={this.state.download_first_paystub_url}
                  removeUrl={this.state.remove_first_paystub_url}
                  afterRemove={this.refresh}
                  tip={this.state[fields.firstPaystub.name]}
                  maxSize={10000000}/>

                <Dropzone onDrop={this.onDrop} field={fields.secondPaystub}
                  uploadUrl={this.state.second_paystub_url}
                  downloadUrl={this.state.download_second_paystub_url}
                  removeUrl={this.state.remove_second_paystub_url}
                  afterRemove={this.refresh}
                  tip={this.state[fields.secondPaystub.name]}
                  maxSize={10000000}/>

                <Dropzone onDrop={this.onDrop} field={fields.firstBankStatement}
                  uploadUrl={this.state.first_bank_statement_url}
                  downloadUrl={this.state.download_first_bank_statement_url}
                  removeUrl={this.state.remove_first_bank_statement_url}
                  afterRemove={this.refresh}
                  tip={this.state[fields.firstBankStatement.name]}
                  maxSize={10000000}/>

                <Dropzone onDrop={this.onDrop} field={fields.secondBankStatement}
                  uploadUrl={this.state.second_bank_statement_url}
                  downloadUrl={this.state.download_second_bank_statement_url}
                  removeUrl={this.state.remove_second_bank_statement_url}
                  afterRemove={this.refresh}
                  tip={this.state[fields.secondBankStatement.name]}
                  maxSize={10000000}/>
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

    state[fields.grossIncome.name] = this.formatCurrency(borrower[fields.grossIncome.name]);
    state[fields.grossOvertime.name] = this.formatCurrency(borrower[fields.grossOvertime.name]);
    state[fields.grossBonus.name] = this.formatCurrency(borrower[fields.grossBonus.name]);
    state[fields.grossCommission.name] = this.formatCurrency(borrower[fields.grossCommission.name]);

    state.first_w2_url = '/borrower_uploader/' + this.props.loan.borrower.id + '/w2?order=1';
    state.second_w2_url = '/borrower_uploader/' + this.props.loan.borrower.id + '/w2?order=2';
    state.first_paystub_url =  '/borrower_uploader/' + this.props.loan.borrower.id + '/paystub?order=1';
    state.second_paystub_url =  '/borrower_uploader/' + this.props.loan.borrower.id + '/paystub?order=2';
    state.first_bank_statement_url = '/borrower_uploader/' + this.props.loan.borrower.id + '/bank_statement?order=1';
    state.second_bank_statement_url = '/borrower_uploader/' + this.props.loan.borrower.id + '/bank_statement?order=2';

    if (this.props.loan.borrower.first_w2) {
      state[fields.firstW2.name] = this.props.loan.borrower.first_w2.attachment_file_name;
      state.remove_first_w2_url =  '/borrower_uploader/' + this.props.loan.borrower.id + '/remove_w2?order=1';
      state.download_first_w2_url =  '/borrower_uploader/' + this.props.loan.borrower.id + '/download_w2?order=1';
    } else {
      state[fields.firstW2.name] = fields.firstW2.placeholder;
      state.remove_first_w2_url = 'javascript:void(0)';
      state.download_first_w2_url = 'javascript:void(0)';
    }

    if (this.props.loan.borrower.second_w2) {
      state[fields.secondW2.name] = this.props.loan.borrower.second_w2.attachment_file_name;
      state.remove_second_w2_url =  '/borrower_uploader/' + this.props.loan.borrower.id + '/remove_w2?order=2';
      state.download_second_w2_url =  '/borrower_uploader/' + this.props.loan.borrower.id + '/download_w2?order=2';
    } else {
      state[fields.secondW2.name] = fields.secondW2.placeholder;
      state.remove_second_w2_url = 'javascript:void(0)';
      state.download_second_w2_url = 'javascript:void(0)';
    }

    if (this.props.loan.borrower.first_paystub) {
      state[fields.firstPaystub.name] = this.props.loan.borrower.first_paystub.attachment_file_name;
      state.remove_first_paystub_url = '/borrower_uploader/' + this.props.loan.borrower.id + '/remove_paystub?order=1';
      state.download_first_paystub_url = '/borrower_uploader/' + this.props.loan.borrower.id + '/download_paystub?order=1';
    } else {
      state[fields.firstPaystub.name] = fields.firstPaystub.placeholder;
      state.remove_first_paystub_url = 'javascript:void(0)';
      state.download_first_paystub_url = 'javascript:void(0)';
    }

    if (this.props.loan.borrower.second_paystub) {
      state[fields.secondPaystub.name] = this.props.loan.borrower.second_paystub.attachment_file_name;
      state.remove_second_paystub_url = '/borrower_uploader/' + this.props.loan.borrower.id + '/remove_paystub?order=2';
      state.download_second_paystub_url = '/borrower_uploader/' + this.props.loan.borrower.id + '/download_paystub?order=2';
    } else {
      state[fields.secondPaystub.name] = fields.secondPaystub.placeholder;
      state.remove_second_paystub_url = 'javascript:void(0)';
      state.download_second_paystub_url = 'javascript:void(0)';
    }

    if (this.props.loan.borrower.first_bank_statement) {
      state[fields.firstBankStatement.name] = this.props.loan.borrower.first_bank_statement.attachment_file_name;
      state.remove_first_bank_statement_url = '/borrower_uploader/' + this.props.loan.borrower.id + '/remove_bank_statement?order=1';
      state.download_first_bank_statement_url = '/borrower_uploader/' + this.props.loan.borrower.id + '/download_bank_statement?order=1';
    } else {
      state[fields.firstBankStatement.name] = fields.firstBankStatement.placeholder;
      state.remove_first_bank_statement_url = 'javascript:void(0)';
      state.download_first_bank_statement_url = 'javascript:void(0)';
    }

    if (this.props.loan.borrower.second_bank_statement) {
      state[fields.secondBankStatement.name] = this.props.loan.borrower.second_bank_statement.attachment_file_name;
      state.remove_second_bank_statement_url = '/borrower_uploader/' + this.props.loan.borrower.id + '/remove_bank_statement?order=2';
      state.download_second_bank_statement_url = '/borrower_uploader/' + this.props.loan.borrower.id + '/download_bank_statement?order=2';
    } else {
      state[fields.secondBankStatement.name] = fields.secondBankStatement.placeholder;
      state.remove_second_bank_statement_url = 'javascript:void(0)';
      state.download_second_bank_statement_url = 'javascript:void(0)';
    }

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
