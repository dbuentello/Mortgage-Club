var _ = require('lodash');
var React = require('react/addons');
var Upload = require('./Upload');

var borrower_fields = {
  first_w2: {label: 'W2 - Most recent tax year', name: 'first_w2', placeholder: 'drap file here or browse', type: 'FirstW2'},
  second_w2: {label: 'W2 - Previous tax year', name: 'second_w2', placeholder: 'drap file here or browse', type: 'SecondW2'},
  first_paystub: {label: "Paystub - Most recent month", name: 'first_paystub', placeholder: 'drap file here or browse', type: 'FirstPaystub'},
  second_paystub: {label: 'Paystub - Previous month', name: 'second_paystub', placeholder: 'drap file here or browse', type: 'SecondPaystub'},
  first_bank_statement: {label: 'Bank statement - Most recent month', name: 'first_bank_statement', placeholder: 'drap file here or browse', type: 'FirstBankStatement'},
  second_bank_statement: {label: 'Bank statement - Previous month', name: 'second_bank_statement', placeholder: 'drap file here or browse', type: 'SecondBankStatement'},
  first_personal_tax_return: {label: 'Personal tax return - Most recent year', name: 'first_personal_tax_return', placeholder: 'drap file here or browse', type: 'FirstPersonalTaxReturn'},
  second_personal_tax_return: {label: 'Personal tax return - Previous year', name: 'second_personal_tax_return', placeholder: 'drap file here or browse', type: 'SecondPersonalTaxReturn'},
  first_business_tax_return: {label: 'Business tax return - Most recent year', name: 'first_business_tax_return', placeholder: 'drap file here or browse', type: 'FirstBusinessTaxReturn'},
  second_business_tax_return: {label: 'Business tax return - Previous year', name: 'second_business_tax_return', placeholder: 'drap file here or browse', type: 'SecondBusinessTaxReturn'},
  first_federal_tax_return: {label: 'Federal tax return - Most recent year', name: 'first_federal_tax_return', placeholder: 'drap file here or browse', type: 'FirstFederalTaxReturn'},
  second_federal_tax_return: {label: 'Federal tax return - Previous year', name: 'second_federal_tax_return', placeholder: 'drap file here or browse', type: 'SecondFederalTaxReturn'},
  other_borrower_report: {label: 'Other', name: 'other_borrower_report', placeholder: 'drap file here or browse', type: 'OtherBorrowerReport', customDescription: true}
};
var loan_fields = {
  hud_estimate: {label: 'Estimated settlement statement', name: 'hud_estimate', placeholder: 'drap file here or browse', type: 'HudEstimate'},
  hud_final: {label: 'Final settlement statement', name: 'hud_final', placeholder: 'drap file here or browse', type: 'HudFinal'},
  loan_estimate: {label: "Loan estimate", name: 'loan_estimate', placeholder: 'drap file here or browse', type: 'LoanEstimate'},
  uniform_residential_lending_application: {label: 'Loan application form', name: 'uniform_residential_lending_application', placeholder: 'drap file here or browse', type: 'UniformResidentialLendingApplication'},
  other_loan_report: {label: 'Other', name: 'other_loan_report', placeholder: 'drap file here or browse', type: 'OtherLoanReport', customDescription: true}
}
var closing_fields = {
  closing_disclosure: {label: 'Closing Disclosure', name: 'closing_disclosure', placeholder: 'drap file here or browse', type: 'ClosingDisclosure'},
  deed_of_trust: {label: 'Deed of Trust', name: 'deed_of_trust', placeholder: 'drap file here or browse', type: 'DeedOfTrust'},
  loan_doc: {label: "Loan Document", name: 'loan_doc', placeholder: 'drap file here or browse', type: 'LoanDoc'},
  other_closing_report: {label: 'Other', name: 'other_closing_report', placeholder: 'drap file here or browse', type: 'OtherClosingReport', customDescription: true}
}
var property_fields = {
  appraisal_report: {label: 'Appraised property value', name: 'appraisal_report', placeholder: 'drap file here or browse', type: 'AppraisalReport'},
  flood_zone_certification: {label: 'Flood zone certification', name: 'flood_zone_certification', placeholder: 'drap file here or browse', type: 'FloodZoneCertification'},
  homeowners_insurance: {label: "Homeowner's insurance", name: 'homeowners_insurance', placeholder: 'drap file here or browse', type: 'HomeownersInsurance'},
  inspection_report: {label: 'Home inspection report', name: 'inspection_report', placeholder: 'drap file here or browse', type: 'InspectionReport'},
  lease_agreement: {label: 'Lease agreement', name: 'lease_agreement', placeholder: 'drap file here or browse', type: 'LeaseAgreement'},
  mortgage_statement: {label: 'Latest mortgage statement of subject property', name: 'mortgage_statement', placeholder: 'drap file here or browse', type: 'MortgageStatement'},
  purchase_agreement: {label: 'Executed purchase agreement', name: 'purchase_agreement', placeholder: 'drap file here or browse', type: 'PurchaseAgreement'},
  risk_report: {label: "Home seller's disclosure report", name: 'risk_report', placeholder: 'drap file here or browse', type: 'RiskReport'},
  termite_report: {label: 'Termite report', name: 'termite_report', placeholder: 'drap file here or browse', type: 'TermiteReport'},
  title_report: {label: 'Preliminary title report', name: 'title_report', placeholder: 'drap file here or browse', type: 'TitleReport'},
  other_property_report: {label: 'Other', name: 'other_property_report', placeholder: 'drap file here or browse', type: 'OtherPropertyReport', customDescription: true}
}

var DocumentTab = React.createClass({
  getInitialState: function() {
    return {
      displayProperty: {display: true},
      displayBorrower: {display: 'none'},
      displayLoan: {display: 'none'},
      displayClosing: {display: 'none'}
    };
  },

  onChange: function(event) {
    var type_of_document = event.target.value;
    switch(type_of_document) {
      case "property":
        this.setState({displayProperty: {display: true}});
        this.setState({displayBorrower: {display: 'none'}});
        this.setState({displayLoan: {display: 'none'}});
        this.setState({displayClosing: {display: 'none'}});
        break;
      case "borrower":
        this.setState({displayBorrower: {display: true}});
        this.setState({displayProperty: {display: 'none'}});
        this.setState({displayLoan: {display: 'none'}});
        this.setState({displayClosing: {display: 'none'}});
        break;
      case "loan":
        this.setState({displayLoan: {display: true}});
        this.setState({displayProperty: {display: 'none'}});
        this.setState({displayBorrower: {display: 'none'}});
        this.setState({displayClosing: {display: 'none'}});
        break;
      case "closing":
        this.setState({displayClosing: {display: true}});
        this.setState({displayLoan: {display: 'none'}});
        this.setState({displayProperty: {display: 'none'}});
        this.setState({displayBorrower: {display: 'none'}});
        break;
    }
  },

  render: function() {
    return (
      <div className='content container backgroundBasic'>
        <div className="row ptl">
          <div className="col-xs-4">
            <select className="form-control" onChange={this.onChange}>
              <option value="property">Property Document</option>
              <option value="borrower">Borrower Document</option>
              <option value="loan">Loan Document</option>
              <option value="closing">Closing Document</option>
            </select>
          </div>
        </div>
        <div id="property_uploader" className="row" style={this.state.displayProperty}>
          <Upload subjectType={"Property"} subject={this.props.property} fields={property_fields}></Upload>
        </div>
        <div id="borrower_document_uploader" className="row" style={this.state.displayBorrower}>
          <Upload subjectType={"Borrower"} subject={this.props.borrower} fields={borrower_fields}></Upload>
        </div>
        <div id="loan_uploader" className="row" style={this.state.displayLoan}>
          <Upload subjectType={"Loan"} subject={this.props.loan} fields={loan_fields}></Upload>
        </div>
        <div id="closing_uploader" className="row" style={this.state.displayClosing}>
          <Upload subjectType={"Closing"} subject={this.props.closing} fields={closing_fields}></Upload>
        </div>
      </div>
    );
  }
});

module.exports = DocumentTab;