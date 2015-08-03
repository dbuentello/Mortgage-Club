var _ = require('lodash');
var React = require('react/addons');
var BorrowerTab = require('./BorrowerTab');
var UserInfo = require('./UserInfo');

var Dashboard = React.createClass({
  render: function() {
    var current_user = this.props.bootstrapData.currentUser;
    var docList = this.props.bootstrapData.doc_list;
    var address = this.props.bootstrapData.address;

    return (
      <div className='dashboard'>
        <div className='dashboard-header'>
          <div className='col-xs-12 pbxl'>
            <div className='col-xs-2'>
            </div>
            <div className='col-xs-6 ptl'>
              <h3 className='typeBold'>{address}</h3>
              <h4>$800k 30-year fixed 80% LTV Primary Residence Purchase Loan</h4>
            </div>
            <div className='col-xs-4 ptl'>
              <a className='btn btnSml btnSecondary mlm' href='#'>Edit Application</a>
              <a className='btn btnSml btnPrimary mlm' href='/loans/new'>New Loan</a>
            </div>
          </div>
        </div>
        <div className='col-xs-12 plxl prxl backgroundLowlight'>
          <ul className="nav nav-tabs" >
            <li role="presentation" className="active">
              <a href="#borrower" aria-controls="borrower" role="tab" data-toggle="tab">Borrower</a>
            </li>
          </ul>
          <div className='col-xs-7'>
            <div className="tab-content">
              <BorrowerTab docList={docList}></BorrowerTab>
            </div>
          </div>
          <div className='col-xs-5'>
            <UserInfo info={current_user}></UserInfo>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Dashboard;