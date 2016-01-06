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
            <div className='mbl'>
              <p><a href='javascript:void(0)'>What are these files?</a></p>
              <p><a href='javascript:void(0)'>Who has access to these?</a></p>
              <p><a href='javascript:void(0)'>What are the different tabs?</a></p>
              <p><a href='javascript:void(0)'>Do I have to classify files?</a></p>
              <p><a href='javascript:void(0)'>Are my files safe?</a></p>
            </div>
          </div>
        }
      </div>
    )
  }
});

module.exports = RelationshipManager;