var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');

var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var TextField = require('components/form/TextField');
var Dropzone = require('components/form/Dropzone');

var fields = {
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

var uploader_fields = {
  first_w2: {label: 'W2 - Most recent tax year', name: 'first_w2', placeholder: 'drap file here or browse', type: 'FirstW2'},
  second_w2: {label: 'W2 - Previous tax year', name: 'second_w2', placeholder: 'drap file here or browse', type: 'SecondW2'},
  first_paystub: {label: "Paystub - Most recent month", name: 'first_paystub', placeholder: 'drap file here or browse', type: 'FirstPaystub'},
  second_paystub: {label: 'Paystub - Previous month', name: 'second_paystub', placeholder: 'drap file here or browse', type: 'SecondPaystub'},
  first_bank_statement: {label: 'Bank statement - Most recent month', name: 'first_bank_statement', placeholder: 'drap file here or browse', type: 'FirstBankStatement'},
  second_bank_statement: {label: 'Bank statement - Previous month', name: 'second_bank_statement', placeholder: 'drap file here or browse', type: 'SecondBankStatement'}
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
    var uploadUrl = '/borrower_uploader/upload';

    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mtn'>
              <div className='row'>
                {
                  _.map(Object.keys(uploader_fields), function(key) {
                    var customParams = [
                      {type: uploader_fields[key].type},
                      {borrower_id: this.props.loan.borrower.id}
                    ];

                    return(
                      <div className="drop_zone" key={key}>
                        <Dropzone field={uploader_fields[key]}
                          uploadUrl={uploadUrl}
                          downloadUrl={this.state[uploader_fields[key].name + '_downloadUrl']}
                          removeUrl={this.state[uploader_fields[key].name + '_removedUrl']}
                          tip={this.state[uploader_fields[key].name]}
                          maxSize={10000000}
                          customParams={customParams}
                          supportOtherDescription={uploader_fields[key].customDescription}
                        />
                      </div>
                    )
                  }, this)
                }
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

    _.map(Object.keys(uploader_fields), function(key) {
      if (borrower[key]) { // has a document
        state[uploader_fields[key].name] = borrower[key].attachment_file_name;
        state[uploader_fields[key].id] = borrower[key].id;
        state[uploader_fields[key].name + '_downloadUrl'] = '/borrower_uploader/' + borrower[key].id +
                                         '/download?type=' + uploader_fields[key].type;
        state[uploader_fields[key].name + '_removedUrl'] = '/borrower_uploader/remove?type=' +
                                         uploader_fields[key].type + '&borrower_id=' + borrower.id;
      }else {
        state[uploader_fields[key].name] = uploader_fields[key].placeholder;
        state[uploader_fields[key].name + '_downloadUrl'] = 'javascript:void(0)';
        state[uploader_fields[key].name + '_removedUrl'] = 'javascript:void(0)';
      }
    }, this);

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
