var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');

var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var TextField = require('components/form/TextField');
var Dropzone = require('components/form/Dropzone');
var SelectField = require('components/form/SelectField');
var OtherIncome = require('./OtherIncome');

var fields = {
  employerName: {label: 'Name of current employer', name: 'employer_name', helpText: 'I am a helpful text.'},
  employerAddress: {label: 'Address of current employer', name: 'address', helpText: null},
  jobTitle: {label: 'Job Title', name: 'job_title', helpText: null},
  monthsAtEmployer: {label: 'Years at this employer', name: 'duration', helpText: null},
  employerContactName: {label: 'Contact Name', name: 'employer_contact_name', helpText: null},
  employerContactNumber: {label: 'Contact Phone Number', name: 'employer_contact_number', helpText: null},
  baseIncome: {label: 'Base Income', name: 'current_salary', helpText: null},
  grossOvertime: {label: 'Annual Gross Overtime', name: 'gross_overtime', helpText: null},
  grossBonus: {label: 'Annual Gross Bonus', name: 'gross_bonus', helpText: null},
  grossCommission: {label: 'Annual Gross Commission', name: 'gross_commission', helpText: null},
  incomeFrequency: {label: 'Income frequency', name: 'pay_frequency', helpText: null}
};

var uploader_fields = {
  first_w2: {label: 'W2 - Most recent tax year', name: 'first_w2', placeholder: 'drap file here or browse', type: 'FirstW2'},
  second_w2: {label: 'W2 - Previous tax year', name: 'second_w2', placeholder: 'drap file here or browse', type: 'SecondW2'},
  first_paystub: {label: "Paystub - Most recent period", name: 'first_paystub', placeholder: 'drap file here or browse', type: 'FirstPaystub'},
  second_paystub: {label: 'Paystub - Previous period', name: 'second_paystub', placeholder: 'drap file here or browse', type: 'SecondPaystub'},
  first_bank_statement: {label: 'Bank statement - Most recent month', name: 'first_bank_statement', placeholder: 'drap file here or browse', type: 'FirstBankStatement'},
  second_bank_statement: {label: 'Bank statement - Previous month', name: 'second_bank_statement', placeholder: 'drap file here or browse', type: 'SecondBankStatement'}
};

var incomeFrequencies = [
  {value: 'semimonthly', name: 'Semi-monthly'},
  {value: 'biweekly', name: 'Bi-weekly'},
  {value: 'weekly', name: 'Weekly'}
];

var FormIncome = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    return this.buildStateFromLoan(this.props.loan);
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

  onDrop: function(files, field) {
    this.refresh();
  },

  refresh: function() {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 2, true);
  },

  eachOtherIncome: function(income, index) {
    return (
      <OtherIncome key={index} index={index} income={income}  onRemove={this.removeOtherIncome} />
    );
  },

  afterUploadingDocument: function() {
    if (this.props.loan.borrower.current_employment) {
      setTimeout(_.bind(this.updateEmploymentData), 10000);
    }
  },

  updateEmploymentData: function() {
    var employment_id = this.props.loan.borrower.current_employment.id;

    $.ajax({
      url: "/employments/" + employment_id,
      method: "GET",
      success: function(response) {
        var employment = response.employment;
        var state = {};
        state[fields.employerName.name] = employment[fields.employerName.name];
        state[fields.employerAddress.name] = employment[fields.employerAddress.name];
        state[fields.baseIncome.name] = this.formatCurrency(employment[fields.baseIncome.name]);
        state[fields.incomeFrequency.name] = employment[fields.incomeFrequency.name];
        this.setState(state);
      }.bind(this)
    });
  },

  render: function() {
    var uploadUrl = '/document_uploaders/borrowers/upload';

    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mtn'>
              <div className='row'>
                <p style={{fontSize: 15}}>At the minimum, we’d need these documents before we can lock-in your mortgage rate. Please upload them now so our proprietary technology can try to extract the data and save you some time inputting it.</p>
              </div>
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
                          uploadSuccessCallback={this.afterUploadingDocument}/>
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
                  <TextField
                    label={fields.employerAddress.label}
                    keyName={fields.employerAddress.name}
                    value={this.state[fields.employerAddress.name].full_text}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.employerAddress)}
                    onChange={this.onChange}/>

                  {/* <AddressField
                    label={fields.employerAddress.label}
                    address={this.state[fields.employerAddress.name]}
                    keyName={fields.employerAddress.name}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.employerAddress)}
                    onChange={this.onChange}
                    placeholder='Please enter the address of the employer'/> */}
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
                    label={fields.baseIncome.label}
                    keyName={fields.baseIncome.name}
                    value={this.state[fields.baseIncome.name]}
                    liveFormat={true}
                    format={this.formatCurrency}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.baseIncome)}
                    onChange={this.onChange}
                    placeholder='e.g. 99,000'/>
                </div>

                <div className='col-sm-6'>
                  <SelectField
                    label={fields.incomeFrequency.label}
                    keyName={fields.incomeFrequency.name}
                    value={this.state[fields.incomeFrequency.name]}
                    options={incomeFrequencies}
                    editable={true}
                    onChange={this.onChange}
                    onFocus={this.onFocus.bind(this, fields.incomeFrequency)}
                    allowBlank={true}/>
                </div>
              </div>

              {this.state.otherIncomes.map(this.eachOtherIncome)}

              <div className='row'>
                <div className='box col-md-6'>
                  <a className="clickable" onClick={this.addOtherIncome}>
                    Add other income
                  </a>
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
    state[fields.baseIncome.name] = this.formatCurrency(currentEmployment[fields.baseIncome.name]);
    state[fields.incomeFrequency.name] = currentEmployment[fields.incomeFrequency.name];

    state[fields.grossOvertime.name] = this.formatCurrency(borrower[fields.grossOvertime.name]);
    state[fields.grossBonus.name] = this.formatCurrency(borrower[fields.grossBonus.name]);
    state[fields.grossCommission.name] = this.formatCurrency(borrower[fields.grossCommission.name]);

    if (!state[fields.employerAddress.name]) {
      state[fields.employerAddress.name] = {full_text: ''};
    }
    _.map(Object.keys(uploader_fields), function(key) {
      if (borrower[key]) { // has a document
        state[uploader_fields[key].name] = borrower[key].original_filename;
        state[uploader_fields[key].id] = borrower[key].id;
        state[uploader_fields[key].name + '_downloadUrl'] = '/document_uploaders/base_document/' + borrower[key].id +
                                         '/download?type=' + uploader_fields[key].type;
        state[uploader_fields[key].name + '_removedUrl'] = '/document_uploaders/base_document/' + borrower[key].id +
                                         '/remove?type=' + uploader_fields[key].type;
      }else {
        state[uploader_fields[key].name] = uploader_fields[key].placeholder;
        state[uploader_fields[key].name + '_downloadUrl'] = 'javascript:void(0)';
        state[uploader_fields[key].name + '_removedUrl'] = 'javascript:void(0)';
      }
    }, this);

    state.otherIncomes = [];

    return state;
  },

  buildLoanFromState: function() {
    var loan = {};
    var currentEmployment = this.props.loan.borrower.current_employment;

    loan.borrower_attributes = {id: this.props.loan.borrower.id};
    loan.borrower_attributes[fields.grossOvertime.name] = this.currencyToNumber(this.state[fields.grossOvertime.name]);
    loan.borrower_attributes[fields.grossBonus.name] = this.currencyToNumber(this.state[fields.grossBonus.name]);
    loan.borrower_attributes[fields.grossCommission.name] = this.currencyToNumber(this.state[fields.grossCommission.name]);

    loan.borrower_attributes.employments_attributes = [{
      id: currentEmployment ? currentEmployment.id : null,
      employer_name: this.state[fields.employerName.name],
      address_attributes: { 'full_text': this.state[fields.employerAddress.name]},
      job_title: this.state[fields.jobTitle.name],
      duration: this.state[fields.monthsAtEmployer.name],
      employer_contact_name: this.state[fields.employerContactName.name],
      employer_contact_number: this.state[fields.employerContactNumber.name],
      pay_frequency: this.state[fields.incomeFrequency.name],
      current_salary: this.currencyToNumber(this.state[fields.baseIncome.name]),
      is_current: true
    }];

    return loan;
  },

  getDefaultOtherIncomes: function() {
    return [{
      type: null,
      amount: null
    }];
  },

  addOtherIncome: function() {
    this.setState({otherIncomes: this.state.otherIncomes.concat(this.getDefaultOtherIncomes())});
  },

  removeOtherIncome: function(index) {
    var arr = this.state.otherIncomes;
    arr.splice(index, 1);
    this.setState({otherIncomes: arr});
  },

  save: function() {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 2);
  }
});

module.exports = FormIncome;