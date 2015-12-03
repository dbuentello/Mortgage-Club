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
         <TemplateForm template={this.props.bootstrapData.template}
                       lender={this.props.bootstrapData.lender}
                       onSave={this.templateSaved}/>
       </div>
     </div>
   )
  }
});
module.exports = EditTemplate;