var _ = require('lodash');
var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');
var TextField = require('components/form/TextField');
var ModalLink = require('components/ModalLink');
var SelectField = require('components/form/SelectField');

var nameOptions = [
  {name: '', value: ''},
  {name: 'Loan Estimate', value: 'Loan Estimate'},
  {name: 'Servicing Disclosure', value: 'Servicing Disclosure'},
  {name: 'Uniform Residential Loan Application', value: 'Loan Estimate'},
  {name: 'Generic Explanation', value: 'Generic Explanation'}
];

var Form = React.createClass({
  mixins: [FlashHandler],

  propTypes: {
    method: React.PropTypes.string,
    url: React.PropTypes.string,
    onReloadTable: React.PropTypes.func,
  },

  getDefaultProps: function() {
    return {
      method: 'POST',
      url: '',
      onReloadTable: null
    };
  },

  getInitialState: function() {
    if(this.props.DocusignTemplate) {
      return {
        name: this.props.DocusignTemplate.name,
        state: this.props.DocusignTemplate.state,
        description: this.props.DocusignTemplate.description,
        email_subject: this.props.DocusignTemplate.email_subject,
        email_body: this.props.DocusignTemplate.email_body,
        docusign_id: this.props.DocusignTemplate.docusign_id,
        document_order: this.props.DocusignTemplate.document_order
      };
    }else {
      return {
        name: "",
        state: "",
        description: "",
        email_subject: "",
        email_body: "",
        docusign_id: "",
        document_order: ""
      };
    }
  },

  onChange: function(change) {
    var key = _.keys(change)[0];
    var value = _.values(change)[0];
    if (key == "name") {
      this.setState({name: value});
    }

    this.setState(change);
  },

  onClick: function(event) {
    this.setState({saving: true});
    event.preventDefault();
    var formData = new FormData($('.form-loan-docusign-template')[0]);
    formData.append("docusign_template[name]", this.state.name);

    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      enctype: 'multipart/form-data',
      data: formData,
      success: function(response) {
        this.setState({
          name: response.docusign_template.name,
          state: response.docusign_template.state,
          description: response.docusign_template.description,
          email_subject: response.docusign_template.email_subject,
          email_body: response.docusign_template.email_body,
          docusign_id: response.docusign_template.docusign_id,
          document_order: response.docusign_template.document_order,
          saving: false
        });
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        if(response.docusign_templates){
          this.props.onReloadTable(response.docusign_templates);
        }
        this.setState({saving: false});
      }.bind(this),
      cache: false,
      contentType: false,
      processData: false,
      async: true,
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.message };
        this.showFlashes(flash);
        this.setState({saving: false});
      }.bind(this)
    });
  },

  onRemove: function(event) {
    if(this.props.DocusignTemplate) {
      this.setState({removing: true});

      $.ajax({
        url: this.props.Url,
        method: 'DELETE',
        success: function(response) {
          var flash = { "alert-success": response.message };
          this.showFlashes(flash);
          location.href = '/docusign_template_managements';
        }.bind(this),
        error: function(response, status, error) {
          var flash = { "alert-danger": response.responseJSON.message };
          this.showFlashes(flash);
        }.bind(this)
      });
    }
  },

  render: function() {
    return (
      <div>
        <form className="form-horizontal form-loan-docusign-template">
          <div className="form-group">
            <div className="col-sm-4">
              <SelectField
                label="Name"
                keyName="name"
                value={this.state.name}
                options={nameOptions}
                onChange={this.onChange}
                editable={true}/>
              <TextField
                label="State"
                keyName="state"
                name="docusign_template[state]"
                value={this.state.state}
                editable={true}
                onChange={this.onChange}/>
              <TextField
                label="Description"
                keyName="description"
                name="docusign_template[description]"
                value={this.state.description}
                editable={true}
                onChange={this.onChange}/>
              <TextField
                label="Docusign Id"
                keyName="docusign_id"
                name="docusign_template[docusign_id]"
                value={this.state.docusign_id}
                editable={true}
                onChange={this.onChange}/>
              <TextField
                label="Email Subject"
                keyName="email_subject"
                name="docusign_template[email_subject]"
                value={this.state.email_subject}
                editable={true}
                onChange={this.onChange}/>
              <TextField
                label="Email Body"
                keyName="email_body"
                name="docusign_template[email_body]"
                value={this.state.email_body}
                editable={true}
                onChange={this.onChange}/>
              <TextField
                label="Document Order"
                keyName="document_order"
                name="docusign_template[document_order]"
                value={this.state.document_order}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-10">
              <button className="btn btn-primary" onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
              &nbsp;
              { this.props.DocusignTemplate ?
                <a className="btn btn-danger" data-toggle="modal" data-target="#removeDocusignTemplate" disabled={this.state.removing}>{ this.state.removing ? 'Removing' : 'Remove' }</a>
              : null
              }
            </div>
          </div>
        </form>
        <ModalLink
          id="removeDocusignTemplate"
          title="Confirmation"
          body="Are you sure to remove this docusign template?"
          yesCallback={this.onRemove}
        />
      </div>
    )
  }
});

module.exports = Form;
