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
  refinancePurpose: {label: "Refinance Purpose", name: "refinance_purpose",keyName: "refinancePurpose", error: "purposeError"},
  creditScore: {label: "Estimated credit score", name: "credit_score",keyName: "creditScore", error: "creditScoreError"},
  zip: {label: "Zip code", name: "zip", keyName: "zip",error: "zipError"},
  currentMortgageRate: {label: "Current Mortgage rate", name: "current_mortgage_rate",keyName: "currentMortgageRate", error: "currentMortgageRateError"},
  estimatedHomeValue: {label: "Estimated home value", name: "estimated_home_value",keyName: "estimatedHomeValue", error: "estimatedHomeValueError"},
  currentMortgageBalance: {label: "Current Mortgage Balance", name: "current_mortgage_balance",keyName: "currentMortgageBalance", error: "currentMortgageBalanceError"},
  email: {label: "Email", name: "email",keyName: "email", error: "emailError"},
  phoneNumber: {label: "Phone Number (optional)", name: "phone_number",keyName: "phoneNumber", error: "phoneNumberError"}

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
    state[fields.phoneNumber.keyName] = null;
    state[fields.refinancePurpose.keyName] = null;
    state[fields.creditScore.keyName] = null;
    state[fields.zip.keyName] = null;
    state[fields.currentMortgageRate.keyName] = null;
    state[fields.estimatedHomeValue.keyName] = null;
    state[fields.currentMortgageBalance.keyName] = null;

    return state;
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

  handleSubmit: function(event){
    $("[data-toggle='tooltip']").tooltip("destroy");
    event.preventDefault();

    if (this.valid() == false) {
      return false;
    }
    var form = document.forms.namedItem("fileinfo");
    var formData = new FormData(form);
  //  console.log(formData);
    formData.append("potential_rate_drop_user[current_mortgage_balance]",this.state.current_mortgage_balance);
    formData.append("potential_rate_drop_user[current_mortgage_rate]",this.state.current_mortgage_rate);
    formData.append("potential_rate_drop_user[estimated_home_value]",this.state.estimated_home_value);
    formData.append("potential_rate_drop_user[refinance_purpose]",this.state[fields.refinancePurpose.name]);
    formData.append("potential_rate_drop_user[credit_score]",this.state[fields.creditScore.name]);
    formData.append("potential_rate_drop_user[zip]",this.state.zip);

    $.ajax({
      url: "/rate_drop_alert",
      data: formData,
      method: "POST",
      dataType: "json",
      success: function(response) {
        this.setState({isSuccess:true});
        setInterval(function() {
          location.href = "/";
        }, 5000);
      }.bind(this),
      cache: false,
      contentType: false,
      processData: false,
      async: true,
      error: function(response){
        console.dir(response.responseJSON)
        this.setState({
          alertMethodError: response.responseJSON.alert_method
        })
      }.bind(this)
    });
  },
  onChange: function (change) {
    console.dir(change);
    console.log("before change "+this.state[fields.refinancePurpose.keyName]);
    this.setState(change);
    console.log("after change "+this.state[fields.refinancePurpose.keyName]);


  },
  onBlur: function(blur) {
    this.setState(blur);
  },
  changePhoneNumber: function(event) {
    var phoneNumber = this.formatPhoneNumber(event.target.value);
    this.setState({phoneNumber: phoneNumber});
  },

  componentDidUpdate: function() {
    if(event.target.id != "phone_number") {
      this.renderTooltip();
    }
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

                        <div className="col-md-4 col-md-offset-4">
                          <form className="form-horizontal text-center" action="/rate_drop_alert" type="json" enctype="multipart/form-data" method="post" name="fileinfo">
                            <div className="form-group">
                              <div className="col-sm-12 email-address text-left">
                                <TextField
                                  activateRequiredField={this.state[fields.email.error]}
                                  label={fields.email.label}
                                  keyName={fields.email.keyName}
                                  value={this.state[fields.email.keyName]}
                                  editable={true}

                                  onChange={this.onChange}
                                  onBlur={this.onBlur}
                                  editMode={true}
                                  />
                                <img src="/icons/mail.png" alt="title"/>
                              </div>
                            </div>
                            <div className="form-group">
                              <div className="col-sm-12 phone-number text-left">
                                <TextField
                                  activateRequiredField={this.state[fields.phoneNumber.error]}
                                  label={fields.phoneNumber.label}
                                  keyName={fields.phoneNumber.keyName}
                                  value={this.state[fields.phoneNumber.keyName]}
                                  liveFormat={true}
                                  format={this.formatPhoneNumber}
                                  editable={true}

                                  maxLength={15}
                                  onChange={this.onChange}
                                  onBlur={this.onBlur}
                                  editMode={true}

                                  />


                                <img src="/icons/phone.png" alt="title"/>
                              </div>
                            </div>
                            <div className="form-group">
                              <div className="col-sm-12 text-left">
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

                            </div>

                            <div className="form-group">
                              <div className="col-sm-12 text-left">
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
                              <div className="col-sm-12 text-left">
                                <TextField
                                  activateRequiredField={this.state[fields.currentMortgageRate.error]}
                                  label={fields.currentMortgageRate.label}
                                  keyName={fields.currentMortgageRate.keyName}
                                  value={this.state[fields.currentMortgageRate.keyName]}

                                  format={this.formatPercent}
                                  editable={true}
                                  validationTypes={["percent"]}
                                  maxLength={10}
                                  onChange={this.onChange}
                                  onBlur={this.onBlur}
                                  editMode={true}/>
                              </div>

                            </div>
                            <div className="form-group">
                              <div className="col-sm-12 text-left">
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

                            </div>
                            <div className="form-group">
                              <div className="col-sm-12 text-left">
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
                              <div className="col-sm-12 text-left">
                                <SelectField
                                  activateRequiredField={this.state[fields.creditScore.error]}
                                  label={fields.creditScore.label}
                                  keyName={fields.creditScore.keyName}
                                  value={this.state[fields.creditScore.keyName]}

                                  options={creditScores}
                                  editable={true}
                                  onChange={this.onChange}
                                  editMode={true}
                                  allowBlank={true}
                                  />
                              </div>

                            </div>
                            <div className="form-group send-as">
                              <div className="col-sm-12">
                                <h6 className="text-left" data-toggle="tooltip" data-original-title={this.state.alertMethodError}>Send As</h6>
                                  <div className="col-md-4 text-left">
                                    <input type="checkbox" name="potential_rate_drop_user[send_as_email]" id="sendAsEmail"/>
                                    <label className="customCheckbox blueCheckBox2" htmlFor="sendAsEmail">Email</label>
                                  </div>
                                  <div className="col-md-5 col-md-offset-1 text-left">
                                    <input type="checkbox" name="potential_rate_drop_user[send_as_text_message]" id="sendAsText"/>
                                    <label className="customCheckbox blueCheckBox2" htmlFor="sendAsText">Text message</label>
                                  </div>
                              </div>
                            </div>
                            <div className="row">
                              <div className="col-xs-12">
                                <button className="btn theBtn submit-btn text-uppercase" onClick={this.handleSubmit}>{this.props.bootstrapData.homepage.btn_alert}</button>
                              </div>
                            </div>
                          </form>
                        </div>
                        <div className="col-md-7 col-md-offset-3 mbl">
                          <p><b>Please note:</b> The use of information collected shall be limited to the purpose of monitoring your mortgage rates. We do not sell or share your information with anyone else.</p>
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
