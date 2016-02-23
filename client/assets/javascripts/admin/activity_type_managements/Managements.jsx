var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var Managements = React.createClass({
  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function() {
    return {
      activity_types: this.props.bootstrapData.activity_types
    }
  },

  onReloadTable: function(activity_types) {
    this.setState({activity_types: activity_types});
  },

  render: function() {
    var url = '/loan_activity_type_managements/';

    return (
      <div>
        {/* header */}
  	<div className="page-header">
  		<div className="page-header-content">
  			<div className="page-title">
  				<h4>
            <i className="icon-arrow-left52 position-left"> </i>
            <span className="text-semibold"> Activity Type Managements </span>
          </h4>
  			</div>
  		</div>
  	</div>
{/* end header */}

	<div className="page-container">
		<div className="page-content">
			<div className="content-wrapper">
				<div className="panel panel-flat">
					<div className="panel-heading">
						<h5 className="panel-title">Activity Type</h5>
						<div className="heading-elements">

	          </div>
            </div>
              <div class="panel-body">
                </div>
                  <div className="table-responsive">
						        <table className="table table-striped">
        							<thead>
                        <tr>
                          <th>Label</th>
                          <th></th>
                        </tr>
        							</thead>
        							<tbody>
                        {
                          _.map(this.state.activity_types, function(activity_type) {
                            return (
                              <tr key={activity_type.id}>
                                <td>{activity_type.label}</td>
                                <td>
                                  <span>
                                    <a className='linkTypeReversed btn btn-primary' href={'loan_activity_type_managements/' + activity_type.id + '/edit'} data-method='get'>Edit</a>
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
        				<div className="row">
        					<div className="col-md-12">


        						<div className="panel panel-flat">
        							<div className="panel-heading">
        								<h5 className="panel-title">Add new Activity Type</h5>
        								<div className="heading-elements">
        									
        			                	</div>
        		                	</div>

        							<div className="panel-body">
                      <Form Url={url} Method='POST' onReloadTable={this.onReloadTable}></Form>	</div>
        						</div>


        					</div>
                </div>




			</div>


		</div>



	</div>
</div>
    )
  }
});

module.exports = Managements;
