var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");

var Borrowers = React.createClass({
  mixins: [TextFormatMixin],

  render: function() {
    return (
      <div className="content container">
        <div className="pal">
          <div className="row">
            <h2 className="mbl">Borrowers</h2>
            <div className="col-md-12">
              <table className="table table-striped borrowers">
                <thead>
                <tr>
                  <th>Name</th>
                  <th>Email</th>
                  <th>SSN</th>
                  <th>DOB</th>
                  <th>Phone</th>
                  <th></th>
                </tr>
                </thead>
                <tbody>
                {
                  _.map(this.props.bootstrapData.borrowers, function(borrower){
                      return (
                        <tr key={borrower.id}>
                          <td nowrap>{borrower.user.full_name}</td>
                          <td>{borrower.user.email}</td>
                          <td>{borrower.ssn}</td>
                          <td>{borrower.dob ? this.isoToUsDate(borrower.dob) : null}</td>
                          <td>{borrower.phone}</td>
                          <th>
                            <a className="linkTypeReversed btn btn-primary btn-sm col-sm-10 text-center" href={"/borrower_managements/" + borrower.user.id + "/switch"}>Switch to borrower</a>
                          </th>
                        </tr>
                      )
                    }, this)
                }
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = Borrowers;
