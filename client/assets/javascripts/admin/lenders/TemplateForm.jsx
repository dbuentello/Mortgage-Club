var React = require('react/addons');
var TextField = require('components/form/TextField');
var FlashHandler = require('mixins/FlashHandler');
var ModalLink = require('components/ModalLink');

var TemplateForm = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    return {
      name: this.props.template.name,
      description: this.props.template.description
    }
  },

  onChange: function(change) {
    this.setState(change);
  },

  handleSubmit: function(e) {
    e.preventDefault();

    if (this.props.template.id) {
      $.ajax({
        url: '/lenders/' + this.props.lender.id + '/templates/' + this.props.template.id,
        method: 'PUT',
        dataType: 'json',
        contentType: 'application/json',
        data: JSON.stringify(this.state),
        success: function(resp) {
          location.href = '/lenders/' + this.props.lender.id + '/templates';
        }.bind(this),
        error: function(resp) {
          var flash = { "alert-danger": resp.responseJSON.message };
          this.showFlashes(flash);
          this.setState({saving: false});
        }.bind(this)
      });
    } else{
      $.ajax({
        url: '/lenders/' + this.props.lender.id + '/templates',
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
      url: '/lenders/' + this.props.lender.id + '/templates/' + this.props.template.id,
      method: 'DELETE',
      dataType: 'json',
      contentType: 'application/json',
      success: function(resp) {
        location.href = '/lenders/' + this.props.lender.id + '/templates';
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
            <TextField
              label="Name"
              keyName="name"
              value={this.state.name}
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
        {this.props.template.id ?
          <a className="btn btn-danger btn-sm" data-toggle="modal" data-target="#removeTemplate">Delete</a> : null
        }
      </form>
        <ModalLink
          id="removeTemplate"
          title="Confirmation"
          body="Are you sure to remove this template?"
          yesCallback={this.handleRemove}
          />
      </div>
    );
  }
});

module.exports = TemplateForm;