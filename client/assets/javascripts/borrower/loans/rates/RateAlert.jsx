var _ = require('lodash');
var React = require('react/addons');
var TextField = require("components/form/NewTextField");

var LoanProgramFilterMixin = require('mixins/LoanProgramFilterMixin');
var ValidationObject = require("mixins/FormValidationMixin");

var fields = {
  firstName: {label: "First name", name: "first_name", keyName: "first_name", error: "firstNameError",validationTypes: "empty"},
  lastName: {label: "Last name", name: "last_name", keyName: "last_name", error: "lastNameError",validationTypes: "empty"},
  email: {label: "Email", name: "email", keyName: "email", error: "emailError", validationTypes: "email"}
};

var Filter = React.createClass({
  mixins: [LoanProgramFilterMixin, ValidationObject],
  getInitialState: function() {
    var state = {};
    state.rate_alert_inform = "";
    _.each(fields, function (field) {
      state[field.name] = null;
    });

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
  submitRateAlert: function(){
    if (this.valid() == false) {
      return false;
    }
    if(this.valid()){
       this.setState({isValid: true});
       $.ajax({
         url: "/quotes/set_rate_alert",
         method: "POST",
         dataType: "json",
         context: this,
         data: {
           email: this.state.email,
           code_id: this.props.code_id,
           first_name: this.state.first_name,
           last_name: this.state.last_name
         },
         success: function(response) {
           this.setState({saving: true});
          //  var html_str = $($.parseHTML());
           this.setState({rate_alert_inform: "You're all set. Keep an eye out for rate alert emails from <a href='mailto:hello@mortgageclub.co?Subject=Hello' target='_top'>hello@mortgageclub.co</a> :)" });
           $("#email_alert" + this.props.index).modal('hide');
           $("#email_inform" + this.props.index).modal('show');

         },error: function(res){
           this.setState({rate_alert_inform: "You cant create a rate alert right now. Please try again."})
           $("#email_alert" + this.props.index).modal('hide');
           $("#email_inform" + this.props.index).modal('show');
         }
       });
     }
  },
  onChange: function (change) {
    this.setState(change);
  },
  onBlur: function(blur) {
    this.setState(blur);
  },
  render: function() {
    return (
      <div>
        <div className="modal fade" id={"email_alert" + this.props.index} tabIndex="-1" role="dialog" aria-labelledby="email_alert_label">
          <div className="modal-dialog modal-md" role="document">
            <div className="modal-content">
              <span className="fa fa-times-circle closeBtn" data-dismiss="modal"></span>
              <div className="modal-body text-center container">
                <h2>Rate Drop Alert</h2>
                <h3 className="mc-blue-primary-text">Sign up for MortgageClub's rate watch and we'll email you when rates drop.</h3>
                <form class="form-horizontal text-center" data-remote="true" id="new_rate_alert" action="/quotes/set_rate_alert" accept-charset="UTF-8" method="post">
                  <div className="form-group">
                    <div className="col-md-6 col-sm-12 text-left">
                      <TextField
                        activateRequiredField={this.state[fields.firstName.error]}
                        label={fields.firstName.label}
                        keyName={fields.firstName.keyName + this.props.index}
                        value={this.state[fields.firstName.keyName]}
                        editable={true}
                        onChange={this.onChange}
                        onBlur={this.onBlur}
                        editMode={true}/>
                    </div>
                    <div className="col-md-6 col-sm-12 text-left">
                      <TextField
                        activateRequiredField={this.state[fields.lastName.error]}
                        label={fields.lastName.label}
                        keyName={fields.lastName.keyName + this.props.index}
                        value={this.state[fields.lastName.keyName]}
                        editable={true}
                        onChange={this.onChange}
                        onBlur={this.onBlur}
                        editMode={true}/>
                    </div>
                    <div className="col-md-12 text-left">
                      <TextField
                        activateRequiredField={this.state[fields.email.error]}
                        label={fields.email.label}
                        keyName={fields.email.keyName + this.props.index}
                        value={this.state[fields.email.keyName]}
                        editable={true}
                        invalidMessage="Your input is not an email."
                        customClass={"account-text-input"}
                        validationTypes={["email"]}
                        onChange={this.onChange}
                        onBlur={this.onBlur}
                        editMode={true}/>
                    </div>
                  </div>
                  <div className="form-group text-center">
                    <div className="col-md-6 col-md-offset-3" style={{"padding-top": "35px","padding-bottom": "20px"}}>
                      <button type="button" onClick={this.submitRateAlert} className="btn btn-mc form-control" style={{"padding-top": "5px"}}>Submit</button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>

        <div className="modal fade" id={"email_inform" + this.props.index} tabIndex="-1" role="dialog" aria-labelledby="email_alert_inform_label">
          <div className="modal-dialog modal-md" role="document">
            <div className="modal-content">
              <span className="fa fa-times-circle closeBtn" data-dismiss="modal"></span>
              <div className="modal-body text-center container">
                <h2>Rate Drop Alert</h2>
                <h3 className="mc-blue-primary-text"><div dangerouslySetInnerHTML={{__html: this.state.rate_alert_inform}} /></h3>
                <form class="form-horizontal text-center" data-remote="true" id="new_rate_alert" action="/quotes/set_rate_alert" accept-charset="UTF-8" method="post">
                  <div className="form-group text-center">
                    <div className="col-md-6 col-md-offset-3" style={{"padding-top": "35px","padding-bottom": "20px"}}>
                      <a className="btn btn-mc form-control" data-dismiss="modal">OK</a>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
})
module.exports = Filter;
