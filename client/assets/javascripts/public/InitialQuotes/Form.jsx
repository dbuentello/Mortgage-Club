var React = require("react/addons");
var TextField = require("components/form/NewTextField");
var SelectField = require("components/form/NewSelectField");
var TextFormatMixin = require("mixins/TextFormatMixin");
var ValidationObject = require("mixins/FormValidationMixin");
var Quotes = require("./Quotes")

var fields = {
  zipcode: {label: "ZIP code", name: "zipcode", keyName: "zipcode", error: "zipcodeError"},
  creditScore: {label: "Credit score", name: "credit_score", keyName: "creditScore", error: "creditScoreError"},
  mortgagePurpose: {label: "Mortgage purpose", name: "mortgage_purpose", keyName: "mortgagePurpose", error: "mortgagePurposeError"},
  propertyValue: {label: "Property value", name: "property_value", keyName: "propertyValue", error: "propertyValueError"},
  propertyUsage: {label: "Property will be", name: "property_usage", keyName: "propertyUsage", error: "propertyUsageError"},
  propertyType: {label: "Property type", name: "property_type", keyName: "propertyType", error: "propertyTypeError"},
};

var mortgagePurposeOptions = [
  {name: "Purchase", value: "purchase"},
  {name: "Refinance", value: "refinance"}
];

var propertyUsageOptions = [
  {name: "Primary Residence", value: "primary_residence"},
  {name: "Vacation Home", value: "vacation_home"},
  {name: "Rental Property", value: "rental_property"}
];

var propertyTypeOptions = [
  {name: "Single Family Home", value: "sfh"},
  {name: "Duplex", value: "duplex"},
  {name: "Triplex", value: "triplex"},
  {name: "Fourplex", value: "fourplex"},
  {name: "Condo", value: "condo"}
]

var Form = React.createClass({
  mixins: [TextFormatMixin, ValidationObject],

  getInitialState: function() {
    return {};
  },

  onChange: function(change) {
    this.setState(change);
  },

  onBlur: function(blur) {
    this.setState(blur);
  },

  getLoanAmount: function() {
    return 400000;
    return 0.8 * this.currencyToNumber(this.state[fields.propertyValue.keyName]);
  },

  onSubmit: function(event) {
    event.preventDefault();

    if (this.valid() == false) {
      return false;
    }

    $.ajax({
      url: "/initial_quotes",
      data: {
        zip_code: this.state[fields.zipcode.keyName],
        credit_score: this.state[fields.creditScore.keyName],
        mortgage_purpose: this.state[fields.mortgagePurpose.keyName],
        property_value: this.currencyToNumber(this.state[fields.propertyValue.keyName]),
        property_usage: this.state[fields.propertyUsage.keyName],
        property_type: this.state[fields.propertyType.keyName]
      },
      method: "POST",
      dataType: "json",
      success: function(response) {
        this.setState({
          quotes: response.quotes
        })
      }.bind(this),
      error: function(response){

      }.bind(this)
    });
  },

  valid: function() {
    var isValid = true;
    var requiredFields = {};

    _.each(Object.keys(fields), function(key) {
      requiredFields[fields[key].error] = {value: this.state[fields[key].keyName], validationTypes: ["empty"]};
    }, this);


    if(!_.isEmpty(this.getStateOfInvalidFields(requiredFields))) {
      this.setState(this.getStateOfInvalidFields(requiredFields));
      isValid = false;
    }

    return isValid;
  },

  render: function() {
    return (
      <div className="initial-quotes content">
        {
          this.state.quotes
          ?
            <Quotes quotes = {this.state.quotes}
              zipCode = {this.state[fields.zipcode.keyName]}
              creditScore = {this.state[fields.creditScore.keyName]}
              mortgagePurpose = {this.state[fields.mortgagePurpose.keyName]}
              propertyValue = {this.currencyToNumber(this.state[fields.propertyValue.keyName])}
              propertyUsage = {this.state[fields.propertyUsage.keyName]}
              propertyType = {this.state[fields.propertyType.keyName]}/>
          :
            <div>
              <h1>Initial Quotes</h1>
              <form className="form-horizontal col-md-offset-4" id="form-quotes">
                <div className="form-group">
                  <div className="col-md-6">
                    <TextField
                      activateRequiredField={this.state[fields.zipcode.error]}
                      label={fields.zipcode.label}
                      keyName={fields.zipcode.keyName}
                      editable={true}
                      onChange={this.onChange}
                      maxLength={6}
                      value={this.state[fields.zipcode.keyName]}/>
                  </div>
                </div>
                <div className="form-group">
                  <div className="col-md-6">
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
                </div>
                <div className="form-group">
                  <div className="col-md-6">
                    <TextField
                      activateRequiredField={this.state[fields.creditScore.error]}
                      label={fields.creditScore.label}
                      keyName={fields.creditScore.keyName}
                      editable={true}
                      onChange={this.onChange}
                      maxLength={6}
                      value={this.state[fields.creditScore.keyName]}/>
                  </div>
                </div>
                <div className="form-group">
                  <div className="col-md-6">
                    <SelectField
                      activateRequiredField={this.state[fields.mortgagePurpose.error]}
                      label={fields.mortgagePurpose.label}
                      keyName={fields.mortgagePurpose.keyName}
                      options={mortgagePurposeOptions}
                      editable={true}
                      onChange={this.onChange}
                      allowBlank={true}
                      value={this.state[fields.mortgagePurpose.keyName]}/>
                  </div>
                </div>
                <div className="form-group">
                  <div className="col-md-6">
                    <SelectField
                      activateRequiredField={this.state[fields.propertyUsage.error]}
                      label={fields.propertyUsage.label}
                      keyName={fields.propertyUsage.keyName}
                      options={propertyUsageOptions}
                      editable={true}
                      onChange={this.onChange}
                      allowBlank={true}
                      value={this.state[fields.propertyUsage.keyName]}/>
                  </div>
                </div>
                <div className="form-group">
                  <div className="col-md-6">
                    <SelectField
                      activateRequiredField={this.state[fields.propertyType.error]}
                      label={fields.propertyType.label}
                      keyName={fields.propertyType.keyName}
                      options={propertyTypeOptions}
                      editable={true}
                      onChange={this.onChange}
                      allowBlank={true}
                      value={this.state[fields.propertyType.keyName]}/>
                  </div>
                </div>
                <div className="form-group">
                  <div className="col-md-12">
                    <button className="btn theBtn text-uppercase" id="continueBtn" onClick={this.onSubmit}>Get rates</button>
                  </div>
                </div>
              </form>
            </div>
        }
      </div>
    );
  }
});

module.exports = Form;