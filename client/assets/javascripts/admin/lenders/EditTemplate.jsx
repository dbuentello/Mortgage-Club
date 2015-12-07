var React = require('react/addons');
var TemplateForm = require('./TemplateForm');

var EditTemplate = React.createClass({
  templateSaved: function() {

  },

  render: function() {
   return (
     <div className='content container'>
       <div className='pal'>
         <h2>Edit Template </h2>
         <TemplateForm lender_template={this.props.bootstrapData.lender_template}
                       lender={this.props.bootstrapData.lender} docusignTemplates={this.props.bootstrapData.docusign_templates}
                       onSave={this.templateSaved}/>
       </div>
     </div>
   )
  }
});
module.exports = EditTemplate;