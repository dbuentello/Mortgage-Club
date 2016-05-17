var React = require('react/addons');

var RecentLoanActivities = require('./RecentLoanActivities');
var FaqsList = require('./FaqsList');
var TextFormatMixin = require('mixins/TextFormatMixin');

var RelationshipManager = React.createClass({
  mixins: [TextFormatMixin],

  render: function() {
    return (
      <div className="sidebar">
        <h3 className='dashboard-header-text text-capitalize'>Your Mortgage Advisor</h3>
        { this.props.manager ?
          <div className='row'>
            <div className='col-xs-4'>
              <img src={this.props.manager.user.avatar_url} className="avatar"/>
            </div>
            <div className='col-xs-8'>
              <h4 className="account-name-text">{this.props.manager.user.first_name + " " + this.props.manager.user.last_name}</h4>
              <p>
                <span className="glyphicon glyphicon-user"></span>
                NMLS ID: {this.props.manager.nmls_id}
              </p>
              <p>
                <span className="glyphicon glyphicon-earphone"></span>
                {this.formatPhoneNumber(this.props.manager.phone_number)}
              </p>
              <p>
                <span className="glyphicon glyphicon-envelope"></span>
                <a href={'mailto:' + this.props.manager.user.email}>
                  {this.props.manager.user.email}
                </a>
              </p>
            </div>
          </div>
          :
          'There is not mortgage advisor'
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
            <FaqsList FaqsList={this.props.FaqsList}/>
          </div>
        }
      </div>
    )
  }
});

module.exports = RelationshipManager;