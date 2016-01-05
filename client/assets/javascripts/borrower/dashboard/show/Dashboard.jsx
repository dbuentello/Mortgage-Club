var _ = require('lodash');
var React = require('react/addons');

var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var FlashHandler = require('mixins/FlashHandler');
var ModalLink = require('components/ModalLink');

var OverviewTab = require('./tabs/OverviewTab');
var BorrowerTab = require('./tabs/BorrowerTab');
var ContactTab = require('./tabs/ContactTab');
var PropertyTab = require('./tabs/PropertyTab');
var LoanTab = require('./tabs/LoanTab');
var ClosingTab = require('./tabs/ClosingTab');
var RelationshipManager = require('./RelationshipManager');

var Dashboard = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin, FlashHandler],

  getInitialState: function() {
    return {
      activeTab: 'overview'
    };
  },

  componentDidMount: function() {
    // add event handler for tab navigation
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
      this.setState({
        activeTab: this.getValue(e.target.attributes, 'aria-controls').value
      });
    }.bind(this));
  },

  destroyLoan: function() {
    $.ajax({
      url: '/loans/' + this.props.bootstrapData.loan.id,
      method: 'DELETE',
      dataType: 'json',
      success: function(response) {
        location.href = response.redirect_path;
      },
      error: function(response, status, error) {
        var flash = { "alert-danger": response.message };
        this.showFlashes(flash);
      }.bind(this)
    });
  },

  render: function() {
    var current_user = this.props.bootstrapData.currentUser;
    var address = this.props.bootstrapData.address;
    var loan    = this.props.bootstrapData.loan;
    var property = this.props.bootstrapData.loan.subject_property;
    var contactList = this.props.bootstrapData.contact_list;
    var propertyDocuments = this.props.bootstrapData.property_documents;
    var loanDocuments = this.props.bootstrapData.loan_documents;
    var borrowerDocuments = this.props.bootstrapData.borrower_documents;
    var closingDocuments = this.props.bootstrapData.closing_documents;
    var manager = this.props.bootstrapData.manager;
    var checklists = this.props.bootstrapData.checklists;

    return (
      <div className='dashboard content'>
        <div className='dashboard-header row mbl'>
          <div className='col-xs-offset-2 col-xs-6 ptl'>
            <h3 className='typeBold'>{address}</h3>
            {
              loan.amount
              ?
                <h4>{this.formatCurrency(loan.amount, '$')} {loan.amortization_type} {property.usage_name} {loan.purpose_titleize} Loan</h4>
              :
                null
            }
          </div>
          <div className='col-xs-4 ptl'>
            <a className='btn edit-btn' href={'/loans/' + loan.id + '/edit'}><i className="iconPencil mrs"/>Edit</a>
            <ModalLink
              id="deleteLoan"
              icon="iconTrash mrs"
              name="Delete"
              class="btn delete-btn"
              title="Confirmation"
              body="Are you sure to destroy this loan?"
              yesCallback={this.destroyLoan}
            />
          </div>
        </div>

        <div className='dashboard-tabs phxl backgroundLowlight'>
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
                  <OverviewTab loan={loan} borrower={loan.borrower} checklists={checklists} />
                </div>
                <div role="tabpanel" className="tab-pane fade" id="property">
                  <PropertyTab propertyDocuments={propertyDocuments}></PropertyTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="borrower">
                  <BorrowerTab borrowerDocuments={borrowerDocuments}></BorrowerTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="loan">
                  <LoanTab loanDocuments={loanDocuments}></LoanTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="closing">
                  <ClosingTab closingDocuments={closingDocuments}></ClosingTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="contacts">
                  <ContactTab contactList={contactList}></ContactTab>
                </div>
              </div>
            </div>

            <div className='right-side col-xs-4'>
              <RelationshipManager Manager={manager} LoanActivities={this.props.bootstrapData.loan_activities} ActiveTab={this.state.activeTab}></RelationshipManager>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Dashboard;