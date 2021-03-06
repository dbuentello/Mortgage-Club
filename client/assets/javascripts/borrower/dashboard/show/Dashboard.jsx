/**
 * Show loan's information, checklist, file ...
 * if loan's status is not 'new'
 * TODO: refactor hardcode mess ( modallink viewloan and delete loan)
 */

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
      activeTab: 'overview',
      loan: this.props.bootstrapData.loan
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
  // TODO: should remove. Unused
  destroyLoan: function() {
    $.ajax({
      url: '/loans/' + this.state.loan.id,
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

  updateRate: function(){
    $(".btnUpdateRate").attr('disabled','disabled');
    $.ajax({
      url: '/my/dashboard/update_rate',
      method: 'POST',
      dataType: 'json',
      data: {
        id: this.state.loan.id
      },
      success: function(response) {
        this.setState({loan: response.loan});
        $(".btnUpdateRate").removeAttr('disabled');

        if(response.error !== undefined){
          this.setState({updateRateErrorMessage: response.error});
        }
      }.bind(this),
      error: function(response, status, error) {
        var flash = { "alert-danger": response.message };
        this.showFlashes(flash);

        $(".btnUpdateRate").removeAttr('disabled');
      }.bind(this)
    });
  },

  viewLoan: function(){
    location.href = '/loans/' + this.state.loan.id;
  },

  requestRateLockValid: function(){
    var beginningTime = moment.tz("7:30:00 am", "h:mm:ss a", "America/Los_Angeles");
    var endTime = moment.tz("4:00:00 pm", "h:mm:ss a", "America/Los_Angeles");
    var currentTime = moment.tz(new Date(), "America/Los_Angeles");
    var updatedRateTime = moment.tz(this.state.loan.updated_rate_time, "America/Los_Angeles");

    if(!currentTime.isBetween(beginningTime, endTime) || currentTime.isoWeekday() == 6 || currentTime.isoWeekday() == 7){
      this.setState({
        requestRateLockAlert: "Sorry, we can only lock in rate from 7:30am - 4:00pm PST, Monday - Friday. Please request rate lock during those hours."
      });

      $("#rate-lock-alert").css("color", "red");
      return false;
    }

    if(updatedRateTime.add(5, "minutes").isBefore(currentTime)){
      this.setState({
        requestRateLockAlert: "Please update rate and terms under Terms tab before requesting rate lock!"
      });

      $("#rate-lock-alert").css("color", "red");
      return false;
    }

    return true;
  },

  requestRateLock: function(){
    if(this.requestRateLockValid()){
      $.ajax({
        url: '/my/dashboard/request_rate_lock',
        method: 'POST',
        dataType: 'json',
        data: {
          id: this.state.loan.id
        },
        success: function(response) {
          this.setState({
            loan: response.loan,
            requestRateLockAlert: response.alert
          });
          $("#rate-lock-alert").css("color", "green");
        }.bind(this),
        error: function(response, status, error) {
          var flash = { "alert-danger": response.message };
          this.showFlashes(flash);
        }.bind(this)
      });
    }
  },

  render: function() {
    var address = this.props.bootstrapData.address;
    var loan    = this.state.loan;
    var property = this.state.loan.subject_property;
    var contactList = this.props.bootstrapData.contact_list;
    var propertyDocuments = this.props.bootstrapData.property_documents;
    var loanDocuments = this.props.bootstrapData.loan_documents;
    var borrowerDocuments = this.props.bootstrapData.borrower_documents;
    var coBorrower = this.state.loan.secondary_borrower;
    var closingDocuments = this.props.bootstrapData.closing_documents;
    var manager = this.props.bootstrapData.manager;
    var checklists = this.props.bootstrapData.checklists;

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
                  <p style={{"margin-bottom": "0px"}}>{this.formatCurrency(loan.amount, '$')} - {loan.amortization_type} - {property.usage_name} - {loan.purpose_titleize} Loan</p>
                :
                  null
              }
              <p style={{"margin-bottom": "0px"}}>Status: {loan.pretty_status} - Rate: {this.commafy(loan.interest_rate*100, 3)}% ({loan.is_rate_locked == true ? "locked" : "not locked"})</p>
              {
                loan.is_rate_locked == true
                ?
                  null
                :
                  <p style={{"cursor": "pointer"}} onClick={this.requestRateLock}><a>Request rate lock</a></p>
              }
              <p id="rate-lock-alert">{this.state.requestRateLockAlert}</p>
            </div>

            <div className='col-md-3'>
              <ModalLink
                id="viewLoan"
                name="View Application"
                title={null}
                class="btn edit-btn"
                bodyClass="mc-blue-primary-text"
                body="You are about to view your application only. You cannot make any edits since it was already submitted."
                labelNo="Cancel"
                labelYes="Proceed"
                yesCallback={this.viewLoan} />
              {
                loan.pretty_status == "New"
                ?
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
                : ""
              }
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
                  <TermTab loan={loan} address={address} updateRate={this.updateRate} updateRateErrorMessage={this.state.updateRateErrorMessage}></TermTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="property">
                  <PropertyTab propertyDocuments={propertyDocuments}></PropertyTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="borrower">
                  <BorrowerTab borrowerDocuments={borrowerDocuments} coBorrower={coBorrower}></BorrowerTab>
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
