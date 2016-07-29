var React = require('react/addons');
var TextField = require('components/form/TextField');
var TextareaField = require('components/form/TextareaField');

var FlashHandler = require('mixins/FlashHandler');
var ModalLink = require('components/ModalLink');
var SelectField = require('components/form/SelectField');

var LenderDocusignForm = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    return {
      sign_position: this.props.lender_docusign_form.sign_position,
      description: this.props.lender_docusign_form.description,
      form_id: this.props.lender_docusign_form.form_id
    }
  },

  handleSubmit: function(e) {

  },

  onChange: function(change) {
    this.setState(change);
  },

  handleRemove: function() {
    $.ajax({
      url: '/lenders/' + this.props.lender.id + '/lender_docusign_forms/' + this.props.lender_docusign_form.id,
      method: 'DELETE',
      dataType: 'json',
      contentType: 'application/json',
      success: function(resp) {
        location.href = '/lenders/' + this.props.lender.id + '/lender_docusign_forms';
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
      <form className="form-horizontal lender-template-form" onSubmit={this.handleSubmit}>
        <div className="form-group">
          <div className="col-sm-4">

          </div>
        </div>

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
        <button type="submit" className="btn btn-primary">Save</button> &nbsp;
        {this.props.lender_docusign_form.id ?
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
