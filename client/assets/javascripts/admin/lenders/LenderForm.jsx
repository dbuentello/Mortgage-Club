var React = require('react/addons');
var TextField = require('components/form/TextField');
var UploadField = require('components/form/UploadField');
var ModalLink = require('components/ModalLink');
var FlashHandler = require('mixins/FlashHandler');

var LenderForm = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    var lender = this.props.bootstrapData.lender;

    return {
      id: lender.id,
      name: lender.name,
      website: lender.website,
      rate_sheet: lender.rate_sheet,
      lock_rate_email: lender.lock_rate_email,
      docs_email: lender.docs_email,
      contact_name: lender.contact_name,
      contact_email: lender.contact_email,
      contact_phone: lender.contact_phone,
      nmls: lender.nmls,
      logo: lender.logo,
      saving: false
    }
  },

  onChange: function(change) {
    this.setState(change);
  },

  handleSubmit: function(e) {
    e.preventDefault();
    this.setState({saving: true});
    var form = document.forms.namedItem("lenderInfo");
    var formData = new FormData(form);

    if (this.state.id) {
      $.ajax({
        url: '/lenders/' + this.state.id,
        type: 'PUT',
        method: 'PUT',
        encType: "multipart/form-data",
        dataType: 'json',
        data: formData,
        success: function(resp) {
          location.href = '/lenders';
        },
        contentType: false,
        processData: false,
        async: true,
        error: function(resp) {
          var flash = { "alert-danger": resp.responseJSON.message };
          this.showFlashes(flash);
          this.setState({saving: false});
        }.bind(this)
      });
    }
    else {
      $.ajax({
        url: '/lenders',
        type: 'POST',
        encType: "multipart/form-data",
        dataType: 'json',
        contentType: 'application/json',

        data: JSON.stringify(this.state),

        success: function(resp) {
          location.href = '/lenders';
        },
        error: function(resp) {
          var flash = { "alert-danger": resp.responseJSON.message };
          this.showFlashes(flash);
          this.setState({saving: false});
        }.bind(this)
      });
    }
  },

  handleFileChange: function(event){
    var name = $("#uploadFile")[0].files[0];
    this.setState({logo: name});
  },

  handleRemove: function() {
    $.ajax({
      url: '/lenders/' + this.state.id,
      type: 'DELETE',
      dataType: 'json',
      contentType: 'application/json',
      success: function(resp) {
        location.href = '/lenders';
      }
    });
  },

  render: function() {
    return (
    <div className='content container'>
      <div className='pal'>
        <div className='row'>
          {this.state.id ? <h2 className='mbl'>Edit Lender</h2> : <h2 className='mbl'>New Lender</h2>}
          <span className="text-warning"><i> All fields are required </i></span>
          <form className="form-horizontal lender-form" type="json" enctype="multipart/form-data" name="lenderInfo" onSubmit={this.handleSubmit}>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label="Name"
                  keyName="name"
                  value={this.state.name}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label="Website"
                  keyName="website"
                  value={this.state.website}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label="Rate Sheet"
                  keyName="rate_sheet"
                  value={this.state.rate_sheet}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-3">
                <TextField
                  label="Lock Rate Email"
                  keyName="lock_rate_email"
                  value={this.state.lock_rate_email}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
              <div className="col-sm-3">
                <TextField
                  label="Docs Email"
                  keyName="docs_email"
                  value={this.state.docs_email}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-2">
                <TextField
                  label="Contact Name"
                  keyName="contact_name"
                  value={this.state.contact_name}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
              <div className="col-sm-2">
                <TextField
                  label="Contact Email"
                  keyName="contact_email"
                  value={this.state.contact_email}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
              <div className="col-sm-2">
                <TextField
                  label="Contact Phone"
                  keyName="contact_phone"
                  value={this.state.contact_phone}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-2">
                <TextField
                  label="NMLS"
                  keyName="nmls"
                  value={this.state.nmls}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
            </div>
            <div className="row">
              <div className="form-group">
                <div className="col-sm-6">
                  <div className="row file-upload-button">
                    <div className="col-md-12 text-center" data-toggle="tooltip">
                        <label>
                          <img src="/icons/upload.png" className="iconUpload"/>
                          <input name="logo" id="uploadFile" type="file" accept="image/*" onChange={this.handleFileChange}/>
                          { this.state.logo }
                          <span className="fileName">Upload</span>
                        </label>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <button className="btn btn-primary btn-sm" type="submit">Save</button> &nbsp;

            {this.state.id ?
              <a className="btn btn-danger btn-sm" data-toggle="modal" data-target="#removeLender">Delete</a> : null
            }
          </form>

          <ModalLink
            id="removeLender"
            title="Confirmation"
            body="Are you sure to remove this lender?"
            yesCallback={this.handleRemove}
            />
        </div>
      </div>
    </div>
    );
  }
});

module.exports = LenderForm;