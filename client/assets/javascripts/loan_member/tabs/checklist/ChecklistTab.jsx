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



      <div id="checklists-page">
        <div className="panel panel-flat">
          <div className="panel-heading">
            <h4 className="panel-title">Checklists</h4>
          </div>

          <div className="datatable-scroll" id="checklists-table">
            <table role="grid" className="table table-hover datatable-highlight dataTable no-footer">
              <thead>
                <tr role="row">
                  <th tabIndex="0" rowSpan="1" colSpan="1" aria-sort="ascending">Name</th>
                  <th  tabIndex="0" rowSpan="1" colSpan="1">Type</th>
                  <th  tabIndex="0" rowSpan="1" colSpan="1">Due Date</th>
                  <th  tabIndex="0" rowSpan="1" colSpan="1">Status</th>
                  <th  tabIndex="0" rowSpan="1" colSpan="1">Owner</th>
                  <th tabIndex="0" rowSpan="1" colSpan="1">Actions</th>
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
                        <td>

                          {checklist.status == "pending"
                          ? <span className="label label-info">{checklist.status}</span>
                        : <span className="label label-success">{checklist.status}</span>
                        }
                        </td>
                        <td>{checklist.user.to_s}</td>
                        <td>
                          <span>
                            <a className='linkTypeReversed' href={'/loan_members/checklists/' + checklist.id + '/edit'}
                              data-method='get'><i className="icon-pencil7"></i></a>
                          </span>
                          &nbsp;
                          <span>
                            <button className='linkTypeReversed icon-trash borderless'  value={checklist.id} onClick={this.onDelete}>
                              </button>
                          </span>
                        </td>
                      </tr>
                    )
                  }, this)
                }
              </tbody>
            </table>
          </div>
        </div>
        <div className="panel panel-flat">
          <div className="panel-heading">
            <h4 className="panel-title">Add a new checklist</h4>
          </div>

          <div className="panel-body">
            <div className='row' style={{"margin-top": "10px"}}>
              <Form Url={url} Method='POST' onReloadTable={this.onReloadTable} loan={this.props.loan} templates={this.props.templates}></Form>
            </div>
          </div>
        </div>
      </div>
    )
  }

});

module.exports = ChecklistTab;
