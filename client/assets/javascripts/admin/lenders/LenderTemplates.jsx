var React = require('react/addons');
var TemplateForm = require('./TemplateForm');

var LenderTemplates = React.createClass({
  getInitialState: function() {
    return {
      templates: this.props.bootstrapData.templates
    };
  },

  templateAdded: function(template) {
    var templates = this.state.templates;
    templates.push(template);
    this.setState({templates: templates});
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
                _.map(this.state.templates, function(template){
                  return (
                    <tr key={template.id}>
                      <td>{template.name}</td>
                      <td>{template.description}</td>
                      <th>
                        <a className='linkTypeReversed btn btn-primary btn-sm' href={'/lenders/' + template.lender_id + '/templates/' + template.id + '/edit'}>Edit</a>
                      </th>
                    </tr>
                  )
                })
              }
              </tbody>
            </table>
            <h3>Add Template</h3>
            <TemplateForm template={{}} lender={this.props.bootstrapData.lender}
                          onSave={this.templateAdded}/>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = LenderTemplates;