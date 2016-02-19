var _ = require('lodash');
var React = require('react/addons');
var Dropzone = require('components/form/AdminDropzone');

var Upload = React.createClass({
  getInitialState: function() {
    var state = {};
    _.map(Object.keys(this.props.fields), function(key) {
      var lender_document = _.find(this.props.subject.documents, {'document_type': key});
      if (lender_document) {
        state[this.props.fields[key].name] = lender_document.original_filename;
        state[this.props.fields[key].id] = lender_document.id;
        state[this.props.fields[key].name + '_downloadUrl'] = '/document_uploaders/base_document/' + lender_document.id + '/download';
        state[this.props.fields[key].name + '_removedUrl'] = '/document_uploaders/base_document/' + lender_document.id;
      }else {
        state[this.props.fields[key].name] = this.props.fields[key].placeholder;
        state[this.props.fields[key].name + '_downloadUrl'] = 'javascript:void(0)';
        state[this.props.fields[key].name + '_removedUrl'] = 'javascript:void(0)';
      }
    }, this);
    return state;
  },

  render: function() {
    var uploadUrl = '/document_uploaders/base_document/upload';

    return (
      <div>
        {
          _.map(Object.keys(this.props.fields), function(key) {
            var customParams = [
              {document_type: key},
              {subject_id: this.props.subject.id},
              {subject_type: this.props.subjectType},
              {description: this.props.fields[key].label}
            ];
            return(
              <div className="drop_zone" style={{"margin-top": "10px"}} key={key}>
                <Dropzone field={this.props.fields[key]}
                  uploadUrl={uploadUrl}
                  downloadUrl={this.state[this.props.fields[key].name + '_downloadUrl']}
                  removeUrl={this.state[this.props.fields[key].name + '_removedUrl']}
                  tip={this.state[this.props.fields[key].name]}
                  maxSize={10000000}
                  customParams={customParams}
                  supportOtherDescription={this.props.fields[key].customDescription}/>
              </div>
            )
          }, this)
        }
      </div>
    );
  },
});

module.exports = Upload;
