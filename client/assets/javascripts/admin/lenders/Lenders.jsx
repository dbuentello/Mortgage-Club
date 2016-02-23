var React = require('react/addons');

var Lenders = React.createClass({
  render: function() {
    return (
      <div>
          {/* Page header */ }
    	<div className="page-header">
    		<div className="page-header-content">
    			<div className="page-title">
    				<h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Lenders</span> - Management</h4>
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
    						<h5 className="panel-title">Lenders</h5>
    						<div className="heading-elements">
    							
    	          </div>
              </div>
                    	<div className="panel-body">
                        <a className="btn btn-primary" href="/lenders/new">Add Lender</a>

                    	</div>
    					<div className="table-responsive">
    						<table className="table table-striped table-hover">
    							<thead>
                    <tr>
                      <th>Name</th>
                      <th>Website</th>
                      <th>Rate Sheet</th>
                      <th>Lock Rate Email</th>
                      <th>Docs Email</th>
                      <th>Contact Name</th>
                      <th>Contact Email</th>
                      <th></th>
                    </tr>
    							</thead>
    							<tbody>
                    {
                  _.map(this.props.bootstrapData.lenders, function(lender){
                      return (
                        <tr key={lender.id}>
                          <td nowrap>{lender.name}</td>
                          <td>{lender.website}</td>
                          <td>{lender.rate_sheet}</td>
                          <td>{lender.lock_rate_email}</td>
                          <td>{lender.docs_email}</td>
                          <td>{lender.contact_name}</td>
                          <td>{lender.contact_email}</td>
                          <th>
                            <a className="btn btn-primary btn-sm col-sm-10 mbm text-center" href={"/lenders/" + lender.id + "/lender_templates"}>Templates</a>
                            <a className="linkTypeReversed btn btn-primary btn-sm col-sm-10 text-center" href={'/lenders/' + lender.id + '/edit'}>Edit</a>
                          </th>
                        </tr>
                      )
                    })
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

module.exports = Lenders;
