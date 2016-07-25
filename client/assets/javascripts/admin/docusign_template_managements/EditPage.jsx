var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var EditPage = React.createClass({
  render: function() {
    var url = '/docusign_template_managements/' + this.props.bootstrapData.docusign_template.id;

    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Edit Docusign Template</h2>
            <Form DocusignTemplate={this.props.bootstrapData.docusign_template} Url={url} Method={'PUT'}></Form>
          </div>
        </div>
      </div>
    )
  }

});

module.exports = EditPage;