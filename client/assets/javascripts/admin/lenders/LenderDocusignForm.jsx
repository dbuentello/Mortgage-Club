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
    if(this.props.bootstrapData.lender_docusign_form){
      return {
        lender_docusign_form: this.props.bootstrapData.lender_docusign_form,
        lender: lender,
        page_number: null,
        x_position: null,
        y_position: null,
        doc_order: this.props.bootstrapData.lender_docusign_form.doc_order,
        sign_position: JSON.parse(this.props.bootstrapData.lender_docusign_form.sign_position),
        description: this.props.bootstrapData.lender_docusign_form.description,
        form_id: this.props.bootstrapData.lender_docusign_form.form_id,
        saving: false
      }
    }
    else {
      return {
        lender: lender,
        page_number: "",
        x_position: "",
        y_position: "",
        doc_order: "",
        lender_docusign_form: {},
        sign_position: [],
        description: "",
        form_id: "",
        saving: false
      }
    }

  },

  handleSubmit: function(e) {
    e.preventDefault();
    this.setState({saving: true});

    var formData = new FormData();
    formData.append("description", this.state.description);
    var signPosition = [];
    var docOrder = this.state.doc_order;
    _.each(this.state.sign_position, function(sign){
      sign.document_id = docOrder;
      signPosition.push(sign);
    });

    formData.append("sign_position", JSON.stringify(signPosition));
    formData.append("form_id", this.state.form_id);
    formData.append("doc_order", this.state.doc_order);

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
  calcPxSign: function(position){
    var inPosition = parseFloat(position);
    // convert inch to px of Docusign
    return ((inPosition * 72 * 1.3333 * 0.72).toFixed(2)).toString();
  },
  onChange: function(change) {
    this.setState(change);
  },
  addSignPosition: function(){
    var signPosition = this.state.sign_position.slice();
    signPosition.push({ "name": "Signature", "x_position": this.calcPxSign(this.state.x_position), "y_position": this.calcPxSign(this.state.y_position), "page_number": this.state.page_number, "optional": "false"});
    this.setState({
      sign_position: signPosition,
      x_position: "",
      y_position: "",
      page_number: ""
    });
  },
  removeSignPosition: function(index){
    var signPosition = this.state.sign_position;
    signPosition.splice(index, 1);

    this.setState({
      sign_position: signPosition
    });
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
              <div className="col-sm-2">
                <TextField
                  label="X Position"
                  keyName="x_position"
                  value={this.state.x_position}
                  editable={true}
                  onChange={this.onChange} />
              </div>
                  <div className="col-sm-2">

                  <TextField
                    label="Y Position"
                    keyName="y_position"
                    value={this.state.y_position}
                    editable={true}
                  onChange={this.onChange}  />
              </div>
              <div className="col-sm-2">

                    <TextField
                      label="Page Number"
                      keyName="page_number"
                      value={this.state.page_number}
                      editable={true}
                      onChange={this.onChange}/>
                  </div>
                    <div className="col-sm-1">

                    <a className='btn btn-primary btn-sm' onClick={this.addSignPosition}>Add</a>
</div>
            </div>

              {
                _.map(this.state.sign_position, function(sign, index) {
                  return (
                        <div className="form-group">
                    <div className="row input-sm">
                      <div className="col-sm-2">
                        <TextField
                          value={sign.x_position}
                          editable={false}
                         />
                      </div>
                          <div className="col-sm-2">

                          <TextField
                            value={sign.y_position}
                            editable={false}
                            />
                      </div>
                      <div className="col-sm-2">

                            <TextField
                              value={sign.page_number}
                              editable={false}
                              />
                          </div>
                      <div className="col-sm-1">
                        <a className="btn btn-danger" id="removeSignPosition" onClick={this.removeSignPosition.bind(this, index)} role="button">x</a>
                      </div>
                    </div>
                  </div>

                  )
                }, this)
              }
        <div className="form-group">
          <div className="col-sm-4">
            <TextField
              label="Description"
              keyName="description"
              value={this.state.description}
              editable={true}
              onChange={this.onChange}/>
          </div>
          <div className="col-sm-2">
            <TextField
              label="Doc order"
              keyName="doc_order"
              value={this.state.doc_order}
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
