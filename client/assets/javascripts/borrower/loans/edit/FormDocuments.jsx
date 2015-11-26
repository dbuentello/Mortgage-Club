var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');
var Dropzone = require('components/form/Dropzone');
var SelectField = require('components/form/SelectField');

var owner_upload_fields = {
  first_personal_tax_return: {label: 'Personal tax return - Most recent year', name: 'first_personal_tax_return', placeholder: 'drap file here or browse', type: 'FirstPersonalTaxReturn'},
  second_personal_tax_return: {label: 'Personal tax return - Previous year', name: 'second_personal_tax_return', placeholder: 'drap file here or browse', type: 'SecondPersonalTaxReturn'},
  first_business_tax_return: {label: 'Business tax return - Most recent year', name: 'first_business_tax_return', placeholder: 'drap file here or browse', type: 'FirstBusinessTaxReturn'},
  second_business_tax_return: {label: 'Business tax return - Previous year', name: 'second_business_tax_return', placeholder: 'drap file here or browse', type: 'SecondBusinessTaxReturn'},
  first_w2: {label: 'W2 - Most recent tax year', name: 'first_w2', placeholder: 'drap file here or browse', type: 'FirstW2'},
  second_w2: {label: 'W2 - Previous tax year', name: 'second_w2', placeholder: 'drap file here or browse', type: 'SecondW2'},
  first_paystub: {label: "Paystub - Most recent period", name: 'first_paystub', placeholder: 'drap file here or browse', type: 'FirstPaystub'},
  second_paystub: {label: 'Paystub - Previous period', name: 'second_paystub', placeholder: 'drap file here or browse', type: 'SecondPaystub'},
  first_federal_tax_return: {label: 'Federal tax return - Most recent year', name: 'first_federal_tax_return', placeholder: 'drap file here or browse', type: 'FirstFederalTaxReturn'},
  second_federal_tax_return: {label: 'Federal tax return - Previous year', name: 'second_federal_tax_return', placeholder: 'drap file here or browse', type: 'SecondFederalTaxReturn'},
  first_bank_statement: {label: 'Bank statement - Most recent month', name: 'first_bank_statement', placeholder: 'drap file here or browse', type: 'FirstBankStatement'},
  second_bank_statement: {label: 'Bank statement - Previous month', name: 'second_bank_statement', placeholder: 'drap file here or browse', type: 'SecondBankStatement'}
};

var co_borrower_upload_fields = {
  first_personal_tax_return: {label: 'Personal tax return - Most recent year', name: 'co_first_personal_tax_return', placeholder: 'drap file here or browse', type: 'FirstPersonalTaxReturn'},
  second_personal_tax_return: {label: 'Personal tax return - Previous year', name: 'co_second_personal_tax_return', placeholder: 'drap file here or browse', type: 'SecondPersonalTaxReturn'},
  first_business_tax_return: {label: 'Business tax return - Most recent year', name: 'co_first_business_tax_return', placeholder: 'drap file here or browse', type: 'FirstBusinessTaxReturn'},
  second_business_tax_return: {label: 'Business tax return - Previous year', name: 'co_second_business_tax_return', placeholder: 'drap file here or browse', type: 'SecondBusinessTaxReturn'},
  first_w2: {label: 'W2 - Most recent tax year', name: 'co_first_w2', placeholder: 'drap file here or browse', type: 'FirstW2'},
  second_w2: {label: 'W2 - Previous tax year', name: 'co_second_w2', placeholder: 'drap file here or browse', type: 'SecondW2'},
  first_paystub: {label: "Paystub - Most recent period", name: 'co_first_paystub', placeholder: 'drap file here or browse', type: 'FirstPaystub'},
  second_paystub: {label: 'Paystub - Previous period', name: 'co_second_paystub', placeholder: 'drap file here or browse', type: 'SecondPaystub'},
  first_federal_tax_return: {label: 'Federal tax return - Most recent year', name: 'co_first_federal_tax_return', placeholder: 'drap file here or browse', type: 'FirstFederalTaxReturn'},
  second_federal_tax_return: {label: 'Federal tax return - Previous year', name: 'co_second_federal_tax_return', placeholder: 'drap file here or browse', type: 'SecondFederalTaxReturn'},
  first_bank_statement: {label: 'Bank statement - Most recent month', name: 'co_first_bank_statement', placeholder: 'drap file here or browse', type: 'FirstBankStatement'},
  second_bank_statement: {label: 'Bank statement - Previous month', name: 'co_second_bank_statement', placeholder: 'drap file here or browse', type: 'SecondBankStatement'}
};

var FormDocuments = React.createClass({
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

  render: function() {
    var uploadUrl = '/document_uploaders/borrowers/upload';
    var borrower = this.props.loan.borrower;
    var secondary_borrower = this.props.loan.secondary_borrower;
    var owner_fields = ['first_w2', 'second_w2', 'first_paystub', 'second_paystub', 'first_federal_tax_return', 'second_federal_tax_return',  'first_bank_statement', 'second_bank_statement'];
    var self_employed_fields = ['first_personal_tax_return', 'second_personal_tax_return', 'first_business_tax_return', 'second_business_tax_return', 'first_bank_statement', 'second_bank_statement'];

    var upload_fields = [];
    if (borrower.self_employed == true) {
      upload_fields = self_employed_fields;
    } else {
      upload_fields = owner_fields;
    }

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

                  _.map(Object.keys(owner_upload_fields), function(key) {
                    if (upload_fields.indexOf(key) > -1) {
                      var customParams = [
                        {type: owner_upload_fields[key].type},
                        {borrower_id: borrower.id}
                      ];
                      return(
                        <div className="drop_zone" key={key}>
                          <Dropzone field={owner_upload_fields[key]}
                            uploadUrl={uploadUrl}
                            downloadUrl={this.state[owner_upload_fields[key].name + '_downloadUrl']}
                            removeUrl={this.state[owner_upload_fields[key].name + '_removedUrl']}
                            tip={this.state[owner_upload_fields[key].name]}
                            maxSize={10000000}
                            customParams={customParams}
                            supportOtherDescription={owner_upload_fields[key].customDescription}
                            uploadSuccessCallback={this.afterUploadingDocument}/>
                        </div>
                      )
                    }
                  }, this)
                }
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

  afterUploadingDocument: function() {
  },

  componentWillReceiveProps: function(nextProps) {
    this.setState(_.extend(this.buildStateFromLoan(nextProps.loan), {
      saving: false
    }));
  },

  buildStateFromLoan: function(loan) {
    var borrower = loan.borrower;
    var secondary_borrower = loan.secondary_borrower;
    var state = {};

    this.setStateForUploadFields(borrower, state, owner_upload_fields);
    if (secondary_borrower) {
      this.setStateForUploadFields(secondary_borrower, state, co_borrower_upload_fields);
    }
    return state;
  },

  setStateForUploadFields: function(borrower, state, upload_fields) {
    _.map(Object.keys(upload_fields), function(key) {
      if (borrower[key]) { // has a document
        state[upload_fields[key].name] = borrower[key].original_filename;
        state[upload_fields[key].id] = borrower[key].id;
        state[upload_fields[key].name + '_downloadUrl'] = '/document_uploaders/base_document/' + borrower[key].id +
                                         '/download?type=' + upload_fields[key].type;
        state[upload_fields[key].name + '_removedUrl'] = '/document_uploaders/base_document/' + borrower[key].id +
                                         '/remove?type=' + upload_fields[key].type;
      } else {
        state[upload_fields[key].name] = upload_fields[key].placeholder;
        state[upload_fields[key].name + '_downloadUrl'] = 'javascript:void(0)';
        state[upload_fields[key].name + '_removedUrl'] = 'javascript:void(0)';
      }
    }, this);
  },

  buildLoanFromState: function() {
    var loan = this.props.loan;
    return loan;
  },

  save: function() {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 2);
  }
});

module.exports = FormDocuments;