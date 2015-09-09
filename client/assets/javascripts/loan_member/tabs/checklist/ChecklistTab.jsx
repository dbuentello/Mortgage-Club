var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');
var TextFormatMixin = require('mixins/TextFormatMixin');
var FlashHandler = require('mixins/FlashHandler');

var ChecklistTab = React.createClass({
  mixins: [TextFormatMixin, FlashHandler],

  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function() {
    return {
      checklists: this.props.checklists
    }
  },

  onReloadTable: function(checklists) {
    this.setState(
      {checklists: checklists}
    )
  },

  onDelete: function(event) {
    var checklist_id = event.target.value;

    $.ajax({
      url: '/loan_members/checklists/' + checklist_id,
      method: 'DELETE',
      success: function(response) {
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        this.onReloadTable(response.checklists);
      }.bind(this),
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.message };
        this.showFlashes(flash);
      }.bind(this)
    });
  },

  render: function() {
    var url = '/loan_members/checklists/';

    return (
      <div className='content container backgroundBasic'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Checklists</h2>
            <table className="table table-striped">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Type</th>
                  <th>Due Date</th>
                  <th>Status</th>
                  <th>Owner</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {
                  _.map(this.state.checklists, function(checklist) {
                    return (
                      <tr key={checklist.id}>
                        <td>{checklist.name}</td>
                        <td>{checklist.checklist_type}</td>
                        <td>{this.isoToUsDate(checklist.due_date)}</td>
                        <td>{checklist.status}</td>
                        <td>{checklist.user.to_s}</td>
                        <td>
                          <span>
                            <a className='linkTypeReversed btn btn-primary' href={'/loan_members/checklists/' + checklist.id + '/edit'} data-method='get'>Edit</a>
                          </span>
                          &nbsp;
                          <span>
                            <button className='linkTypeReversed btn btn-danger' value={checklist.id} onClick={this.onDelete}>Delete</button>
                          </span>
                        </td>
                      </tr>
                    )
                  }, this)
                }
              </tbody>
            </table>
          </div>
          <br/>
          <div className='row'>
            <h2>Add a new checklist</h2>
            <Form Url={url} Method='POST' onReloadTable={this.onReloadTable} loan={this.props.loan} templates={this.props.templates}></Form>
          </div>
        </div>
      </div>
    )
  }

});

module.exports = ChecklistTab;