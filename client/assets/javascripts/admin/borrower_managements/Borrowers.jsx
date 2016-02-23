var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");

var Borrowers = React.createClass({
  mixins: [TextFormatMixin],

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
