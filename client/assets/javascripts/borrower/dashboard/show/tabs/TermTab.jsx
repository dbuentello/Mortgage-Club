var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var TermTab = React.createClass({
  mixins: [TextFormatMixin],

  calculateMonthlyHousingExpense: function(monthlyPayment, homeOwnerInsurance, propertyTax, mortgageInsurance, hoaDue) {
    var expense = 0.0;
    if(parseFloat(hoaDue))
    {
      expense += parseFloat(hoaDue);
    }

    if(parseFloat(mortgageInsurance))
    {
      expense += parseFloat(mortgageInsurance);
    }

    expense += parseFloat(monthlyPayment);
    expense += (parseFloat(homeOwnerInsurance)/12);
    expense += (parseFloat(propertyTax)/12);
    return expense;
  },

  getPropertyValue: function(price) {
    return price ? this.formatCurrency(price, "$") : null;
  },

  isPurchaseLoan: function() {
    return this.props.loan.purpose_titleize == "Purchase";
  },

  showExpend: function(className, event) {
    if($("." + className).is(":hidden")){
      $(event.target).removeClass("icon-plus").addClass("icon-minus");
    } else {
      $(event.target).removeClass("icon-minus").addClass("icon-plus");
    }
    $("." + className).slideToggle();
  },

  render: function() {
    var loan = this.props.loan;
    var property = loan.subject_property;
    var propertyTax = property.estimated_property_tax;
    var homeOwnerInsurance = property.estimated_hazard_insurance;
    var monthlyPayment = loan.monthly_payment;
    var hoaDue = property.hoa_due
    var mortgageInsurance = property.estimated_mortgage_insurance;
    var totalCost = this.calculateMonthlyHousingExpense(monthlyPayment, homeOwnerInsurance, propertyTax, mortgageInsurance, hoaDue);
    var canNotShopForFee = (parseFloat(loan.appraisal_fee) || 0) + (parseFloat(loan.tax_certification_fee) || 0) + (parseFloat(loan.flood_certification_fee) || 0);
    var shopForFee = (parseFloat(loan.outside_signing_service_fee) || 0) + (parseFloat(loan.concurrent_loan_charge_fee) || 0) + (parseFloat(loan.endorsement_charge_fee) || 0) + (parseFloat(loan.lender_title_policy_fee) || 0) + (parseFloat(loan.recording_service_fee) || 0) + (parseFloat(loan.settlement_agent_fee) || 0);
    var taxFee = parseFloat(loan.recording_fees) || 0;
    var otherFee = parseFloat(loan.owner_title_policy_fee) || 0;
    var prepaidItemsFee = (parseFloat(loan.prepaid_item_fee) || 0) + (parseFloat(loan.prepaid_homeowners_insurance) || 0);
    var lenderCredits = parseFloat(loan.lender_credits) || 0;
    var lenderUnderwritingFee = parseFloat(loan.lender_underwriting_fee) || 0;
    var totalClosingCost = lenderCredits + lenderUnderwritingFee + canNotShopForFee + shopForFee + taxFee + otherFee + prepaidItemsFee;
    if(this.isPurchaseLoan()){
      var cashToClose = totalClosingCost + (parseFloat(loan.down_payment) || 0);
    }else{
      var cashToClose = totalClosingCost + (parseFloat(loan.cash_out) || 0);
    }
    var updatedRateTime = this.formatTimeCustom(loan.updated_rate_time, 'MMMM Do YYYY, h:mm:ss A');

    return (
      <div className="panel panel-flat terms-view">
        <div>
          <div className="row">
            <h4 className="loan-summary"> Your Loan Summary </h4>
            <p style={{"font-style": "italic", "padding-left": "20px"}}>
              As of {updatedRateTime}
              {
                loan.is_rate_locked == true
                ?
                  null
                :
                  <span className="glyphicon glyphicon-refresh btnUpdateRate" title="Update" style={{"cursor": "pointer", "font-weight": "bold", "color": "#15c0f1", "margin-left":"10px"}} onClick={this.props.updateRate}></span>
              }
            </p>
            <p style={{"color": "red", "padding-left": "20px"}}>
              {this.props.updateRateErrorMessage}
            </p>
          </div>

          <div className="table-responsive term-board">
            <table className="table table-striped term-table">
              <tbody>
                <tr>
                  <td className="loan-field">
                    Property Address
                  </td>
                  <td>
                    {
                      this.props.address
                      ?
                      this.props.address
                      :
                      <span>Unknown Address</span>
                    }
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    Property Value
                  </td>
                  <td>
                    {
                      this.isPurchaseLoan()
                      ?
                      this.getPropertyValue(property.purchase_price, "$")
                      :
                      this.getPropertyValue(property.market_price, "$")
                    }
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    Lender
                  </td>
                  <td>
                    {loan.lender_name}
                  </td>
                </tr>
                <tr>
                  <td>
                    Loan Amount
                  </td>
                  <td>
                    {this.formatCurrency(loan.amount,"$")}
                  </td>
                </tr>
                <tr>
                  <td>
                    Loan Type
                  </td>
                  <td>
                    {loan.amortization_type}
                  </td>
                </tr>
                <tr>
                  <td>
                    Interest Rate
                  </td>
                  <td>
                    {this.commafy(loan.interest_rate*100, 3)}%
                  </td>
                </tr>
                <tr>
                  <td>
                    Rate Lock
                  </td>
                  <td>
                    {
                      loan.is_rate_locked == true
                      ?
                        "Yes"
                      :
                        "No"
                    }
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div className="row">
            <h4>Total Cash to Close</h4>
          </div>
          <div className="table-responsive term-board">
            <table className="table table-striped term-table">
              <tbody>
                {
                  loan.lender_credits < 0.0
                  ?
                    <tr>
                      <td className="loan-field">
                        Lender Credit
                      </td>
                      <td>
                        {this.formatCurrency(lenderCredits, "$")}
                      </td>
                    </tr>
                  :
                    <tr>
                      <td className="loan-field">
                        Discount Points
                      </td>
                      <td>
                        {this.formatCurrency(lenderCredits, "$")}
                      </td>
                    </tr>
                }
                <tr>
                  <td className="loan-field">
                    Lender Underwriting Fee
                  </td>
                  <td>
                    {this.formatCurrency(lenderUnderwritingFee, "$")}
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    <i className="icon-plus" onClick={_.bind(this.showExpend, null, "not-shop-for")}></i>
                    Services You Can Not Shop For
                    <div className="not-shop-for closing-cost-text">
                      <p>Appraisal Fee</p>
                      <p>Tax Certification Fee</p>
                      <p>Flood Certification Fee</p>
                    </div>
                  </td>
                  <td>
                    {this.formatCurrency(canNotShopForFee, "$")}
                    <div className="not-shop-for closing-cost-price">
                      <p>{this.formatCurrency(loan.appraisal_fee, "$")}</p>
                      <p>{this.formatCurrency(loan.tax_certification_fee, "$")}</p>
                      <p>{this.formatCurrency(loan.flood_certification_fee, "$")}</p>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    <i className="icon-plus" onClick={_.bind(this.showExpend, null, "shop-for")}></i>
                    Services You Can Shop For
                    <div className="shop-for closing-cost-text">
                      <p>Outside Signing Service</p>
                      <p>Title - Concurrent Loan Charge</p>
                      <p>Endorsement Charge</p>
                      <p>Title - Lender's Title Policy</p>
                      <p>Title - Recording Service Fee</p>
                      <p>Title - Settlement Agent Fee</p>
                    </div>
                  </td>
                  <td>
                    {this.formatCurrency(shopForFee, "$")}
                    <div className="shop-for closing-cost-price">
                      <p>{this.formatCurrency(loan.outside_signing_service_fee, "$")}</p>
                      <p>{this.formatCurrency(loan.concurrent_loan_charge_fee, "$")}</p>
                      <p>{this.formatCurrency(loan.endorsement_charge_fee, "$")}</p>
                      <p>{this.formatCurrency(loan.lender_title_policy_fee, "$")}</p>
                      <p>{this.formatCurrency(loan.recording_service_fee, "$")}</p>
                      <p>{this.formatCurrency(loan.settlement_agent_fee, "$")}</p>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    <i className="icon-plus" onClick={_.bind(this.showExpend, null, "recording-fee")}></i>
                    Taxes and Other Government Fees
                    <div className="recording-fee closing-cost-text">
                      <p>Recording Fees</p>
                    </div>
                  </td>
                  <td>
                    {this.formatCurrency(taxFee, "$")}
                    <div className="recording-fee closing-cost-price">
                      <p>{this.formatCurrency(loan.recording_fees, "$")}</p>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    <i className="icon-plus" onClick={_.bind(this.showExpend, null, "other-fee")}></i>
                    Other
                    <div className="other-fee closing-cost-text">
                      <p>Title - Owner's Title Policy</p>
                    </div>
                  </td>
                  <td>
                    {this.formatCurrency(otherFee, "$")}
                    <div className="other-fee closing-cost-price">
                      <p>{this.formatCurrency(loan.owner_title_policy_fee, "$")}</p>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    <i className="icon-plus" onClick={_.bind(this.showExpend, null, "prepaid-fee")}></i>
                    Prepaid Items
                    <div className="prepaid-fee closing-cost-text">
                      <p>Prepaid Interest</p>
                      <p>Prepaid Homeowners Insurance for 12 Months</p>
                    </div>
                  </td>
                  <td>
                    {this.formatCurrency(prepaidItemsFee, "$")}
                    <div className="prepaid-fee closing-cost-price">
                      <p>{this.formatCurrency(loan.prepaid_item_fee, "$")}</p>
                      <p>{this.formatCurrency(loan.prepaid_homeowners_insurance, "$")}</p>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td className="loan-field" style={{"font-style": "italic"}}>
                    Total Closing Costs
                  </td>
                  <td>
                    { this.formatCurrency(totalClosingCost, "$") }
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    { this.isPurchaseLoan() ? "Down Payment" : "Cash Out" }
                  </td>
                  <td>
                    { this.formatCurrency(this.isPurchaseLoan() ? loan.down_payment : loan.cash_out, "$") }
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    <i>Total Cash to Close (est.)</i>
                  </td>
                  <td>
                    <i>{this.formatCurrency(cashToClose, "$")}</i>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <div className="row">
            <h4> Housing Expense</h4>
          </div>

          <div className="table-responsive term-board">
            <table className="table table-striped term-table">
              <tbody>
                <tr>
                  <td className="loan-field">
                    Principal and Interest
                  </td>
                  <td>
                    {this.formatCurrency(loan.monthly_payment, "$")}
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    Homeowners Insurance
                  </td>
                  <td>
                    {this.formatCurrency(property.estimated_hazard_insurance / 12, "$")}
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    Property Tax
                  </td>
                  <td>
                    {this.formatCurrency(property.estimated_property_tax / 12, "$")}
                  </td>
                </tr>
                {
                  property.estimated_mortgage_insurance>0.0
                  ?
                  <tr>
                    <td>
                      Mortgage Insurance
                    </td>
                    <td>
                      {this.formatCurrency(property.estimated_mortgage_insurance, "$")}
                    </td>
                  </tr>
                  :
                  null
                }
                {
                  ((property.hoa_due > 0.0) && (property.hoa_due !== 0.0))
                  ?
                  <tr>
                    <td>
                      HOA Due
                    </td>
                    <td>
                      {this.formatCurrency(property.hoa_due,"$")}
                    </td>
                  </tr>
                  :
                  null
                }
                <tr>
                  <td>
                    <i>Total Monthly Housing Expense (est.)</i>
                  </td>
                  <td>
                    <i>{this.formatCurrency(totalCost, "$")}</i>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

        </div>
      </div>
    )
  }
});

module.exports = TermTab;