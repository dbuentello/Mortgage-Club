var React = require('react/addons');

var RecentLoanActivities = require('./RecentLoanActivities');
var TextFormatMixin = require('mixins/TextFormatMixin');

var RelationshipManager = React.createClass({
  mixins: [TextFormatMixin],

  render: function() {
    return (
      <div className="sidebar">
        <h3 className='dashboard-header-text text-capitalize'>Your Relationship Manager</h3>
        { this.props.Manager ?
          <div className='row'>
            <div className='col-xs-4'>
              <img src={this.props.Manager.user.avatar_url} className="avatar"/>
            </div>
            <div className='col-xs-8'>
              <h4 className="account-name-text">{this.props.Manager.user.to_s}</h4>
              <p>
                <span className="glyphicon glyphicon-earphone"></span>
                {this.formatPhoneNumber(this.props.Manager.phone_number)}
              </p>
              <p>
                <span className="glyphicon glyphicon-envelope"></span>
                <a href={'mailto:' + this.props.Manager.user.email}>
                  {this.props.Manager.user.email}
                </a>
              </p>
            </div>
          </div>
          :
          'There is not relationship manager'
        }

        { (this.props.ActiveTab == 'overview') ?
          <div>
            <h3 className='dashboard-header-text padding-top-10'>Recent Loan Activity</h3>
            <RecentLoanActivities LoanActivityList={this.props.LoanActivities}/>
          </div>
          :
          <div>
            <div>
              <h3 className="dashboard-header-text padding-top-10">Helpful Q&A</h3>
            </div>
            <div className="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
              <div className="panel">
                <div className="panel-heading" role="tab" id="headingOne">
                  <h4 className="panel-title">
                    <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="false" aria-controls="collapseOne" className="collapsed">
                      What are these files?
                    </a>
                  </h4>
                </div>
                <div id="collapseOne" className="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne" aria-expanded="false">
                  <div className="panel-body">
                    <p>Sed quis varius dolor, vitae lacinia purus. Etiam ultrices non sapien vel elementum. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                  </div>
                </div>
              </div>
              <div className="panel">
                <div className="panel-heading" role="tab" id="headingTwo">
                  <h4 className="panel-title">
                    <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo" className="collapsed">
                      What are the difference tabs?
                    </a>
                  </h4>
                </div>
                <div id="collapseTwo" className="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo" aria-expanded="false">
                  <div className="panel-body">
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin suscipit non elit nec placerat. Praesent sed felis at risus lobortis volutpat. Sed quis varius dolor, vitae lacinia purus. Etiam ultrices non sapien vel elementum. Curabitur tincidunt elementum lacus, quis pellentesque tortor maximu.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        }
      </div>
    )
  }
});

module.exports = RelationshipManager;