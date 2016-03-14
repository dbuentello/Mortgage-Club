var React = require("react/addons");
var Dropzone = require("components/form/NewDropzone");
var TextField = require("components/form/NewTextField");
var SelectField = require("components/form/NewSelectField");

var TextFormatMixin = require("mixins/TextFormatMixin");
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var ValidationObject = require("mixins/FormValidationMixin");

var BankPart = require("public/homepage/BankPart");
var HomePart = require("public/homepage/HomePart");

var fields = {
  refinancePurpose: {label: "Refinance Purpose", name: "refinance_purpose",keyName: "refinancePurpose", error: "purposeError",validationTypes: "empty"},
  creditScore: {label: "Estimated Credit Score", name: "credit_score",keyName: "creditScore", error: "creditScoreError",validationTypes: "empty"},
  zip: {label: "ZIP Code", name: "zip", keyName: "zip",error: "zipError", validationTypes: "empty"},
  currentMortgageRate: {label: "Current Mortgage Rate", name: "current_mortgage_rate",keyName: "currentMortgageRate", error: "currentMortgageRateError",validationTypes: "empty"},
  estimatedHomeValue: {label: "Estimated home value", name: "estimated_home_value",keyName: "estimatedHomeValue", error: "estimatedHomeValueError",validationTypes: "empty"},
  currentMortgageBalance: {label: "Current Mortgage Balance", name: "current_mortgage_balance",keyName: "currentMortgageBalance", error: "currentMortgageBalanceError",validationTypes: "empty"},
  email: {label: "Email", name: "email",keyName: "email", error: "emailError",validationTypes: "email"}

};
var refinancePurposes = [
  {value: "lower_rate", name: "Lower rate"},
  {value: "cash_out", name: "Cash out"}
];
var creditScores = [
  {value: "740", name: "740+"},
  {value: "720_739", name: "720 - 739"},
  {value: "700_719", name: "700 - 719"},
  {value: "680_699", name: "680 - 699"},
  {value: "660_679", name: "660 - 679"},
  {value: "640_659", name: "640 - 659"},
  {value: "620_629", name: "620 - 629"}

];

var RateDropAlert = React.createClass({
  mixins: [TextFormatMixin,ValidationObject],

  getInitialState: function() {
    var state = {};

    state[fields.email.keyName] = null;

    state[fields.refinancePurpose.keyName] = "lower_rate";
    state[fields.creditScore.keyName] = "740";
    state[fields.zip.keyName] = null;
    state[fields.currentMortgageRate.keyName] = null;
    state[fields.estimatedHomeValue.keyName] = this.formatCurrency("500000");
    state[fields.currentMortgageBalance.keyName] = this.formatCurrency("400000");

    return state;
  },
  valid: function() {
    var isValid = true;
    var requiredFields = {};

    _.each(Object.keys(fields), function(key) {
      requiredFields[fields[key].error] = {value: this.state[fields[key].keyName], validationTypes: [fields[key].validationTypes]};
    }, this);
    if(!_.isEmpty(this.getStateOfInvalidFields(requiredFields))) {
      this.setState(this.getStateOfInvalidFields(requiredFields));
      isValid = false;
    }
    return isValid;
  },

  handleSubmit: function(event){
    $("[data-toggle='tooltip']").tooltip("destroy");
    event.preventDefault();

    if (this.valid() == false) {
      return false;
    }

    $.ajax({
      url: "/refinance_alert",
      data: {
        current_mortgage_balance: this.currencyToNumber(this.state[fields.currentMortgageBalance.keyName]),
        credit_score: this.state[fields.creditScore.keyName],
        current_mortgage_rate: this.percentToNumber(this.state[fields.currentMortgageRate.keyName]),
        estimated_home_value: this.currencyToNumber(this.state[fields.estimatedHomeValue.keyName]),
        refinance_purpose: this.state[fields.refinancePurpose.keyName],
        zip: this.state[fields.zip.keyName],
        email: this.state[fields.email.keyName]

      },
      method: "POST",
      dataType: "json",
      success: function(response) {
        this.setState({isSuccess:true});
        setInterval(function() {
          location.href = "/";
        }, 500000);
      }.bind(this),
      error: function(response){

      }.bind(this)
    });
  },
  onChange: function (change) {
    this.setState(change);
  },
  onBlur: function(blur) {
    this.setState(blur);
  },

  componentDidUpdate: function() {

      this.renderTooltip();

  },

  componentDidMount: function(event) {

    this.renderTooltip();
  },

  renderTooltip: function() {
    $("[data-toggle='tooltip']").tooltip({
      placement: "left",
      trigger: "manual"
    }).tooltip("show");
  },

  render: function() {
      return (
        <div className="homepage">
          <HomePart data={this.props.bootstrapData} ></HomePart>
          <BankPart></BankPart>
            <div className="rate-drop-alert">
                <section id="rate_alert">
              <div className="rate-alert-form">
                <div className="container">
                  {
                    this.state.isSuccess
                    ?
                      <div className="col-md-12 text-center">
                        <div className="thank-you">
                          <h1>Thank you for setting rate alert!</h1>
                          <p>Keep an eye out for our email and/or text message soon.</p>
                          <img src="/rate_alert.png"/>
                          <br />
                          <br />
                          <br />
                        </div>
                      </div>
                    :
                      <div className="mtl">
                        <div className="col-md-8 col-md-offset-2">
                          <form className="form-horizontal text-center" action="/refinance_alert" type="json" enctype="multipart/form-data" method="post" name="fileinfo">
                            <div className="form-group">
                              <div className="col-sm-12 email-address text-left">
                                <TextField
                                  activateRequiredField={this.state[fields.email.error]}
                                  label={fields.email.label}
                                  keyName={fields.email.keyName}
                                  value={this.state[fields.email.keyName]}
                                  editable={true}
                                  validationTypes={["email"]}
                                  onChange={this.onChange}
                                  onBlur={this.onBlur}
                                  editMode={true}/>
                              </div>


                            </div>
                            <div className="form-group">
                              <div className="col-sm-6 text-left">
                                <TextField
                                  activateRequiredField={this.state[fields.currentMortgageRate.error]}
                                  label={fields.currentMortgageRate.label}
                                  keyName={fields.currentMortgageRate.keyName}
                                  value={this.state[fields.currentMortgageRate.keyName]}
                                  format={this.formatPercent}
                                  editable={true}
                                  validationTypes={["percent"]}
                                  maxLength={6}
                                  onChange={this.onChange}
                                  onBlur={this.onBlur}
                                  editMode={true}/>
                              </div>
                              <div className="col-sm-6 text-left">
                                <TextField
                                  activateRequiredField={this.state[fields.zip.error]}
                                  label={fields.zip.label}
                                  keyName={fields.zip.keyName}
                                  value={this.state[fields.zip.keyName]}
                                  format={this.formatInteger}
                                  editable={true}
                                  validationTypes={["number"]}
                                  maxLength={6}
                                  onChange={this.onChange}
                                  onBlur={this.onBlur}
                                  liveFormat={true}
                                  editMode={true}/>
                              </div>
                            </div>
                            <div className="form-group">
                              <div className="col-sm-6 text-left text-capitalize">
                                <TextField
                                  activateRequiredField={this.state[fields.estimatedHomeValue.error]}
                                  label={fields.estimatedHomeValue.label}
                                  keyName={fields.estimatedHomeValue.keyName}
                                  value={this.state[fields.estimatedHomeValue.keyName]}
                                  format={this.formatCurrency}
                                  editable={true}
                                  validationTypes={["currency"]}
                                  maxLength={15}
                                  onChange={this.onChange}
                                  onBlur={this.onBlur}
                                  editMode={true}/>
                              </div>
                              <div className="col-sm-6 text-left">
                                <TextField
                                  activateRequiredField={this.state[fields.currentMortgageBalance.error]}
                                  label={fields.currentMortgageBalance.label}
                                  keyName={fields.currentMortgageBalance.keyName}
                                  value={this.state[fields.currentMortgageBalance.keyName]}
                                  format={this.formatCurrency}
                                  editable={true}
                                  validationTypes={["currency"]}
                                  maxLength={15}
                                  onChange={this.onChange}
                                  onBlur={this.onBlur}
                                  editMode={true}/>
                              </div>
                            </div>
                            <div className="form-group">
                              <div className="col-sm-6 text-left">
                                <SelectField
                                  activateRequiredField={this.state[fields.refinancePurpose.error]}
                                  value={this.state[fields.refinancePurpose.keyName]}
                                  label={fields.refinancePurpose.label}
                                  keyName={fields.refinancePurpose.keyName}
                                  options={refinancePurposes}
                                  editable={true}
                                  onChange={this.onChange}
                                  editMode={true}
                                  allowBlank={true}
                                  />
                              </div>
                              <div className="col-sm-6 text-left">
                                <SelectField
                                  activateRequiredField={this.state[fields.creditScore.error]}
                                  label={fields.creditScore.label}
                                  keyName={fields.creditScore.keyName}
                                  value={this.state[fields.creditScore.keyName]}
                                  options={creditScores}
                                  editable={true}
                                  onChange={this.onChange}
                                  editMode={true}
                                  allowBlank={true}/>
                              </div>
                            </div>
                            <div className="form-group">
                              <div className="col-xs-12">
                                <button className="btn theBtn submit-btn text-uppercase" onClick={this.handleSubmit}>{this.props.bootstrapData.homepage.btn_alert}</button>
                              </div>
                            </div>
                            <div className="form-group">
                              <div className="col-sm-10 col-sm-offset-1 m-margin-bottom">
                                <p><b>Please note:</b> The use of information collected shall be limited to the purpose of monitoring your mortgage rates. We do not sell or share your information with anyone else.</p>
                              </div>
                            </div>
                          </form>
                        </div>
                      </div>
                  }
                </div>
              </div>
              </section>
            </div>
        </div>
    );
  }
});

module.exports = RateDropAlert;
