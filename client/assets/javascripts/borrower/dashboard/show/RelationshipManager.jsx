var React = require('react/addons');

var RecentLoanActivities = require('./RecentLoanActivities');

var RelationshipManager = React.createClass({
  render: function() {
    return (
      <div>
        <h5 className='ptl bbs pbm'>Your Relationship Manager</h5>
        { this.props.Manager ?
          <div className='ptm typeEmphasize clearfix'>
            <div className='manager-image pull-left mrm'>
              <img src={this.props.Manager.user.avatar_url} width="80px" height="80px"/>
            </div>
            <div className='manager-info pull-left'>
              <p>{this.props.Manager.user.to_s}</p>
              <p>{this.props.Manager.phone_number}</p>
              <p><a href='javascript:void(0)'>Skype Call</a></p>
              <p><a href={'mailto:' + this.props.Manager.user.email}>{this.props.Manager.user.email}</a></p>
            </div>
          </div>
          :
          'There is not relationship manager'
        }

        { (this.props.ActiveTab == 'overview') ?
          <div>
            <h5 className='ptl bbs pbm'>Recent Loan Activity</h5>
            <RecentLoanActivities LoanActivityList={this.props.LoanActivities}/>
          </div>
          :
          <div>
            <div className='pvm bbs'>
              <h5>Helpful Q&A</h5>
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