var _ = require('lodash');
var React = require('react/addons');
var LoanTab = React.createClass({
  render: function() {
    return (
      <div role="tabpanel" className="tab-pane active" id="loan">
        <div className="box boxBasic backgroundBasic">
          <div className="boxBody ptm">
            <table className="table table-striped">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Owner</th>
                  <th>Description</th>
                  <th>Date modified</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
              {
                _.map(this.props.loanList, function(loan) {
                  return (
                    <tr>
                      <td>
                        <span><img src={loan.file.url} width="40px" height="30px"/></span>
                        &nbsp;&nbsp;&nbsp;
                        <span>{loan.file.name}</span>
                      </td>
                      <td>{loan.owner}</td>
                      <td>{loan.kind}</td>
                      <td>{loan.modified_at}</td>
                      <td>
                        <select className="selectpicker">
                          <option></option>
                        </select>
                      </td>
                    </tr>
                  )
                })
              }
              </tbody>
            </table>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = LoanTab;