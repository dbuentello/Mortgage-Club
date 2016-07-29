var React = require('react/addons');
var TextField = require('components/form/TextField');
var TextareaField = require('components/form/TextareaField');

var FlashHandler = require('mixins/FlashHandler');
var ModalLink = require('components/ModalLink');
var SelectField = require('components/form/SelectField');

var LenderDocusignForm = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    var lender = this.props.bootstrapData.lender;
    var lender_docusign_form;
    if(this.props.bootstrapData.lender_docusign_form){
      lender_docusign_form = this.props.bootstrapData.lender_docusign_form;
    }
    else {
      lender_docusign_form = {};
    }
    return {
      lender: lender,
      lender_docusign_form: lender_docusign_form,
      sign_position: lender_docusign_form.sign_position,
      description: lender_docusign_form.description,
      form_id: lender_docusign_form.form_id,
      saving: false
    }
  },

  handleSubmit: function(e) {
    e.preventDefault();
    this.setState({saving: true});

    var formData = new FormData();
    formData.append("description", this.state.description);
    formData.append("sign_position", this.state.sign_position);
    formData.append("form_id", this.state.form_id);
    if($("#uploadFile")[0].files.length >0) {
      formData.append("attachment", $("#uploadFile")[0].files[0]);
    }
    if (this.state.lender_docusign_form.id) {
      $.ajax({
        url: '/lenders/' + this.state.lender.id + '/lender_docusign_forms/' + this.state.lender_docusign_form.id,
        type: 'PUT',
        method: 'PUT',
        encType: "multipart/form-data",
        dataType: 'json',
        data: formData,
        success: function(resp) {
          location.href = '/lenders/' + resp.lender_id + '/lender_docusign_forms';
        },
        contentType: false,
        processData: false,
        async: true,
        error: function(resp) {
          var flash = { "alert-danger": resp.responseJSON.message };
          this.setState({saving: false});
        }.bind(this)
      });
    }
    else {
      $.ajax({
        url: '/lenders/' + this.state.lender.id + '/lender_docusign_forms/',
        type: 'POST',
        encType: "multipart/form-data",
        dataType: 'json',
        data: formData,
        success: function(resp) {
          location.href = '/lenders/' + resp.lender_id + '/lender_docusign_forms';
        },
        contentType: false,
        processData: false,
        async: true,
        error: function(resp) {
          var flash = { "alert-danger": resp.responseJSON.message };
          this.setState({saving: false});
        }.bind(this)
      });
    }
  },

  onChange: function(change) {
    this.setState(change);
  },

  handleRemove: function() {
    $.ajax({
      url: '/lenders/' + this.state.lender.id + '/lender_docusign_forms/' + this.state.lender_docusign_form.id,
      method: 'DELETE',
      dataType: 'json',
      contentType: 'application/json',
      success: function(resp) {
        location.href = '/lenders/' + this.state.lender.id + '/lender_docusign_forms';
      }.bind(this),
      error: function(resp) {
        var flash = { "alert-danger": resp.responseJSON.message };
        this.showFlashes(flash);
        this.setState({saving: false});
      }.bind(this)
    });
  },

  render: function() {
    return (
      <div>
        <span className="text-warning"><i> All fields are required </i></span>

      <form className="form-horizontal lender-template-form" type="json" enctype="multipart/form-data" onSubmit={this.handleSubmit}>


            <div className="form-group">
              <div className="col-sm-4">
                <TextareaField
                  label="Sign Position"
                  keyName="sign_position"
                  rows={10}
                  value={this.state.sign_position}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
            </div>

        <div className="form-group">
          <div className="col-sm-4">
            <TextField
              label="Description"
              keyName="description"
              value={this.state.description}
              editable={true}
              onChange={this.onChange}/>
          </div>
        </div>
        {this.state.lender_docusign_form.attachment_file_name}
          <div className="form-group">
            <div className="col-sm-4">
              <div className="row file-upload-button">
                <div className="col-md-12 text-center" data-toggle="tooltip">
                    <label>
                      <img src="/icons/upload.png" className="iconUpload"/>
                      <input name="attachment" id="uploadFile" type="file"/>
                      <span className="fileName">Upload</span>
                    </label>
                </div>
              </div>
            </div>
          </div>
        <button type="submit" className="btn btn-primary">Save</button> &nbsp;
        {this.state.lender_docusign_form.id ?
          <a className="btn btn-danger btn-sm" data-toggle="modal" data-target="#removeDocusignForm">Delete</a> : null
        }
      </form>
        <ModalLink
          id="removeDocusignForm"
          title="Confirmation"
          body="Are you sure to remove this docusign form?"
          yesCallback={this.handleRemove}/>
      </div>
    );
  }
});

module.exports = LenderDocusignForm;
