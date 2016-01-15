var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');
var Dropzone = require('components/form/NewDropzone');
var SelectField = require('components/form/SelectField');
var BooleanRadio = require('components/form/BooleanRadio');

var owner_upload_fields = {
  first_personal_tax_return: {label: 'Personal tax return - Most recent year', name: 'first_personal_tax_return'},
  second_personal_tax_return: {label: 'Personal tax return - Previous year', name: 'second_personal_tax_return'},
  first_business_tax_return: {label: 'Business tax return - Most recent year', name: 'first_business_tax_return'},
  second_business_tax_return: {label: 'Business tax return - Previous year', name: 'second_business_tax_return'},
  first_w2: {label: 'W2 - Most recent tax year', name: 'first_w2'},
  second_w2: {label: 'W2 - Previous tax year', name: 'second_w2'},
  first_paystub: {label: "Paystub - Most recent period", name: 'first_paystub'},
  second_paystub: {label: 'Paystub - Previous period', name: 'second_paystub'},
  first_federal_tax_return: {label: 'Federal tax return - Most recent year', name: 'first_federal_tax_return'},
  second_federal_tax_return: {label: 'Federal tax return - Previous year', name: 'second_federal_tax_return'},
  first_bank_statement: {label: 'Bank statement - Most recent month', name: 'first_bank_statement'},
  second_bank_statement: {label: 'Bank statement - Previous month', name: 'second_bank_statement'}
};

var co_borrower_upload_fields = {
  first_personal_tax_return: {label: 'Personal tax return - Most recent year', name: 'co_first_personal_tax_return'},
  second_personal_tax_return: {label: 'Personal tax return - Previous year', name: 'co_second_personal_tax_return'},
  first_business_tax_return: {label: 'Business tax return - Most recent year', name: 'co_first_business_tax_return'},
  second_business_tax_return: {label: 'Business tax return - Previous year', name: 'co_second_business_tax_return'},
  first_w2: {label: 'W2 - Most recent tax year', name: 'co_first_w2'},
  second_w2: {label: 'W2 - Previous tax year', name: 'co_second_w2'},
  first_paystub: {label: "Paystub - Most recent period", name: 'co_first_paystub'},
  second_paystub: {label: 'Paystub - Previous period', name: 'co_second_paystub'},
  first_federal_tax_return: {label: 'Federal tax return - Most recent year', name: 'co_first_federal_tax_return'},
  second_federal_tax_return: {label: 'Federal tax return - Previous year', name: 'co_second_federal_tax_return'},
  first_bank_statement: {label: 'Bank statement - Most recent month', name: 'co_first_bank_statement'},
  second_bank_statement: {label: 'Bank statement - Previous month', name: 'co_second_bank_statement'}
};

var FormDocuments = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    return this.buildStateFromLoan(this.props.loan);
  },

  onChange: function(change) {
    var key = Object.keys(change)[0];
    var value = change[key];
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
    var uploadUrl = '/document_uploaders/base_document/upload';
    var borrower = this.props.loan.borrower;
    var secondary_borrower = this.props.loan.secondary_borrower;

    var owner_fields = ['first_w2', 'second_w2', 'first_paystub', 'second_paystub', 'first_federal_tax_return', 'second_federal_tax_return',  'first_bank_statement', 'second_bank_statement'];
    var self_employed_fields = ['first_personal_tax_return', 'second_personal_tax_return', 'first_business_tax_return', 'second_business_tax_return', 'first_bank_statement', 'second_bank_statement'];

    var co_borrower_fields = ['first_w2', 'second_w2', 'first_paystub', 'second_paystub',  'first_bank_statement', 'second_bank_statement'];
    var co_borrower_no_file_taxes_jointly_fields = ['first_w2', 'second_w2', 'first_paystub', 'second_paystub', 'first_federal_tax_return', 'second_federal_tax_return',  'first_bank_statement', 'second_bank_statement'];

    var co_no_file_taxes_jointly_fields = ['first_personal_tax_return', 'second_personal_tax_return', 'first_business_tax_return', 'second_business_tax_return', 'first_bank_statement', 'second_bank_statement'];
    var co_file_taxes_jointly_fields = ['first_business_tax_return', 'second_business_tax_return', 'first_bank_statement', 'second_bank_statement'];

    var upload_fields = [];
    var co_upload_fields = [];

    if (borrower.self_employed == true) {
      upload_fields = self_employed_fields;
    } else {
      upload_fields = owner_fields;
    }
    if (secondary_borrower) {
      if (secondary_borrower.self_employed == true) {
        co_upload_fields = this.state['is_file_taxes_jointly'] == true ? co_file_taxes_jointly_fields : co_no_file_taxes_jointly_fields
      } else {
        co_upload_fields = this.state['is_file_taxes_jointly'] == true ? co_borrower_fields : co_borrower_no_file_taxes_jointly_fields
      }
    }

    return (
      <div className="col-sm-9 col-xs-12 account-content">
        <form className="form-horizontal">
          <div className='row'>
            <p className="box-description col-sm-12">
            At the minimum, we’d need these documents before we can lock-in your mortgage rate. Please upload them now so our proprietary technology can try to extract the data and save you some time inputting it.
            </p>
          </div>
          {
            _.map(Object.keys(owner_upload_fields), function(key) {
              if (upload_fields.indexOf(key) > -1) {
                var customParams = [
                  {document_type: key},
                  {subject_id: borrower.id},
                  {subject_type: "Borrower"},
                  {description: owner_upload_fields[key].label}
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
          {
            secondary_borrower
            ?
              <div className='row'>
                <div className='col-xs-12'>
                  <BooleanRadio
                    label="Do you and your co-borrower file taxes jointly?"
                    checked={this.state.is_file_taxes_jointly}
                    keyName="is_file_taxes_jointly"
                    editable={true}
                    yesLabel="Yes"
                    noLabel="No"
                    onChange={this.onChange}/>
                </div>
              </div>
            : null
          }
          {
            this.state.is_file_taxes_jointly == null
            ? null
            : <div>
                <div className='row'>
                  <p className="box-description col-sm-12">
                    Please upload the following documents for your co-borrower.
                  </p>
                </div>
                {
                  _.map(Object.keys(co_borrower_upload_fields), function(key) {
                    if (co_upload_fields.indexOf(key) > -1) {
                      var customParams = [
                        {document_type: key},
                        {subject_id: secondary_borrower.id},
                        {subject_type: "Borrower"},
                        {description: co_borrower_upload_fields[key].label}
                      ];
                      return(
                        <div className="drop_zone" key={key}>
                          <Dropzone field={co_borrower_upload_fields[key]}
                            uploadUrl={uploadUrl}
                            downloadUrl={this.state[co_borrower_upload_fields[key].name + '_downloadUrl']}
                            removeUrl={this.state[co_borrower_upload_fields[key].name + '_removedUrl']}
                            tip={this.state[co_borrower_upload_fields[key].name]}
                            maxSize={10000000}
                            customParams={customParams}
                            supportOtherDescription={co_borrower_upload_fields[key].customDescription}
                            uploadSuccessCallback={this.afterUploadingDocument}/>
                        </div>
                      )
                    }
                  }, this)
                }
              </div>
            }
          <div className='form-group'>
            <div className='col-md-12'>
              <button className="btn theBtn text-uppercase" id="continueBtn" onClick={this.save}>{ this.state.saving ? 'Saving' : 'Save and Continue' }<img src="/icons/arrowRight.png" alt="arrow"/></button>
            </div>
          </div>
        </form>
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
    state['is_file_taxes_jointly'] = loan.borrower.is_file_taxes_jointly;

    this.setStateForUploadFields(borrower, state, owner_upload_fields);
    if (secondary_borrower) {
      this.setStateForUploadFields(secondary_borrower, state, co_borrower_upload_fields);
    }
    return state;
  },

  setStateForUploadFields: function(borrower, state, upload_fields) {
    _.map(Object.keys(upload_fields), function(key) {
      var borrower_document = _.find(borrower.documents, { 'document_type': key });
      if (borrower_document){
        state[upload_fields[key].name] = borrower_document.original_filename;
        state[upload_fields[key].id] = borrower_document.id;
        state[upload_fields[key].name + '_downloadUrl'] = '/document_uploaders/base_document/' + borrower_document.id + '/download';

        state[upload_fields[key].name + '_removedUrl'] = '/document_uploaders/base_document/' + borrower_document.id;
      }
    }, this);
  },

  buildLoanFromState: function() {
    var loan = this.props.loan;
    loan.borrower_attributes = {id: this.props.loan.borrower.id};
    loan.borrower_attributes['is_file_taxes_jointly'] = this.state['is_file_taxes_jointly'];
    return loan;
  },

  save: function(event) {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 2);
    event.preventDefault();
  }
});

module.exports = FormDocuments;