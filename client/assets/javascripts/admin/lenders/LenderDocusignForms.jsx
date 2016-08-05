var React = require('react/addons');
var LenderDocusignForm = require('./LenderDocusignForm');

var LenderDocusignForms = React.createClass({
  getInitialState: function() {
    return {
      lender_docusign_forms: this.props.bootstrapData.lender_docusign_forms
    };
  },

  formAdded: function(lender_docusign_form) {
    var lender_docusign_forms = this.state.lender_docusign_forms;
    lender_docusign_forms.push(lender_docusign_form);
    this.setState({lender_docusign_forms: lender_docusign_forms});
  },

  render: function() {
    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Required Docusign Forms for Lender - {this.props.bootstrapData.lender.name}</h2>
            <table className="table table-striped">
              <thead>
              <tr>
                <th>Sign Position</th>
                <th>Description</th>
                <th>Doc Name</th>
                <th>Doc Order</th>
                <th></th>
              </tr>
              </thead>
              <tbody>
              {
                _.map(this.state.lender_docusign_forms, function(docusign_form){
                  return (
                    <tr key={docusign_form.id}>
                      <td>{docusign_form.sign_position}</td>
                      <td>{docusign_form.description}</td>
                      <td>{docusign_form.attachment_file_name}</td>

                      <td>{docusign_form.doc_order}</td>
                      <th>
                        <a className='linkTypeReversed btn btn-primary btn-sm' href={'/lenders/' + this.props.bootstrapData.lender.id + '/lender_docusign_forms/' + docusign_form.id + '/edit'}>Edit</a>
                      </th>
                    </tr>
                  )
                }, this)
              }
              </tbody>
            </table>
            <h3>Add Template</h3>
            <LenderDocusignForm bootstrapData={this.props.bootstrapData}
                          onSave={this.formAdded}/>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = LenderDocusignForms;
