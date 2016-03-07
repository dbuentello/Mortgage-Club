var React = require("react/addons");

var Dropzone = require("components/form/NewDropzone");
var TextField = require("components/form/NewTextField");
var SelectField = require("components/form/NewSelectField");

var TextFormatMixin = require("mixins/TextFormatMixin");
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');

var BankPart = require("public/homepage/BankPart");
var HomePart = require("public/homepage/HomePart");

var fields = {
  refinancePurpose: {label: "Refinance Purpose", name: "potential_rate_drop_user[refinance_purpose]", error: "purposeError", validationTypes: ["empty"]},
  creditScore: {label: "Estimated credit score", name: "potential_rate_drop_user[credit_score]", error: "creditScoreError", validationTypes: ["empty"]}
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
  mixins: [TextFormatMixin],

  getInitialState: function() {
    return {
      phoneNumber: null,
      current_mortgage_balance: null,
      estimated_home_value: null,
      zip: null
    }
  },


  handleSubmit: function(event){
    $("[data-toggle='tooltip']").tooltip("destroy");
    event.preventDefault();

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
          emailError: response.responseJSON.email,
          phoneNumberError: response.responseJSON.phone_number,

          alertMethodError: response.responseJSON.alert_method,
        })
      }.bind(this)
    });
  },
  onChange: function (change) {
    console.dir(change);
    this.setState(change);

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
                              <div className="col-sm-12 email-address">
                                <h6 className="text-left">Email Address</h6>
                                <input type="email" className="form-control" name="potential_rate_drop_user[email]"
                                  id="email" data-toggle="tooltip" data-original-title={this.state.emailError}/>
                                <img src="/icons/mail.png" alt="title"/>
                              </div>
                            </div>
                            <div className="form-group">
                              <div className="col-sm-12 phone-number">
                                <h6 className="text-left">Phone Number (optional)</h6>
                                <input type="text" className="form-control" name="potential_rate_drop_user[phone_number]" id="phone_number" value={this.state.phoneNumber} onChange={this.changePhoneNumber}
                                  data-toggle="tooltip" data-original-title={this.state.phoneNumberError}/>
                                <img src="/icons/phone.png" alt="title"/>
                              </div>
                            </div>
                            <div className="form-group">
                              <div className="col-sm-12 text-left">
                                <SelectField
                                  requiredMessage="This field is required"
                                  value={this.state[fields.refinancePurpose.name]}
                                  label={fields.refinancePurpose.label}
                                  keyName={fields.refinancePurpose.name}

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

                                  label='Current Mortgage Balance'
                                  keyName={'current_mortgage_balance'}
                                  format={this.formatCurrency}
                                  editable={true}
                                  validationTypes={["currency"]}
                                  maxLength={15}
                                  onChange={this.onChange}
                                  value={this.state.current_mortgage_balance}
                                  onBlur={this.onBlur}
                                  editMode={true}/>
                              </div>

                            </div>
                            <div className="form-group">
                              <div className="col-sm-12 text-left">
                                <TextField

                                  label='Current Mortgage Rate'
                                  keyName={'current_mortgage_rate'}
                                  format={this.formatPercent}
                                  editable={true}
                                  validationTypes={["percent"]}
                                  maxLength={10}
                                  onChange={this.onChange}
                                  value={this.state.current_mortgage_rate}
                                  onBlur={this.onBlur}
                                  editMode={true}/>
                              </div>

                            </div>
                            <div className="form-group">
                              <div className="col-sm-12 text-left">
                                <TextField
                                  label='Estimated Home Value'
                                  keyName={'estimated_home_value'}
                                  format={this.formatCurrency}
                                  editable={true}
                                  validationTypes={["currency"]}
                                  maxLength={15}
                                  onChange={this.onChange}
                                  value={this.state.estimated_home_value}
                                  onBlur={this.onBlur}
                                  editMode={true}/>
                              </div>

                            </div>
                            <div className="form-group">
                              <div className="col-sm-12 text-left">
                                <TextField
                                  label='Zip code'
                                  keyName={'zip'}
                                  format={this.formatInteger}
                                  editable={true}
                                  validationTypes={["number"]}
                                  maxLength={6}
                                  onChange={this.onChange}
                                  value={this.state.zip}
                                  onBlur={this.onBlur}
                                  liveFormat={true}
                                  editMode={true}/>
                              </div>

                            </div>
                            <div className="form-group">
                              <div className="col-sm-12 text-left">
                                <SelectField
                                  requiredMessage="This field is required"
                                  value={this.state[fields.creditScore.name]}
                                  label={fields.creditScore.label}
                                  keyName={fields.creditScore.name}

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
