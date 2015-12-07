var React = require('react/addons');
var TextField = require('components/form/TextField');
var FlashHandler = require('mixins/FlashHandler');
var ModalLink = require('components/ModalLink');
var SelectField = require('components/form/SelectField');

var TemplateForm = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    return {
      name: this.props.lender_template.name,
      description: this.props.lender_template.description,
      displayName: false,
      template_id: this.props.lender_template.template_id
    }
  },

  onChange: function(change) {
    var key = _.keys(change)[0];
    var value = _.values(change)[0];
    if (key == "template_id" && value == "other") {
      this.setState({displayName: true});
      this.setState({name: ""});
    }
    else if (key == "template_id") {
      var docusign_template = _.find(this.props.docusignTemplates, { 'id': value });
      this.setState({displayName: false});
      this.setState({name: docusign_template.name});
    }

    this.setState(change);
  },

  handleSubmit: function(e) {
    e.preventDefault();

    if (this.props.lender_template.id) {
      $.ajax({
        url: '/lenders/' + this.props.lender.id + '/lender_templates/' + this.props.lender_template.id,
        method: 'PUT',
        dataType: 'json',
        contentType: 'application/json',
        data: JSON.stringify(this.state),
        success: function(resp) {
          location.href = '/lenders/' + this.props.lender.id + '/lender_templates';
        }.bind(this),
        error: function(resp) {
          var flash = { "alert-danger": resp.responseJSON.message };
          this.showFlashes(flash);
          this.setState({saving: false});
        }.bind(this)
      });
    } else{
      $.ajax({
        url: '/lenders/' + this.props.lender.id + '/lender_templates',
        method: 'POST',
        dataType: 'json',
        contentType: 'application/json',
        data: JSON.stringify(this.state),
        success: function(resp) {
          this.props.onSave(resp);
          this.setState({name: '', description: ''});
        }.bind(this),
        error: function(resp) {
          var flash = { "alert-danger": resp.responseJSON.message };
          this.showFlashes(flash);
          this.setState({saving: false});
        }.bind(this)
      });
    }
  },

  handleRemove: function() {
    $.ajax({
      url: '/lenders/' + this.props.lender.id + '/lender_templates/' + this.props.lender_template.id,
      method: 'DELETE',
      dataType: 'json',
      contentType: 'application/json',
      success: function(resp) {
        location.href = '/lenders/' + this.props.lender.id + '/lender_templates';
      }.bind(this),
      error: function(resp) {
        var flash = { "alert-danger": resp.responseJSON.message };
        this.showFlashes(flash);
        this.setState({saving: false});
      }.bind(this)
    });
  },

  getDocusignTemplateOptions: function() {
    var options = [];
    options.push({name: "", value: ""});
    _.each(this.props.docusignTemplates, function(template) {
      options.push({name: template.name, value: template.id});
    });
    options.push({name: "Other", value: "other"});
    return options;
  },

  render: function() {
    return (
      <div>
      <form className="form-horizontal lender-template-form" onSubmit={this.handleSubmit}>
        <div className="form-group">
          <div className="col-sm-4">
            <SelectField
              label="Document"
              keyName="template_id"
              value={this.state.template_id}
              options={this.getDocusignTemplateOptions()}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>
        {
          this.state.displayName
          ?
            <div className="form-group">
              <div className="col-sm-4">
                <TextField
                  label="Name"
                  keyName="name"
                  value={this.state.name}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
            </div>
          :
            null
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
        </div>
        <button type="submit" className="btn btn-primary">Save</button> &nbsp;
        {this.props.lender_template.id ?
          <a className="btn btn-danger btn-sm" data-toggle="modal" data-target="#removeTemplate">Delete</a> : null
        }
      </form>
        <ModalLink
          id="removeTemplate"
          title="Confirmation"
          body="Are you sure to remove this template?"
          yesCallback={this.handleRemove}/>
      </div>
    );
  }
});

module.exports = TemplateForm;