var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var TextField = require("components/form/TextField");
var SelectField = require("components/form/SelectField");
var AddressField = require("components/form/AddressField");

var fields = {
  address: {label: "Property Address", name: "address"},
  propertyValue: {label: "Property Value", name: "property_value"},
  loanAmount: {label: "Loan Amount", name: "loan_amount"},
  loanType: {label: "Loan Type", name: "loan_type"},
  interestRate: {label: "Interest Rate (%)", name: "interest_rate"},
  lenderCredits: {label: "Lender Credits / Discount Points", name: "lender_credits"},
  lenderFees: {label: "Lender Fees", name: "lender_fees"},
  thirdPartyServices: {label: "Third Party Services", name: "third_party_services"},
  prepaidItems: {label: "Prepaid Items", name: "prepaid_items"},
  downPayment: {label: "Down Payment", name: "down_payment"},
  totalCashToClose: {label: "Total Cash to Close (est.)", name: "total_cash_to_close"},
  principalInterest: {label: "Principal and Interest", name: "principal_interest"},
  homeownersInsurance: {label: "Homeowners Insurance", name: "homeowners_insurance"},
  propertyTax: {label: "Property Tax", name: "property_tax"},
  hoaDue: {label: "HOA Due", name: "hoa_due"},
  mortgageInsurance: {label: "Mortgage Insurance", name: "mortgage_insurance"}
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
    state[fields.lenderFees.name] = this.formatCurrency(loan.loan_costs, "$");
    state[fields.thirdPartyServices.name] = this.formatCurrency(loan.third_party_fees, "$");
    state[fields.prepaidItems.name] = this.formatCurrency(loan.estimated_prepaid_items, "$");
    state[fields.downPayment.name] = this.formatCurrency(loan.down_payment, "$");
    state[fields.totalCashToClose.name] = this.formatCurrency(loan.estimated_cash_to_close, "$");
    state[fields.principalInterest.name] = this.formatCurrency(loan.monthly_payment, "$");
    state[fields.homeownersInsurance.name] = this.formatCurrency(property.estimated_hazard_insurance, "$");
    state[fields.propertyTax.name] = this.formatCurrency(property.estimated_property_tax, "$");
    state[fields.hoaDue.name] = this.formatCurrency(property.hoa_due, "$");
    state[fields.mortgageInsurance.name] = this.formatCurrency(property.estimated_mortgage_insurance, "$");

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
        address: this.state[fields.address.name],
        property_value: this.currencyToNumber(this.state[fields.propertyValue.name]),
        loan_amount: this.currencyToNumber(this.state[fields.loanAmount.name]),
        loan_type: this.state[fields.loanType.name],
        interest_rate: this.state[fields.interestRate.name] / 100,
        lender_credits: this.currencyToNumber(this.state[fields.lenderCredits.name]),
        lender_fees: this.currencyToNumber(this.state[fields.lenderFees.name]),
        third_party_services: this.currencyToNumber(this.state[fields.thirdPartyServices.name]),
        prepaid_items: this.currencyToNumber(this.state[fields.prepaidItems.name]),
        down_payment: this.currencyToNumber(this.state[fields.downPayment.name]),
        total_cash_to_close: this.currencyToNumber(this.state[fields.totalCashToClose.name]),
        principal_interest: this.currencyToNumber(this.state[fields.principalInterest.name]),
        homeowners_insurance: this.currencyToNumber(this.state[fields.homeownersInsurance.name]),
        property_tax: this.currencyToNumber(this.state[fields.propertyTax.name]),
        hoa_due: this.currencyToNumber(this.state[fields.hoaDue.name]),
        mortgage_insurance: this.currencyToNumber(this.state[fields.mortgageInsurance.name])
      },
      method: "POST",
      dataType: "json",
      success: function(response) {
        this.setState({saving: false});
        console.dir(response.property)
        console.dir(response.property.address);
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
              <div className="col-md-4">
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
            </div>
            <div className="panel-heading">
              <h4 className="panel-title">Closing Cost</h4>
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
                  label={fields.lenderFees.label}
                  keyName={fields.lenderFees.name}
                  value={this.state[fields.lenderFees.name]}
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
                  label={fields.thirdPartyServices.label}
                  keyName={fields.thirdPartyServices.name}
                  value={this.state[fields.thirdPartyServices.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.prepaidItems.label}
                  keyName={fields.prepaidItems.name}
                  value={this.state[fields.prepaidItems.name]}
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
                  label={fields.downPayment.label}
                  keyName={fields.downPayment.name}
                  value={this.state[fields.downPayment.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  format={this.formatCurrency}
                  maxLength={11}
                  editable={true}/>
              </div>
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
              <div className="col-sm-6 col-md-offset-5">
                <button className="btn btn-primary" onClick={this.onSubmit} disabled={this.state.saving}>{ this.state.saving ? "Submitting" : "Submit" }</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    )
  }

});

module.exports = LoanTermsTab;
