/**
 * Show borrowers of system
 */
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");

var Borrowers = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    return {
      borrowers: this.props.bootstrapData.borrowers
    }
  },

  handleRemoveBorrower: function(event) {
    this.setState({borrowerId: event.target.id});
    $("#removeBorrower").modal();
  },

  handleRemove: function(event) {
   $.ajax({
      url: "borrower_managements/"+this.state.borrowerId,
      method: "DELETE",
      success: function(response) {
          this.setState({borrowers: response.borrowers});
          $("#removeBorrower").modal("hide");
        }.bind(this),
        error: function(response, status, error) {
        }.bind(this)
    });
  },


  render: function() {
    return (
  <div>
      {/* Page header */ }
  <div className="page-header">
    <div className="page-header-content">
      <div className="page-title">
        <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Borrowers</span> - Management</h4>
      </div>
    </div>
  </div>
  {/* /page header */ }

  {/* Page container */ }
  <div className="page-container">

    {/* Page content */ }
    <div className="page-content">

      {/* Main content */ }
      <div className="content-wrapper">

        {/* Table */ }
        <div className="panel panel-flat">
          <div className="panel-heading">
            <h5 className="panel-title">Borrowers</h5>
            <div className="heading-elements">

            </div>
          </div>
          <div className="panel-body">
          </div>
          <div className="table-responsive">
            <table className="table table-striped table-hover">
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
                  _.map(this.state.borrowers, function(borrower){
                      return (
                        <tr key={borrower.id}>
                          <td nowrap>{borrower.user.full_name}</td>
                          <td>{borrower.user.email}</td>
                          <td>{borrower.ssn}</td>
                          <td>{borrower.dob ? this.isoToUsDate(borrower.dob) : null}</td>
                          <td>{borrower.phone}</td>
                          <th>
                            <a className="linkTypeReversed btn btn-primary btn-sm member-title-action" href={"/borrower_managements/" + borrower.user.id + "/switch"}>Switch to borrower</a>
                            <a id={borrower.id} className='linkTypeReversed btn btn-danger btn-sm member-title-action' onClick={this.handleRemoveBorrower}> Remove </a>
                          </th>
                        </tr>
                      )
                    }, this)
                }

              </tbody>
            </table>
          </div>
          <div className="modal fade" id="removeBorrower" tabIndex="-1" role="dialog" aria-labelledby="Confirmation">
            <div className="modal-dialog modal-md" role="document">
              <div className="modal-content">
                <span className="glyphicon glyphicon-remove-sign closeBtn" data-dismiss="modal"></span>
                <div className="modal-body text-center">
                  <h3 className={this.props.bodyClass}>Are you sure you want to remove this borrower?</h3>
                  <form className="form-horizontal">
                    <div className="form-group">
                      <div className="col-md-6">
                        <button type="button" className="btn btn-default" data-dismiss="modal">No</button>
                      </div>
                      <div className="col-md-6">
                        <button type="button" className="btn btn-mc" onClick={this.handleRemove}>Yes</button>
                      </div>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>
        {/* /table */ }

      </div>
      {/* /main content */ }

    </div>
    {/* /page content */ }

  </div>
  {/* /page container */ }
</div>
    );
  }
});

module.exports = Borrowers;
