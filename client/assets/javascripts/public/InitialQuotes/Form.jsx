/**
 * UI for user input info before finding rate
 */
var React = require("react/addons");
var TextField = require("components/form/NewTextField");
var SelectField = require("components/form/NewSelectField");
var TextFormatMixin = require("mixins/TextFormatMixin");
var ValidationObject = require("mixins/FormValidationMixin");
var Quotes = require("./Quotes")
var changedPropertyValue = false;

var fields = {
  mortgagePurpose: {label: "Mortgage Purpose", name: "mortgage_purpose", keyName: "mortgagePurpose", error: "mortgagePurposeError"},
  zipcode: {label: "ZIP Code", name: "zipcode", keyName: "zipcode", error: "zipcodeError"},
  propertyValue: {label: "Property Value", name: "property_value", keyName: "propertyValue", error: "propertyValueError"},
  downPayment: {label: "Down Payment", name: "down_payment", keyName: "downPayment", error: "downPaymentError"},
  mortgageBalance: {label: "Current Mortgage Balance", name: "mortgage_balance", keyName: "mortgageBalance", error: "mortgageBalanceError"},
  propertyUsage: {label: "Property Will Be", name: "property_usage", keyName: "propertyUsage", error: "propertyUsageError"},
  propertyType: {label: "Property Type", name: "property_type", keyName: "propertyType", error: "propertyTypeError"},
  creditScore: {label: "Credit Score", name: "credit_score", keyName: "creditScore", error: "creditScoreError"},
};

var mortgagePurposeOptions = [
  {name: "Purchase", value: "purchase"},
  {name: "Refinance", value: "refinance"}
];

var propertyUsageOptions = [
  {name: "Primary Residence", value: "primary_residence"},
  {name: "Vacation Home", value: "vacation_home"},
  {name: "Investment Property", value: "rental_property"}
];

var propertyTypeOptions = [
  {name: "Single Family Home", value: "sfh"},
  {name: "Duplex", value: "duplex"},
  {name: "Triplex", value: "triplex"},
  {name: "Fourplex", value: "fourplex"},
  {name: "Condo", value: "condo"}
];

var creditScoreOptions = [
  {name: "740+", value: "740"},
  {name: "720-739", value: 720},
  {name: "700-719", value: 700},
  {name: "680-699", value: 680},
  {name: "660-679", value: 660},
  {name: "640-659", value: 640},
  {name: "620-629", value: 620}
];

var Form = React.createClass({
  mixins: [TextFormatMixin, ValidationObject],

  getInitialState: function() {
    var state = {};
    state[fields.mortgagePurpose.keyName] = this.props.bootstrapData[fields.mortgagePurpose.name];
    state[fields.zipcode.keyName] = this.props.bootstrapData[fields.zipcode.name];
    state[fields.propertyValue.keyName] = this.formatCurrency(this.props.bootstrapData[fields.propertyValue.name], "$");
    state[fields.downPayment.keyName] = this.formatCurrency(this.props.bootstrapData[fields.downPayment.name]);
    state[fields.mortgageBalance.keyName] = this.formatCurrency(this.props.bootstrapData[fields.mortgageBalance.name]);
    state[fields.propertyUsage.keyName] = this.props.bootstrapData[fields.propertyUsage.name];
    state[fields.propertyType.keyName] = this.props.bootstrapData[fields.propertyType.name];
    state[fields.creditScore.keyName] = this.props.bootstrapData[fields.creditScore.name];
    return state;
  },

  onChange: function(change) {
    var key = _.keys(change)[0];
    if(key == fields.propertyValue.keyName) {
      changedPropertyValue = true;
    }

    this.setState(change);
  },

  onBlur: function(blur) {
    var key = _.keys(blur)[0];

    if(key == fields.propertyValue.keyName && changedPropertyValue == true) {
      var state = {};
      var value = this.currencyToNumber(_.values(blur)[0]) * 0.2;
      state[fields.downPayment.keyName] = this.formatCurrency(value);
      this.setState(state);
      changedPropertyValue = false;
    }
    this.setState(blur);
  },

  getLoanAmount: function() {
    return 0.8 * this.currencyToNumber(this.state[fields.propertyValue.keyName]);
  },

  onSubmit: function(event) {
    event.preventDefault();

    if (this.valid() == false) {
      return false;
    }

    mixpanel.track("Quotes-FindMyRatesForm");
    $("html").addClass("loading");

    var downPayment = null;
    var mortgageBalance = null;

    if(this.isPurchaseLoan()) {
      downPayment = this.currencyToNumber(this.state[fields.downPayment.keyName]);
    }

    if(this.isRefinanceLoan()) {
      mortgageBalance = this.currencyToNumber(this.state[fields.mortgageBalance.keyName]);
    }

    $.ajax({
      url: "/quotes",
      data: {
        mortgage_purpose: this.state[fields.mortgagePurpose.keyName],
        zip_code: this.state[fields.zipcode.keyName],
        property_value: this.currencyToNumber(this.state[fields.propertyValue.keyName]),
        down_payment: downPayment,
        mortgage_balance: mortgageBalance,
        property_usage: this.state[fields.propertyUsage.keyName],
        property_type: this.state[fields.propertyType.keyName],
        credit_score: this.state[fields.creditScore.keyName]
      },
      method: "POST",
      dataType: "json",
      success: function(response) {
        location.href = "/quotes/" + response.code_id;
      }.bind(this),
      error: function(response){

      }.bind(this)
    });
  },

  valid: function() {
    var isValid = true;
    var requiredFields = {};

    _.each(Object.keys(fields), function(key) {
      // with purchase loan, we don't validate mortgage balance
      if(this.isPurchaseLoan() && key != fields.mortgageBalance.keyName) {
        requiredFields[fields[key].error] = {value: this.state[fields[key].keyName], validationTypes: ["empty"]};
      }
      // with refinance loan, we don't validate down payment
      if(this.isRefinanceLoan() && key != fields.downPayment.keyName) {
        requiredFields[fields[key].error] = {value: this.state[fields[key].keyName], validationTypes: ["empty"]};
      }
    }, this);

    if(!_.isEmpty(this.getStateOfInvalidFields(requiredFields))) {
      this.setState(this.getStateOfInvalidFields(requiredFields));
      isValid = false;
    }

    return isValid;
  },

  isPurchaseLoan: function() {
    return this.state[fields.mortgagePurpose.keyName] == "purchase";
  },

  isRefinanceLoan: function() {
    return this.state[fields.mortgagePurpose.keyName] == "refinance";
  },

  render: function() {
    return (
      <div className="initial-quotes content container">
        <div className="quotes-form">
          <p>Answer a few questions and get a customized rate quote in 10 seconds.</p>
          <p className="explanation">{"We've pre-filled some questions with common answers."}</p>
          <form className="form-horizontal col-xs-12 col-md-8 col-md-offset-2 col-sm-8 col-sm-offset-2" id="form-quotes">
            <div className="form-group">
              <div className="col-md-6 col-sm-6">
                <SelectField
                  activateRequiredField={this.state[fields.mortgagePurpose.error]}
                  label={fields.mortgagePurpose.label}
                  keyName={fields.mortgagePurpose.keyName}
                  options={mortgagePurposeOptions}
                  editable={true}
                  onChange={this.onChange}
                  value={this.state[fields.mortgagePurpose.keyName]}/>
              </div>
              <div className="col-md-6 col-sm-6">
                <TextField
                  activateRequiredField={this.state[fields.zipcode.error]}
                  label={fields.zipcode.label}
                  keyName={fields.zipcode.keyName}
                  editable={true}
                  onChange={this.onChange}
                  maxLength={6}
                  format={this.formatInteger}
                  liveFormat={true}
                  value={this.state[fields.zipcode.keyName]}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-md-6 col-sm-6">
                <TextField
                  activateRequiredField={this.state[fields.propertyValue.error]}
                  label={fields.propertyValue.label}
                  keyName={fields.propertyValue.keyName}
                  editable={true}
                  maxLength={11}
                  format={this.formatCurrency}
                  value={this.state[fields.propertyValue.keyName]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}/>
              </div>
              {
                this.isPurchaseLoan()
                ?
                  <div className="col-md-6 col-sm-6">
                    <TextField
                      activateRequiredField={this.state[fields.downPayment.error]}
                      label={fields.downPayment.label}
                      keyName={fields.downPayment.keyName}
                      editable={true}
                      maxLength={11}
                      format={this.formatCurrency}
                      value={this.state[fields.downPayment.keyName]}
                      onChange={this.onChange}
                      onBlur={this.onBlur}/>
                  </div>
                :
                  <div className="col-md-6 col-sm-6">
                    <TextField
                      activateRequiredField={this.state[fields.mortgageBalance.error]}
                      label={fields.mortgageBalance.label}
                      keyName={fields.mortgageBalance.keyName}
                      editable={true}
                      maxLength={11}
                      format={this.formatCurrency}
                      value={this.state[fields.mortgageBalance.keyName]}
                      onChange={this.onChange}
                      onBlur={this.onBlur}/>
                  </div>
              }
            </div>
            <div className="form-group">
              <div className="col-md-6 col-sm-6">
                <SelectField
                  activateRequiredField={this.state[fields.propertyUsage.error]}
                  label={fields.propertyUsage.label}
                  keyName={fields.propertyUsage.keyName}
                  options={propertyUsageOptions}
                  editable={true}
                  onChange={this.onChange}
                  value={this.state[fields.propertyUsage.keyName]}/>
              </div>
              <div className="col-md-6 col-sm-6">
                <SelectField
                  activateRequiredField={this.state[fields.propertyType.error]}
                  label={fields.propertyType.label}
                  keyName={fields.propertyType.keyName}
                  options={propertyTypeOptions}
                  editable={true}
                  onChange={this.onChange}
                  value={this.state[fields.propertyType.keyName]}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-md-6">
                <SelectField
                    activateRequiredField={this.state[fields.creditScore.error]}
                    label={fields.creditScore.label}
                    keyName={fields.creditScore.keyName}
                    options={creditScoreOptions}
                    editable={true}
                    onChange={this.onChange}
                    value={this.state[fields.creditScore.keyName]}/>
              </div>
            </div>
            <div className="form-group text-center btnSubmit">
              <button className="btn btn-mc text-uppercase" id="find-my-rates-form" onClick={this.onSubmit}>find my rates</button>
            </div>
          </form>
        </div>

      </div>
    );
  }
});

module.exports = Form;
