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
              <a href="#loans">Loans</a>
            </li>
            <li >
              <a href="#referrals">Referrals</a>
            </li>
            <li >
              <a href="#settings">Settings</a>
            </li>
          </ul>

          <div className='tabs row'>
            <div className="tab-content">
              <div className="tab-pane fade in active" id="loanList">
                <div className="box boxBasic backgroundBasic">
                  <div className='boxHead bbs'>
                    <h3 className='typeBold plxl'>Loan List</h3>
                  </div>
                  <div className="boxBody ptm">
                    {this.props.bootstrapData.message}
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