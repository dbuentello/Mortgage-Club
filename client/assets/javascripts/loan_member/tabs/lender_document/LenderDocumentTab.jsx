var _ = require("lodash");
var React = require("react/addons");

var Dropzone = require("components/form/Dropzone");
var FlashHandler = require("mixins/FlashHandler");
var TextField = require('components/form/TextField');
var OtherDocument = require("./OtherDocument");
var TextEditor = require('components/TextEditor');

var LenderDocumentTab = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    var state = {};

    state.saving = false;
    state.can_submit = true;

    _.each(this.props.lenderTemplates, function(template) {
      var lender_document = _.find(this.props.loan.lender_documents, {"lender_template_id": template.id});
      if (lender_document) {
        state[template.id] = lender_document.id;
        state[template.id + "_name"] = lender_document.attachment_file_name;
        state[template.id + "_downloadUrl"] = "/loan_members/lender_documents/" + lender_document.id + "/download";
        state[template.id + "_removedUrl"] = "/loan_members/lender_documents/" + lender_document.id;
      }else {
        state[template.id + "_name"] = "drag file here or browse";
        state[template.id + "_downloadUrl"] = "javascript:void(0)";
        state[template.id + "_removedUrl"] = "javascript:void(0)";
      }
    }, this);

    state.other_lender_documents = [];

    if (this.props.loan.other_lender_documents.length > 0) {
      state.other_lender_documents = this.props.loan.other_lender_documents;
      _.each(state.other_lender_documents, function(lender_document) {
        lender_document.downloadUrl = "/loan_members/lender_documents/" + lender_document.id + "/download";
        lender_document.removeUrl = "/loan_members/lender_documents/" + lender_document.id;
      }, this);
    }

    state.other_lender_documents.push(this.getDefaultOtherDocument());

    return state;
  },

  onClick: function() {
    this.setState({saving: true});

    $.ajax({
      url: "/loan_members/lender_documents/submit_to_lender",
      method: "POST",
      context: this,
      dataType: "json",
      data: {
        loan_id: this.props.loan.id
      },
      success: function(response) {
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        this.setState({saving: false});
        // this.setState({can_submit: false});
      }.bind(this),
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.message };
        this.showFlashes(flash);
        this.setState({saving: false});
      }.bind(this)
    });
  },

  getDefaultOtherDocument: function() {
    return {
      otherTemplate: this.props.otherLenderTemplate,
      loanId: this.props.loan.id,
      downloadUrl: "javascript:void(0)",
      removeUrl: "javascript:void(0)",
      attachment_file_name: ""
    };
  },

  reloadOtherDocuments: function() {
    $.ajax({
      url: "/loan_members/lender_documents/get_other_documents",
      method: "GET",
      context: this,
      dataType: "json",
      data: {
        loan_id: this.props.loan.id
      },
      success: function(response) {
        if(response.lender_documents.length > 0) {
          var other_documents = response.lender_documents;
          other_documents.push(this.getDefaultOtherDocument())
          this.setState({other_lender_documents: other_documents});
        }
      }.bind(this)
    });
  },

  render: function() {
    return (
      <div className="content container backgroundBasic">
        <div className="pal">
          <div className="box mtn">
            <div className="row">
              {
                _.map(this.props.lenderTemplates, function(template) {
                  var fields = {label: template.description, name: template.name.replace(/ /g,""), placeholder: 'drag file here or browse'};
                  var customParams = [
                    {template_id: template.id},
                    {description: template.description},
                    {loan_id: this.props.loan.id}
                  ];
                  return(
                    <div className="drop_zone" key={template.id}>
                      <Dropzone field={fields}
                        uploadUrl={"/loan_members/lender_documents/"}
                        downloadUrl={this.state[template.id + "_downloadUrl"]}
                        removeUrl={this.state[template.id + "_removedUrl"]}
                        tip={this.state[template.id + "_name"]}
                        maxSize={10000000}
                        customParams={customParams}/>
                    </div>
                  )
                }, this)
              }
              {
                _.map(this.state.other_lender_documents, function(lender_document, index) {
                  return(
                    <div className="drop_zone" key={index}>
                      <OtherDocument name={lender_document.attachment_file_name}
                        label={lender_document.description}
                        otherTemplate={this.props.otherLenderTemplate}
                        loanId={this.props.loan.id}
                        downloadUrl={lender_document.downloadUrl}
                        removeUrl={lender_document.removeUrl}
                        supportOtherDescription={lender_document.description ? false : true}
                        uploadSuccessCallback={this.reloadOtherDocuments}/>
                    </div>
                  )
                }, this)
              }
            </div>
            <div className="row">
              <p> You can edit the contents of the email sent to the lender below. </p>
            </div>
            <div className="row">
              <div className="col-sm-6">
                <TextField
                  label="Subject"
                  keyName="name"
                  name="checklist[name]"
                  value={this.state.name}
                  onChange={this.onChange}
                  editable={true}/>
              </div>
            </div>
            <div className="row">
              <p>Body</p>
            </div>
            <div className="row">
              <TextEditor/>
            </div>
            <br/>
            {
              this.state.can_submit
              ?
                <div className="row">
                  <button style={{backgroundColor: "#15c0f1", color: "#FFFFFF"}} className="btn" onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? "SUBMITTING" : "SUBMIT TO LENDER" }</button>
                </div>
              :
                null
            }
          </div>
        </div>
      </div>
    );
  }
});

module.exports = LenderDocumentTab;
