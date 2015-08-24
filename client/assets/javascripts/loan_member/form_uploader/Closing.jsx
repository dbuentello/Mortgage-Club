var _ = require('lodash');
var React = require('react/addons');

var Dropzone = require('components/form/Dropzone');

var fields = {
  closing_disclosure: {label: 'Closing Disclosure', name: 'closing_disclosure', placeholder: 'drap file here or browse', type: 'ClosingDisclosure'},
  deed_of_trust: {label: 'Deed of Trust', name: 'deed_of_trust', placeholder: 'drap file here or browse', type: 'DeedOfTrust'},
  loan_doc: {label: "Loan Document", name: 'loan_doc', placeholder: 'drap file here or browse', type: 'LoanDoc'},
  other_closing_report: {label: 'Other', name: 'other_closing_report', placeholder: 'drap file here or browse', type: 'OtherClosingReport', customDescription: true}
};

var Closing = React.createClass({
  getInitialState: function() {
    return this.buildStateFromClosing(this.props.closing);
  },

  render: function() {
    var uploadUrl = '/closing_document_uploader/upload';

    return (
      <div className='pal'>
        <div className='box mtn'>
          <div className='row'>
            {
              _.map(Object.keys(fields), function(key) {
                var customParams = [
                  {type: fields[key].type},
                  {closing_id: this.props.closing.id}
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
    )
  },

  buildStateFromClosing: function(closing) {
    var state = {};
    _.map(Object.keys(fields), function(key) {
      if (this.props.closing[key]) { // has a document
        state[fields[key].name] = this.props.closing[key].attachment_file_name;
        state[fields[key].id] = this.props.closing[key].id;
        state[fields[key].name + '_downloadUrl'] = '/closing_document_uploader/' + this.props.closing[key].id +
                                         '/download?type=' + fields[key].type;
        state[fields[key].name + '_removedUrl'] = '/closing_document_uploader/' + this.props.closing[key].id +
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

module.exports = Closing;
