var _ = require('lodash');
var React = require('react/addons');
var Dropzone = require('components/form/AdminDropzone');

var BorrowerUpload = React.createClass({
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

    if(this.props.otherBorrowerFields !== undefined && this.props.otherBorrowerFields !== null){
      _.map(Object.keys(this.props.otherBorrowerFields), function(key) {
        state[this.props.otherBorrowerFields[key].name] = this.props.otherBorrowerFields[key].placeholder;
        state[this.props.otherBorrowerFields[key].name + '_downloadUrl'] = 'javascript:void(0)';
        state[this.props.otherBorrowerFields[key].name + '_removedUrl'] = 'javascript:void(0)';
      }, this);
    }

    if(this.props.subject.other_documents !== undefined && this.props.subject.other_documents !== null){
      state.otherBorrowerDocuments = this.props.subject.other_documents;

      _.each(state.otherBorrowerDocuments, function(borrowerDocument) {
        borrowerDocument.downloadUrl = "/document_uploaders/base_document/" + borrowerDocument.id + "/download";
        borrowerDocument.removeUrl = "/document_uploaders/base_document/" + borrowerDocument.id;
      }, this);
    }
    return state;
  },

  getDefaultProps: function() {
    return {
      otherBorrowerFields: {}
    };
  },

  reloadOtherDocuments: function(){
    $.ajax({
      url: "/loan_members/borrower_documents/get_other_documents",
      method: "GET",
      context: this,
      dataType: "json",
      data: {
        id: this.props.subject.id
      },
      success: function(response) {
        if(response.borrower_documents !== undefined && response.borrower_documents !== null) {
          var state = this.state;
          state.otherBorrowerDocuments = response.borrower_documents;
          this.setState(state);
        }
      }.bind(this)
    });
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
        {
          _.map(this.state.otherBorrowerDocuments, function(borrowerDocument, index) {
            var customParams = [
              {document_type: "other_borrower_report"},
              {subject_id: this.props.subject.id},
              {subject_type: this.props.subjectType},
              {description: borrowerDocument.description},
              {document_id: borrowerDocument.id}
            ];
            var field = {label: borrowerDocument.description, placeholder: "Drop files to upload or CLICK"};
            return(
              <div className="drop_zone" style={{"margin-top": "10px"}} key={index}>
                <Dropzone
                  field={field}
                  uploadUrl={uploadUrl}
                  downloadUrl={borrowerDocument.downloadUrl}
                  removeUrl={borrowerDocument.removeUrl}
                  tip={borrowerDocument.attachment_file_name}
                  maxSize={10000000}
                  customParams={customParams}
                  supportOtherDescription={false}
                  uploadSuccessCallback={this.reloadOtherDocuments}
                  removeSuccessCallback={this.reloadOtherDocuments}/>
              </div>
            )
          }, this)
        }
        {
          _.map(Object.keys(this.props.otherBorrowerFields), function(key) {
            var customParams = [
              {document_type: key},
              {subject_id: this.props.subject.id},
              {subject_type: this.props.subjectType},
              {description: this.props.otherBorrowerFields[key].label}
            ];
            return(
              <div className="drop_zone" style={{"margin-top": "10px"}} key={key}>
                <Dropzone field={this.props.otherBorrowerFields[key]}
                  uploadUrl={uploadUrl}
                  downloadUrl={this.state[this.props.otherBorrowerFields[key].name + '_downloadUrl']}
                  removeUrl={this.state[this.props.otherBorrowerFields[key].name + '_removedUrl']}
                  tip={this.state[this.props.otherBorrowerFields[key].name]}
                  maxSize={10000000}
                  customParams={customParams}
                  isOther={this.props.otherBorrowerFields[key].isOther}
                  supportOtherDescription={this.props.otherBorrowerFields[key].customDescription}
                  uploadSuccessCallback={this.reloadOtherDocuments}/>
              </div>
            )
          }, this)
        }
      </div>
    );
  },
});

module.exports = BorrowerUpload;
