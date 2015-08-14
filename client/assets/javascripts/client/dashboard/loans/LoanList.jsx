var _ = require('lodash');
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
  },

  render: function() {
    var current_user = this.props.bootstrapData.currentUser;
    var loans    = this.props.bootstrapData.loan;

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
                    <div className="col-sm-6 col-md-4">
                      <div className="thumbnail">
                        <img src="http://www.bcysth.ca/wp-content/uploads/2015/04/What-are-modular-homes.jpg" width="100%" height="200px"></img>
                        <div className="caption">
                          <h3>Loan Address</h3>
                          <p>Status: ...</p>
                          <p>Created at: ...</p>
                          <p>Loan amount: ...</p>
                          <p>Rate: ...</p>
                          <p>
                            <a href="/dashboard" className="btn btn-primary" role="button">Dashboard</a>
                          </p>
                        </div>
                      </div>
                    </div>

                    <div className="col-sm-6 col-md-4">
                      <div className="thumbnail">
                        <img src="http://hrtinsurancegroup.com/wp-content/uploads/2013/10/Home-Insurance-300x198.jpg" width="100%" height="200px"></img>
                        <div className="caption">
                          <h3>Loan Address</h3>
                          <p>Status: ...</p>
                          <p>Created at: ...</p>
                          <p>Loan amount: ...</p>
                          <p>Rate: ...</p>
                          <p>
                            <a href="/dashboard" className="btn btn-primary" role="button">Dashboard</a>
                          </p>
                        </div>
                      </div>
                    </div>
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