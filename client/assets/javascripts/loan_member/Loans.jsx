var _ = require('lodash');
var React = require('react/addons');

var FlashHandler = require('mixins/FlashHandler');
var TextFormatMixin = require('mixins/TextFormatMixin');

var Loans = React.createClass({
  mixins: [FlashHandler, TextFormatMixin],

  render: function() {
    return (
      <div className='content container'>

          <div className="panel panel-flat">
            <div className="panel-heading">
              <h4 className="panel-title">Loans list</h4>
            </div>

            <div className="datatable-scroll" id="checklists-table" style={{borderTop: "1px solid #ddd"}}>
              <table role="grid" className="table table-striped table-hover datatable-highlight dataTable no-footer">
                <thead>
                  <tr role="row">
                    <th tabIndex="0" rowSpan="1" colSpan="1" aria-sort="ascending">Borrower</th>
                    <th  tabIndex="0" rowSpan="1" colSpan="1">Email</th>
                    <th  tabIndex="0" rowSpan="1" colSpan="1">Status</th>
                    <th  tabIndex="0" rowSpan="1" colSpan="1">Created at</th>
                    <th  tabIndex="0" rowSpan="1" colSpan="1">Updated at</th>
                    <th  tabIndex="0" rowSpan="1" colSpan="1">Action</th>
                  </tr>
                </thead>
                <tbody>



                  {
                    _.map(this.props.bootstrapData.loans, function(loan) {
                      return (
                        <tr key={loan.id}>
                          <td>{loan.user.to_s}</td>
                          <td>{loan.user.email}</td>
                          <td>

                            {loan.status == "pending"
                            ? <span className="label label-info">{loan.status}</span>
                          : <span className="label label-success">{loan.status}</span>
                          }



                          </td>
                          <td>{this.formatTime(loan.created_at)}</td>
                          <td>{this.formatTime(loan.updated_at)}</td>
                          <td><span>
                          <a className='linkTypeReversed' href={"/loan_members/dashboard/" + loan.id}
                            data-method='get'><i className="icon-pencil7"></i></a>
                          </span></td>

                        </tr>
                      )
                    }, this)
                  }
                </tbody>
              </table>
            </div>
          </div>


      </div>
    )
  }

});

module.exports = Loans;
