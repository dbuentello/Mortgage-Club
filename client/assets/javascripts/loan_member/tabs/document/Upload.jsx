var _ = require("lodash");
var React = require("react/addons");
var Dropzone = require("components/form/AdminDropzone");

var Upload = React.createClass({
  getInitialState: function() {
    var state = {};
    _.map(Object.keys(this.props.fields), function(key) {
      var lender_document = _.find(this.props.subject.documents, {"document_type": key});
      if (lender_document) {
        state[this.props.fields[key].name] = lender_document.original_filename;
        state[this.props.fields[key].id] = lender_document.id;
        state[this.props.fields[key].name + "_downloadUrl"] = "/document_uploaders/base_document/" + lender_document.id + "/download";
        state[this.props.fields[key].name + "_removedUrl"] = "/document_uploaders/base_document/" + lender_document.id;
      }else {
        state[this.props.fields[key].name] = this.props.fields[key].placeholder;
        state[this.props.fields[key].name + "_downloadUrl"] = "javascript:void(0)";
        state[this.props.fields[key].name + "_removedUrl"] = "javascript:void(0)";
      }
    }, this);

    if(this.props.subject.other_documents !== undefined && this.props.subject.other_documents !== null){
      state.otherDocuments = this.props.subject.other_documents;

      _.each(state.otherDocuments, function(otherDocument) {
        otherDocument.downloadUrl = "/document_uploaders/base_document/" + otherDocument.id + "/download";
        otherDocument.removeUrl = "/document_uploaders/base_document/" + otherDocument.id;
      }, this);
    }
    return state;
  },

  reloadOtherDocuments: function(){
    $.ajax({
      url: "/loan_members/documents/get_other_documents",
      method: "GET",
      context: this,
      dataType: "json",
      data: {
        subject_id: this.props.subject.id,
        subject_type: this.props.subjectType,
        document_type: this.getDocumentType()
      },
      success: function(response) {
        if(response.other_documents !== undefined && response.other_documents !== null) {
          var state = this.state;
          state.otherDocuments = response.other_documents;

          _.each(state.otherDocuments, function(otherDocument) {
            otherDocument.downloadUrl = "/document_uploaders/base_document/" + otherDocument.id + "/download";
            otherDocument.removeUrl = "/document_uploaders/base_document/" + otherDocument.id;
          }, this);
          this.setState(state);
        }
      }.bind(this)
    });
  },

  getDocumentType: function(){
    switch(this.props.subjectType){
      case "Borrower":
        return "other_borrower_report";
      case "Loan":
        return "other_loan_report";
      case "Closing":
        return "other_closing_report";
      case "Property":
        return "other_property_report";
      default:
        return "";
    }
  },

  render: function() {
    var uploadUrl = "/document_uploaders/base_document/upload";
    var document_type = "";
    var customOtherParams = [
      {document_type: this.getDocumentType()},
      {subject_id: this.props.subject.id},
      {subject_type: this.props.subjectType},
      {description: "Other"}
    ];

    var otherField = {label: "Other", placeholder: "Drop files to upload or CLICK"};
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
                  downloadUrl={this.state[this.props.fields[key].name + "_downloadUrl"]}
                  removeUrl={this.state[this.props.fields[key].name + "_removedUrl"]}
                  tip={this.state[this.props.fields[key].name]}
                  maxSize={10000000}
                  customParams={customParams}
                  supportOtherDescription={this.props.fields[key].customDescription}/>
              </div>
            )
          }, this)
        }
        {
          _.map(this.state.otherDocuments, function(otherDocument, index) {
            var customParams = [
              {document_type: otherDocument.document_type},
              {subject_id: this.props.subject.id},
              {subject_type: this.props.subjectType},
              {description: otherDocument.description},
              {document_id: otherDocument.id}
            ];
            var field = {label: otherDocument.description, placeholder: "Drop files to upload or CLICK"};
            return(
              <div className="drop_zone" style={{"margin-top": "10px"}} key={index}>
                <Dropzone
                  field={field}
                  uploadUrl={uploadUrl}
                  downloadUrl={otherDocument.downloadUrl}
                  removeUrl={otherDocument.removeUrl}
                  tip={otherDocument.attachment_file_name}
                  maxSize={10000000}
                  customParams={customParams}
                  supportOtherDescription={false}
                  uploadSuccessCallback={this.reloadOtherDocuments}
                  removeSuccessCallback={this.reloadOtherDocuments}/>
              </div>
            )
          }, this)
        }

        <div className="drop_zone" style={{"margin-top": "10px"}} key={"other_document"}>
          <Dropzone field={otherField}
            uploadUrl={uploadUrl}
            downloadUrl={"javascript:void(0)"}
            removeUrl={"javascript:void(0)"}
            maxSize={10000000}
            customParams={customOtherParams}
            supportOtherDescription={true}
            uploadSuccessCallback={this.reloadOtherDocuments}
            resetAfterUploading={true}/>
        </div>
      </div>
    );
  },
});

module.exports = Upload;
