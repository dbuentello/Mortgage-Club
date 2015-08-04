var _ = require('lodash');
var React = require('react/addons');
var BorrowerTab = require('./BorrowerTab');
var ContactTab = require('./ContactTab');
var PropertyTab = require('./PropertyTab');
var LoanTab = require('./LoanTab');
var UserInfo = require('./UserInfo');
var TextFormatMixin = require('mixins/TextFormatMixin');

var Dashboard = React.createClass({
  mixins: [TextFormatMixin],

  render: function() {
    var current_user = this.props.bootstrapData.currentUser;
    var docList = this.props.bootstrapData.doc_list;
    var address = this.props.bootstrapData.address;
    var loan    = this.props.bootstrapData.loan;
    var property = this.props.bootstrapData.loan.property;
    var contactList = this.props.bootstrapData.contact_list;
    var propertyList = this.props.bootstrapData.property_list;
    var loanList = this.props.bootstrapData.loan_list;

    return (
      <div className='dashboard content'>
        <div className='dashboard-header row mbl'>
          <div className='col-xs-offset-2 col-xs-6 ptl'>
            <h3 className='typeBold'>{address}</h3>
            <h4>{this.formatCurrency(loan.amount, '$')}k {loan.num_of_years}-year fixed {loan.ltv_formula}% LTV {property.usage_name} {loan.purpose_titleize} Loan</h4>
          </div>
          <div className='col-xs-4 ptl'>
            <a className='btn btnSml btnSecondary mlm' href='#'>Edit Application</a>
            <a className='btn btnSml btnPrimary mlm' href='/loans/new'>New Loan</a>
          </div>
        </div>

        <div className='dashboard-tabs plxl prxl backgroundLowlight'>
          <ul className="nav nav-tabs" role="tablist">
            <li role="presentation" className="active">
              <a href="#overview" aria-controls="overview" role="tab" data-toggle="tab">Overview</a>
            </li>
            <li role="presentation">
              <a href="#property" aria-controls="property" role="tab" data-toggle="tab">Property</a>
            </li>
            <li role="presentation">
              <a href="#borrower" aria-controls="borrower" role="tab" data-toggle="tab">Borrower</a>
            </li>
            <li role="presentation">
              <a href="#loan" aria-controls="loan" role="tab" data-toggle="tab">Loan</a>
            </li>
            <li role="presentation">
              <a href="#closing" aria-controls="closing" role="tab" data-toggle="tab">Closing</a>
            </li>
            <li role="presentation">
              <a href="#contacts" aria-controls="contacts" role="tab" data-toggle="tab">Contacts</a>
            </li>
          </ul>

          <div className='tabs row'>
            <div className='left-side col-xs-8'>
              <div className="tab-content">
                <div role="tabpanel" className="tab-pane fade in active" id="overview">
                </div>
                <div role="tabpanel" className="tab-pane fade" id="property">
                  <PropertyTab propertyList={propertyList}></PropertyTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="borrower">
                  <BorrowerTab docList={docList}></BorrowerTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="loan">
                  <LoanTab loanList={loanList}></LoanTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="closing">
                  closing
                </div>
                <div role="tabpanel" className="tab-pane fade" id="contacts">
                  <ContactTab contactList={contactList}></ContactTab>
                </div>
              </div>
            </div>

            <div className='right-side col-xs-4'>
              <UserInfo info={current_user}></UserInfo>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Dashboard;