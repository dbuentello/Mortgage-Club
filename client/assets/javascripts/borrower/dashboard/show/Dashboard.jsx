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
var TermTab = require('./tabs/TermTab');
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

  viewLoan: function(){
    location.href = '/loans/' + this.props.bootstrapData.loan.id;
  },

  render: function() {
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
    var termInfo = this.props.bootstrapData.term_info

    return (
      <div className="content loan-dashboard">
        <div className="container">
          <div className='row dashboard-top'>
            <div className='col-md-9'>
              {
                property.zillow_image_url
                ?
                  <img src={property.zillow_image_url}/>
                :
                  <img src="/default.jpg"/>
              }
              <h3 className='typeBold'>{address}</h3>
              {
                loan.amount
                ?
                  <p>{this.formatCurrency(loan.amount, '$')} {loan.amortization_type} {property.usage_name} {loan.purpose_titleize} Loan</p>
                :
                  null
              }
              <p>Status: {loan.pretty_status}</p>
            </div>
            <div className='col-md-3'>
              <ModalLink
                id="viewLoan"
                icon="iconInfo mrs"
                name="View"
                title={null}
                class="btn edit-btn"
                bodyClass="mc-blue-primary-text"
                body="You are about to view your application only. You cannot make any edits since it was already submitted."
                labelNo="Cancel"
                labelYes="Proceed"
                yesCallback={this.viewLoan} />

              <ModalLink
                id="deleteLoan"
                icon="iconTrash mrs"
                name="Delete"
                title={null}
                class="btn delete-btn"
                bodyClass="mc-blue-primary-text"
                body="Are you sure you want to destroy this loan?"
                yesCallback={this.destroyLoan}
              />
            </div>
          </div>
          <div className="collapse navbar-collapse" id="links-dashboard">
            <ul className="nav nav-tabs mortgageTabs" role="tablist">
              <li role="presentation" className="active">
                <a href="#overview" aria-controls="overview" role="tab" data-toggle="tab">Overview</a>
              </li>
              <li role="presentation">
                <a href="#terms" aria-controls="terms" role="tab" data-toggle="tab">Terms</a>
              </li>
              <li role="presentation">
                <a href="#property" aria-controls="property" role="tab" data-toggle="tab">Property</a>
              </li>
              <li role="presentation">
                <a href="#borrower" aria-controls="borrower" role="tab" data-toggle="tab">Borrower</a>
              </li>
              <li role="presentation">
                <a href="#loan" aria-controls="loan" role="tab" data-toggle="tab">Loan</a></li>
              <li role="presentation">
                <a href="#closing" aria-controls="closing" role="tab" data-toggle="tab">Closing</a>
              </li>
              <li role="presentation">
                <a href="#contacts" aria-controls="contacts" role="tab" data-toggle="tab">Contacts</a>
              </li>
            </ul>
          </div>

          <div className='tabs row'>
            <div className='col-md-8'>
              <div className="tab-content">
                <div role="tabpanel" className="tab-pane fade in active" id="overview">
                  <OverviewTab loan={loan} borrower={loan.borrower} checklists={checklists} />
                </div>
                <div role="tabpanel" className="tab-pane fade" id="terms">
                  <TermTab termInfo={termInfo} loan={loan} address={address}></TermTab>
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

            <div className='col-md-4'>
              <RelationshipManager manager={manager} LoanActivities={this.props.bootstrapData.loan_activities} FaqsList={this.props.bootstrapData.faqs_list} ActiveTab={this.state.activeTab}></RelationshipManager>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Dashboard;