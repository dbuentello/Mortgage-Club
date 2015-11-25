var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');
var Dropzone = require('components/form/Dropzone');
var SelectField = require('components/form/SelectField');

var uploader_fields = {
  first_w2: {label: 'W2 - Most recent tax year', name: 'first_w2', placeholder: 'drap file here or browse', type: 'FirstW2'},
  second_w2: {label: 'W2 - Previous tax year', name: 'second_w2', placeholder: 'drap file here or browse', type: 'SecondW2'},
  first_paystub: {label: "Paystub - Most recent period", name: 'first_paystub', placeholder: 'drap file here or browse', type: 'FirstPaystub'},
  second_paystub: {label: 'Paystub - Previous period', name: 'second_paystub', placeholder: 'drap file here or browse', type: 'SecondPaystub'},
  first_bank_statement: {label: 'Bank statement - Most recent month', name: 'first_bank_statement', placeholder: 'drap file here or browse', type: 'FirstBankStatement'},
  second_bank_statement: {label: 'Bank statement - Previous month', name: 'second_bank_statement', placeholder: 'drap file here or browse', type: 'SecondBankStatement'},


  first_personal_tax_return: {label: 'Personal tax return - Most recent year', name: 'first_personal_tax_return', placeholder: 'drap file here or browse', type: 'FirstPersonalTaxReturn'},
  second_personal_tax_return: {label: 'Personal tax return - Previous year', name: 'second_personal_tax_return', placeholder: 'drap file here or browse', type: 'SecondPersonalTaxReturn'},
  first_business_tax_return: {label: 'Business tax return - Most recent year', name: 'first_business_tax_return', placeholder: 'drap file here or browse', type: 'FirstBusinessTaxReturn'},
  second_business_tax_return: {label: 'Business tax return - Previous year', name: 'second_business_tax_return', placeholder: 'drap file here or browse', type: 'SecondBusinessTaxReturn'}
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

    _.map(Object.keys(uploader_fields), function(key) {
      if (borrower[key]) { // has a document
        state[uploader_fields[key].name] = borrower[key].original_filename;
        state[uploader_fields[key].id] = borrower[key].id;
        state[uploader_fields[key].name + '_downloadUrl'] = '/document_uploaders/base_document/' + borrower[key].id +
                                         '/download?type=' + uploader_fields[key].type;
        state[uploader_fields[key].name + '_removedUrl'] = '/document_uploaders/base_document/' + borrower[key].id +
                                         '/remove?type=' + uploader_fields[key].type;
      } else {
        state[uploader_fields[key].name] = uploader_fields[key].placeholder;
        state[uploader_fields[key].name + '_downloadUrl'] = 'javascript:void(0)';
        state[uploader_fields[key].name + '_removedUrl'] = 'javascript:void(0)';
      }
    }, this);
    return state;
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