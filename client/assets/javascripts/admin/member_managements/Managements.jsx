var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var Managements = React.createClass({
  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function() {
    return {
      members: this.props.bootstrapData.loan_members
    }
  },

  onReloadTable: function(loan_members) {
    this.setState(
      {members: loan_members}
    )
  },

  render: function() {
    var url = '/loan_member_managements/';

    return (
      <div>
          {/* Page header */ }
      <div className="page-header">
        <div className="page-header-content">
          <div className="page-title">
            <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Team member</span> - Management</h4>
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
                <h5 className="panel-title">Team Members</h5>
                <div className="heading-elements">
                  <ul className="icons-list">
                      <li><a data-action="collapse"></a></li>
                      <li><a data-action="close"></a></li>
                  </ul>
                </div>
              </div>
              <div className="panel-body">

              </div>
              <div className="table-responsive">
                <table className="table table-striped table-hover">
                  <thead>
                    <tr>
                      <th>Avatar</th>
                      <th>Name</th>
                      <th>Email</th>
                      <th>Phone number</th>
                      <th>Skype</th>
                      <th></th>
                    </tr>
                  </thead>
                  <tbody>
                    {
                      _.map(this.state.members, function(member) {
                        return (
                          <tr key={member.id}>
                            <td>
                              <img src={member.user.avatar_url} width="40px" height="30px"/>
                            </td>
                            <td>{member.user.to_s}</td>
                            <td>{member.user.email}</td>
                            <td>{member.phone_number}</td>
                            <td>{member.skype_handle}</td>
                            <td>
                              <span>
                                <a className='linkTypeReversed btn btn-primary' href={'loan_member_managements/' + member.id + '/edit'} data-method='get'>Edit</a>
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
            {/* /table */ }

            {/* Grid */ }
				    <div className="row">
					    <div className="col-md-12">

    						{/* Horizontal form */ }
    						<div className="panel panel-flat">
    							<div className="panel-heading">
    								<h5 className="panel-title">Add new member</h5>
    								<div className="heading-elements">
    									<ul className="icons-list">
    				                		<li><a data-action="collapse"></a></li>
    				                		<li><a data-action="close"></a></li>
    				                	</ul>
    			                	</div>
    		                	</div>

    							<div className="panel-body">
                     <Form Url={url} Method='POST' onReloadTable={this.onReloadTable}></Form>
                  </div>
    						</div>
    						{/* /horizotal form */ }
					    </div>
				    </div>
				    {/* /grid */ }

          </div>
          {/* /main content */ }

        </div>
        {/* /page content */ }

      </div>
      {/* /page container */ }
    </div>
    )
  }

});

module.exports = Managements;
