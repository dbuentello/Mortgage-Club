var _ = require('lodash');
var React = require('react/addons');

var Dropzone = require('components/form/Dropzone');

var fields = {
  hud_estimate: {label: 'Estimated settlement statement', name: 'hud_estimate', placeholder: 'drap file here or browse', type: 'HudEstimate'},
  hud_final: {label: 'Final settlement statement', name: 'hud_final', placeholder: 'drap file here or browse', type: 'HudFinal'},
  loan_estimate: {label: "Loan estimate", name: 'loan_estimate', placeholder: 'drap file here or browse', type: 'LoanEstimate'},
  uniform_residential_lending_application: {label: 'Loan application form', name: 'uniform_residential_lending_application', placeholder: 'drap file here or browse', type: 'UniformResidentialLendingApplication'},
  other_loan_report: {label: 'Other', name: 'other_loan_report', placeholder: 'drap file here or browse', type: 'OtherLoanReport', customDescription: true}
};

var Loan = React.createClass({
  getInitialState: function() {
    return this.buildStateFromLoan(this.props.loan);
  },

  render: function() {
    var uploadUrl = '/loan_document_uploader/upload';

    return (
      <div className='pal'>
        <div className='box mtn'>
          <div className='row'>
            {
              _.map(Object.keys(fields), function(key) {
                var customParams = [
                  {type: fields[key].type},
                  {loan_id: this.props.loan.id}
                ];

                return (
                  <div className="drop_zone" key={key}>
                    <Dropzone field={fields[key]}
                      uploadUrl={uploadUrl}
                      downloadUrl={this.state[fields[key].name + '_downloadUrl']}
                      removeUrl={this.state[fields[key].name + '_removedUrl']}
                      tip={this.state[fields[key].name]}
                      maxSize={10000000}
                      customParams={customParams}
                      supportOtherDescription={fields[key].customDescription}
                    />
                  </div>
                )
              }, this)
            }
          </div>
        </div>
      </div>
    )
  },

  buildStateFromLoan: function(loan) {
    var state = {};
    _.map(Object.keys(fields), function(key) {
      if (this.props.loan[key]) { // has a document
        state[fields[key].name] = this.props.loan[key].attachment_file_name;
        state[fields[key].id] = this.props.loan[key].id;
        state[fields[key].name + '_downloadUrl'] = '/loan_document_uploader/' + this.props.loan[key].id +
                                         '/download?type=' + fields[key].type;
        state[fields[key].name + '_removedUrl'] = '/loan_document_uploader/' + this.props.loan[key].id +
                                         '/remove?type=' + fields[key].type;
      } else {
        state[fields[key].name] = fields[key].placeholder;
        state[fields[key].name + '_downloadUrl'] = 'javascript:void(0)';
        state[fields[key].name + '_removedUrl'] = 'javascript:void(0)';
      }
    }, this);
    return state;
  },
});

module.exports = Loan;
