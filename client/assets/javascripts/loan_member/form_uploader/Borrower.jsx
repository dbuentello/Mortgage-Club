var _ = require('lodash');
var React = require('react/addons');

var Dropzone = require('components/form/Dropzone');

var fields = {
  first_w2: {label: 'W2 - Most recent tax year', name: 'first_w2', placeholder: 'drap file here or browse', type: 'FirstW2'},
  second_w2: {label: 'W2 - Previous tax year', name: 'second_w2', placeholder: 'drap file here or browse', type: 'SecondW2'},
  first_paystub: {label: "Paystub - Most recent month", name: 'first_paystub', placeholder: 'drap file here or browse', type: 'FirstPaystub'},
  second_paystub: {label: 'Paystub - Previous month', name: 'second_paystub', placeholder: 'drap file here or browse', type: 'SecondPaystub'},
  first_bank_statement: {label: 'Bank statement - Most recent month', name: 'first_bank_statement', placeholder: 'drap file here or browse', type: 'FirstBankStatement'},
  second_bank_statement: {label: 'Bank statement - Previous month', name: 'second_bank_statement', placeholder: 'drap file here or browse', type: 'SecondBankStatement'},

  first_personal_tax_return: {label: 'Personal tax return - Most recent year', name: 'first_personal_tax_return', placeholder: 'drap file here or browse', type: 'FirstPersonalTaxReturn'},
  second_personal_tax_return: {label: 'Personal tax return - Previous year', name: 'second_personal_tax_return', placeholder: 'drap file here or browse', type: 'SecondPersonalTaxReturn'},
  first_business_tax_return: {label: 'Business tax return - Most recent year', name: 'first_business_tax_return', placeholder: 'drap file here or browse', type: 'FirstBusinessTaxReturn'},
  second_business_tax_return: {label: 'Business tax return - Previous year', name: 'second_business_tax_return', placeholder: 'drap file here or browse', type: 'SecondBusinessTaxReturn'},
  first_federal_tax_return: {label: 'Federal tax return - Most recent year', name: 'first_federal_tax_return', placeholder: 'drap file here or browse', type: 'FirstFederalTaxReturn'},
  second_federal_tax_return: {label: 'Federal tax return - Previous year', name: 'second_federal_tax_return', placeholder: 'drap file here or browse', type: 'SecondFederalTaxReturn'},
  other_borrower_report: {label: 'Other', name: 'other_borrower_report', placeholder: 'drap file here or browse', type: 'OtherBorrowerReport', customDescription: true}
};

var Borrower = React.createClass({
  getInitialState: function() {
    return this.buildStateFromBorrower();
  },

  render: function() {
    var uploadUrl = '/document_uploaders/base_document/upload';

    return (
      <div className='pal'>
        <div className='box mtn'>
          <div className='row'>
            {
              _.map(Object.keys(fields), function(key) {
                var customParams = [
                  {document_type: key},
                  {subject_id: this.props.borrower.id},
                  {subject_type: "Borrower"},
                  {description: fields[key].label}
                ];
                return(
                  <div className="drop_zone" key={key}>
                    <Dropzone field={fields[key]}
                      uploadUrl={uploadUrl}
                      downloadUrl={this.state[fields[key].name + '_downloadUrl']}
                      removeUrl={this.state[fields[key].name + '_removedUrl']}
                      tip={this.state[fields[key].name]}
                      maxSize={10000000}
                      customParams={customParams}
                      supportOtherDescription={fields[key].customDescription}/>
                  </div>
                )
              }, this)
            }
          </div>
        </div>
      </div>
    );
  },

  buildStateFromBorrower: function() {
    var state = {};
    _.map(Object.keys(fields), function(key) {
      var borrower_document = _.find(this.props.borrower.documents, { 'document_type': key });
      if (borrower_document) {
        state[fields[key].name] = borrower_document.original_filename;
        state[fields[key].id] = borrower_document.id;
        state[fields[key].name + '_downloadUrl'] = '/document_uploaders/base_document/' + borrower_document.id + '/download';
        state[fields[key].name + '_removedUrl'] = '/document_uploaders/base_document/' + borrower_document.id + '/remove';
      }else {
        state[fields[key].name] = fields[key].placeholder;
        state[fields[key].name + '_downloadUrl'] = 'javascript:void(0)';
        state[fields[key].name + '_removedUrl'] = 'javascript:void(0)';
      }
    }, this);
    return state;
  },
});

module.exports = Borrower;
