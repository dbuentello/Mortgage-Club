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
  other_borrower_report: {label: 'Other', name: 'other_borrower_report', placeholder: 'drap file here or browse', type: 'OtherBorrowerReport', customDescription: true}
};

var Borrower = React.createClass({
  getInitialState: function() {
    return this.buildStateFromBorrower();
  },

  render: function() {
    var uploadUrl = '/borrower_document_uploader/upload';

    return (
      <div className='pal'>
        <div className='box mtn'>
          <div className='row'>
            {
              _.map(Object.keys(fields), function(key) {
                var customParams = [
                  {type: fields[key].type},
                  {borrower_id: this.props.borrower.id}
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
                      supportOtherDescription={fields[key].customDescription}
                    />
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
      if (this.props.borrower[key]) { // has a document
        state[fields[key].name] = this.props.borrower[key].attachment_file_name;
        state[fields[key].id] = this.props.borrower[key].id;
        state[fields[key].name + '_downloadUrl'] = '/borrower_document_uploader/' + this.props.borrower[key].id +
                                         '/download?type=' + fields[key].type;
        state[fields[key].name + '_removedUrl'] = '/borrower_document_uploader/' + this.props.borrower[key].id +
                                         '/remove?type=' + fields[key].type;
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
