var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var EditPage = React.createClass({
  render: function() {
    var checklist = this.props.bootstrapData.checklist;
    var url = '/loan_members/checklists/' + checklist.id;
    var loan = checklist.loan;
    var templates = this.props.bootstrapData.templates;

    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Edit Checklist</h2>
            <Form Url={url} Method='PATCH' checklist={checklist} onReloadTable={this.onReloadTable} loan={loan} templates={templates}></Form>
          </div>
        </div>
      </div>
    )
  }

});

module.exports = EditPage;