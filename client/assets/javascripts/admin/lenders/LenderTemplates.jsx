var React = require('react/addons');
var TemplateForm = require('./TemplateForm');

var LenderTemplates = React.createClass({
  getInitialState: function() {
    return {
      lender_templates: this.props.bootstrapData.lender_templates
    };
  },

  templateAdded: function(lender_template) {
    var lender_templates = this.state.lender_templates;
    lender_templates.push(lender_template);
    this.setState({lender_templates: lender_templates});
  },

  render: function() {
    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Required templates for Lender - {this.props.bootstrapData.lender.name}</h2>
            <table className="table table-striped">
              <thead>
              <tr>
                <th>Name</th>
                <th>Description</th>
                <th></th>
              </tr>
              </thead>
              <tbody>
              {
                _.map(this.state.lender_templates, function(template){
                  return (
                    <tr key={template.id}>
                      <td>{template.name}</td>
                      <td>{template.description}</td>
                      <th>
                        <a className='linkTypeReversed btn btn-primary btn-sm' href={'/lenders/' + this.props.bootstrapData.lender.id + '/lender_templates/' + template.id + '/edit'}>Edit</a>
                      </th>
                    </tr>
                  )
                }, this)
              }
              </tbody>
            </table>
            <h3>Add Template</h3>
            <TemplateForm lender_template={{}} lender={this.props.bootstrapData.lender} docusignTemplates={this.props.bootstrapData.docusign_templates}
                          onSave={this.templateAdded}/>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = LenderTemplates;