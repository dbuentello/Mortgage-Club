var _ = require('lodash');
var moment = require('moment');
var React = require('react/addons');

var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');

var LoanList = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],

  getInitialState: function() {
    return {
    };
  },

  componentDidMount: function() {
    // console.dir(this.props.bootstrapData.loans);
  },

  render: function() {
    var current_user = this.props.bootstrapData.currentUser;

    return (
      <div className='dashboard content'>
        <div className='dashboard-tabs phxl bts backgroundLowlight'>
          <ul className="nav nav-tabs">
            <li className="active">
              <a href="javascript:void(0)">Loans</a>
            </li>
            <li >
              <a href="javascript:void(0)">Referrals</a>
            </li>
            <li >
              <a href="javascript:void(0)">Settings</a>
            </li>
          </ul>

          <div className='tabs'>
            <div className="tab-content">
              <div className="tab-pane fade in active" id="loanList">

                <div className="loanList mtl">
                  <div className="row">
                    {
                      _.map( this.props.bootstrapData.loans, function(loan){
                        return (
                          <div className="col-sm-6 col-md-4" key={loan.id}>
                            <div className="thumbnail">
                              <img src="http://www.bcysth.ca/wp-content/uploads/2015/04/What-are-modular-homes.jpg" width="100%" height="200px"></img>
                              <div className="caption">
                                <h3>{loan.property.address.address}</h3>
                                <p>Status: Finishing</p>
                                <p>Created at: {moment(loan.created_at).format('MMM DD, YYYY')}</p>
                                <p>Loan amount: {loan.amount}</p>
                                <p>Rate: {loan.interest_rate}%</p>
                                <p>
                                  <a href={'/dashboard/' + loan.id + '/edit'} className="btn btn-primary" role="button">Dashboard</a>
                                </p>
                              </div>
                            </div>
                          </div>
                        )
                      })
                    }
                  </div>
                </div>
              </div>
              <div className="tab-pane fade" id="referrals">
              </div>
              <div className="tab-pane fade" id="settings">
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = LoanList;