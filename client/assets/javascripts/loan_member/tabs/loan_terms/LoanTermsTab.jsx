var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var TextField = require("components/form/TextField");
var SelectField = require("components/form/SelectField");
var AddressField = require("components/form/AddressField");
var BooleanRadio = require('components/form/BooleanRadio');
var DateField = require('components/form/DateField');

var fields = {
  address: {label: "Property Address", name: "address"},
  propertyValue: {label: "Property Value", name: "property_value"},
  loanAmount: {label: "Loan Amount", name: "loan_amount"},
  loanType: {label: "Loan Type", name: "loan_type"},
  interestRate: {label: "Interest Rate (%)", name: "interest_rate"},
  lenderCredits: {label: "Lender Credit / Discount Points", name: "lender_credits"},
  downPayment: {label: "Down Payment", name: "down_payment"},
  totalCashToClose: {label: "Total Cash to Close (est.)", name: "total_cash_to_close"},
  principalInterest: {label: "Principal and Interest", name: "principal_interest"},
  homeownersInsurance: {label: "Homeowners Insurance", name: "homeowners_insurance"},
  propertyTax: {label: "Property Tax", name: "property_tax"},
  hoaDue: {label: "HOA Due", name: "hoa_due"},
  mortgageInsurance: {label: "Mortgage Insurance", name: "mortgage_insurance"},
  lenderUnderwritingFee: {label: "Lender Underwriting Fee", name: "lender_underwriting_fee"},
  appraisalFee: {label: "Appraisal Fee", name: "appraisal_fee"},
  taxCertificationFee: {label: "Tax Certification Fee", name: "tax_certification_fee"},
  floodCertificationFee: {label: "Flood Certification Fee", name: "flood_certification_fee"},
  outsideSigningService: {label: "Outside Signing Service", name: "outside_signing_service_fee"},
  concurrentLoanCharge: {label: "Title - Concurrent Loan Charge", name: "concurrent_loan_charge_fee"},
  endorsementCharge: {label: "Endorsement Charge", name: "endorsement_charge_fee"},
  lenderTitlePolicy: {label: "Title - Lender's Title Policy", name: "lender_title_policy_fee"},
  recordingServiceFee: {label: "Title - Recording Service Fee", name: "recording_service_fee"},
  settlementAgentFee: {label: "Title - Settlement Agent Fee", name: "settlement_agent_fee"},
  recordingFees: {label: "Recording Fees", name: "recording_fees"},
  ownerTitlePolicy: {label: "Title - Owner's Title Policy", name: "owner_title_policy_fee"},
  prepaidInterest: {label: "Prepaid Interest", name: "prepaid_item_fee"},
  prepaidHomeowners: {label: "Prepaid Homeowners Insurance for 12 Months", name: "prepaid_homeowners_insurance"},
  isRateLocked: {label: "Rate Lock", name: "is_rate_locked"},
  rateLockExpirationDate: {label: "Rate Lock Expiration Date", name: "rate_lock_expiration_date"}
};

var loanTypeOptions = [
  {name: "", value: ""},
  {name: "30 year fixed", value: "30 year fixed"},
  {name: "15 year fixed", value: "15 year fixed"},
  {name: "10 year fixed", value: "10 year fixed"},
  {name: "7/1 ARM", value: "7/1 ARM"},
  {name: "5/1 ARM", value: "5/1 ARM"},
  {name: "3/1 ARM", value: "3/1 ARM"},
  {name: "1/1 ARM", value: "1/1 ARM"}
];

var LoanTermsTab = React.createClass({
  mixins: [TextFormatMixin],

  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function() {
    return this.buildState(this.props.loan, this.props.property);
  },

  buildState: function(loan, property) {
    var state = {};
    var propertyValue = loan.purpose == "purchase" ? property.purchase_price : property.market_price;

    state[fields.address.name] = property.address;
    state[fields.loanType.name] = loan.amortization_type;
    state[fields.propertyValue.name] = this.formatCurrency(propertyValue, "$");
    state[fields.loanAmount.name] = this.formatCurrency(loan.amount, "$");
    state[fields.interestRate.name] = this.commafy(loan.interest_rate * 100, 3);
    state[fields.lenderCredits.name] = this.formatCurrency(loan.lender_credits, "$");
    state[fields.downPayment.name] = this.formatCurrency(loan.down_payment, "$");
    state[fields.totalCashToClose.name] = this.formatCurrency(loan.estimated_cash_to_close, "$");
    state[fields.principalInterest.name] = this.formatCurrency(loan.monthly_payment, "$");
    state[fields.homeownersInsurance.name] = this.formatCurrency(property.estimated_hazard_insurance, "$");
    state[fields.propertyTax.name] = this.formatCurrency(property.estimated_property_tax, "$");
    state[fields.hoaDue.name] = this.formatCurrency(property.hoa_due, "$");
    state[fields.mortgageInsurance.name] = this.formatCurrency(property.estimated_mortgage_insurance, "$");
    state[fields.lenderUnderwritingFee.name] = this.formatCurrency(loan.lender_underwriting_fee, "$");
    state[fields.appraisalFee.name] = this.formatCurrency(loan.appraisal_fee, "$");
    state[fields.taxCertificationFee.name] = this.formatCurrency(loan.tax_certification_fee, "$");
    state[fields.floodCertificationFee.name] = this.formatCurrency(loan.flood_certification_fee, "$");
    state[fields.outsideSigningService.name] = this.formatCurrency(loan.outside_signing_service_fee, "$");
    state[fields.concurrentLoanCharge.name] = this.formatCurrency(loan.concurrent_loan_charge_fee, "$");
    state[fields.endorsementCharge.name] = this.formatCurrency(loan.endorsement_charge_fee, "$");
    state[fields.lenderTitlePolicy.name] = this.formatCurrency(loan.lender_title_policy_fee, "$");
    state[fields.recordingServiceFee.name] = this.formatCurrency(loan.recording_service_fee, "$");
    state[fields.settlementAgentFee.name] = this.formatCurrency(loan.settlement_agent_fee, "$");
    state[fields.recordingFees.name] = this.formatCurrency(loan.recording_fees, "$");
    state[fields.ownerTitlePolicy.name] = this.formatCurrency(loan.owner_title_policy_fee, "$");
    state[fields.prepaidInterest.name] = this.formatCurrency(loan.prepaid_item_fee, "$");
    state[fields.prepaidHomeowners.name] = this.formatCurrency(loan.prepaid_homeowners_insurance, "$");
    state[fields.isRateLocked.name] = loan.is_rate_locked;
    state[fields.rateLockExpirationDate.name] = loan.rate_lock_expiration_date;
    return state;
  },

  onChange: function(change) {
    this.setState(change);
  },

  onBlur: function(blur) {
    this.setState(blur);
  },

  onSubmit: function(event) {
    event.preventDefault();
    this.setState({saving: true});
    $.ajax({
      url: "/loan_members/loans/" + this.props.loan.id + "/update_loan_terms",
      data: {
        address: this.state[fields.address.name] ? this.state[fields.address.name] : {no_data: true},
        property_value: this.currencyToNumber(this.state[fields.propertyValue.name]),
        loan_amount: this.currencyToNumber(this.state[fields.loanAmount.name]),
        loan_type: this.state[fields.loanType.name],
        interest_rate: this.state[fields.interestRate.name] / 100,
        lender_credits: this.currencyToNumber(this.state[fields.lenderCredits.name]),
        down_payment: this.currencyToNumber(this.state[fields.downPayment.name]),
        total_cash_to_close: this.currencyToNumber(this.state[fields.totalCashToClose.name]),
        principal_interest: this.currencyToNumber(this.state[fields.principalInterest.name]),
        homeowners_insurance: this.currencyToNumber(this.state[fields.homeownersInsurance.name]),
        property_tax: this.currencyToNumber(this.state[fields.propertyTax.name]),
        hoa_due: this.currencyToNumber(this.state[fields.hoaDue.name]),
        mortgage_insurance: this.currencyToNumber(this.state[fields.mortgageInsurance.name]),
        lender_underwriting_fee: this.currencyToNumber(this.state[fields.lenderUnderwritingFee.name]),
        appraisal_fee: this.currencyToNumber(this.state[fields.appraisalFee.name]),
        tax_certification_fee: this.currencyToNumber(this.state[fields.taxCertificationFee.name]),
        flood_certification_fee: this.currencyToNumber(this.state[fields.floodCertificationFee.name]),
        outside_signing_service_fee: this.currencyToNumber(this.state[fields.outsideSigningService.name]),
        concurrent_loan_charge_fee: this.currencyToNumber(this.state[fields.concurrentLoanCharge.name]),
        endorsement_charge_fee: this.currencyToNumber(this.state[fields.endorsementCharge.name]),
        lender_title_policy_fee: this.currencyToNumber(this.state[fields.lenderTitlePolicy.name]),
        recording_service_fee: this.currencyToNumber(this.state[fields.recordingServiceFee.name]),
        settlement_agent_fee: this.currencyToNumber(this.state[fields.settlementAgentFee.name]),
        recording_fees: this.currencyToNumber(this.state[fields.recordingFees.name]),
        owner_title_policy_fee: this.currencyToNumber(this.state[fields.ownerTitlePolicy.name]),
        prepaid_item_fee: this.currencyToNumber(this.state[fields.prepaidInterest.name]),
        prepaid_homeowners_insurance: this.currencyToNumber(this.state[fields.prepaidHomeowners.name]),
        is_rate_locked: this.state[fields.isRateLocked.name],
        rate_lock_expiration_date: this.state[fields.rateLockExpirationDate.name]
      },
      method: "POST",
      dataType: "json",
      success: function(response) {
        this.setState({saving: false});
        var state = this.buildState(response.loan, response.property);
        this.setState(state);
        // location.href = "/quotes/" + response.code_id;
      }.bind(this),
      error: function(response){
        this.setState({saving: false});
      }.bind(this)
    });
  },

  render: function() {
    return (
      <div id="loan-terms-page">
        <div className="panel panel-flat">
          <div className="panel-heading">
            <h4 className="panel-title">Loan Terms</h4>
          </div>
          <form className="form-horizontal form-checklist">
            <div className="panel-heading">
              <h4 className="panel-title">Loan Summary</h4>
            </div>
            <input type="hidden" value={this.props.loan.id} name="loan_id"/>
            <div className="form-group">
              <div className="col-sm-6">
                <AddressField label={fields.address.label}
                  address={this.state[fields.address.name]}
                  keyName={fields.address.name}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.propertyValue.label}
                  keyName={fields.propertyValue.name}
                  value={this.state[fields.propertyValue.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.loanAmount.label}
                  keyName={fields.loanAmount.name}
                  value={this.state[fields.loanAmount.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <SelectField
                  label={fields.loanType.label}
                  keyName={fields.loanType.name}
                  options={loanTypeOptions}
                  editable={true}
                  onChange={this.onChange}
                  value={this.state[fields.loanType.name]}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.interestRate.label}
                  keyName={fields.interestRate.name}
                  value={this.state[fields.interestRate.name]}
                  liveFormat={true}
                  format={this.formatNumber}
                  onChange={this.onChange}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <BooleanRadio
                  label={fields.isRateLocked.label}
                  isDeclaration={true}
                  keyName={fields.isRateLocked.name}
                  customColumn={"col-xs-2"}
                  checked={this.state[fields.isRateLocked.name]}
                  onChange={this.onChange}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <DateField
                  label={fields.rateLockExpirationDate.label}
                  keyName={fields.rateLockExpirationDate.name}
                  value={this.state[fields.rateLockExpirationDate.name]}
                  onChange={this.onChange}
                  editable={true}/>
              </div>
            </div>
            <div className="panel-heading">
              <h4 className="panel-title">Closing Costs</h4>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.lenderCredits.label}
                  keyName={fields.lenderCredits.name}
                  value={this.state[fields.lenderCredits.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.lenderUnderwritingFee.label}
                  keyName={fields.lenderUnderwritingFee.name}
                  value={this.state[fields.lenderUnderwritingFee.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.appraisalFee.label}
                  keyName={fields.appraisalFee.name}
                  value={this.state[fields.appraisalFee.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.taxCertificationFee.label}
                  keyName={fields.taxCertificationFee.name}
                  value={this.state[fields.taxCertificationFee.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.floodCertificationFee.label}
                  keyName={fields.floodCertificationFee.name}
                  value={this.state[fields.floodCertificationFee.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.outsideSigningService.label}
                  keyName={fields.outsideSigningService.name}
                  value={this.state[fields.outsideSigningService.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.concurrentLoanCharge.label}
                  keyName={fields.concurrentLoanCharge.name}
                  value={this.state[fields.concurrentLoanCharge.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.endorsementCharge.label}
                  keyName={fields.endorsementCharge.name}
                  value={this.state[fields.endorsementCharge.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.lenderTitlePolicy.label}
                  keyName={fields.lenderTitlePolicy.name}
                  value={this.state[fields.lenderTitlePolicy.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.recordingServiceFee.label}
                  keyName={fields.recordingServiceFee.name}
                  value={this.state[fields.recordingServiceFee.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.settlementAgentFee.label}
                  keyName={fields.settlementAgentFee.name}
                  value={this.state[fields.settlementAgentFee.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.recordingFees.label}
                  keyName={fields.recordingFees.name}
                  value={this.state[fields.recordingFees.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.ownerTitlePolicy.label}
                  keyName={fields.ownerTitlePolicy.name}
                  value={this.state[fields.ownerTitlePolicy.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.prepaidInterest.label}
                  keyName={fields.prepaidInterest.name}
                  value={this.state[fields.prepaidInterest.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.prepaidHomeowners.label}
                  keyName={fields.prepaidHomeowners.name}
                  value={this.state[fields.prepaidHomeowners.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.downPayment.label}
                  keyName={fields.downPayment.name}
                  value={this.state[fields.downPayment.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.totalCashToClose.label}
                  keyName={fields.totalCashToClose.name}
                  value={this.state[fields.totalCashToClose.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="panel-heading">
              <h4 className="panel-title">Housing Expense</h4>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.principalInterest.label}
                  keyName={fields.principalInterest.name}
                  value={this.state[fields.principalInterest.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.homeownersInsurance.label}
                  keyName={fields.homeownersInsurance.name}
                  value={this.state[fields.homeownersInsurance.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.propertyTax.label}
                  keyName={fields.propertyTax.name}
                  value={this.state[fields.propertyTax.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.hoaDue.label}
                  keyName={fields.hoaDue.name}
                  value={this.state[fields.hoaDue.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.mortgageInsurance.label}
                  keyName={fields.mortgageInsurance.name}
                  value={this.state[fields.mortgageInsurance.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <button className="btn btn-primary" id="submit-loan-terms" onClick={this.onSubmit} disabled={this.state.saving}>{ this.state.saving ? "Submitting" : "Submit" }</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    )
  }

});

module.exports = LoanTermsTab;
