var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var TextField = require("components/form/TextField");
var SelectField = require("components/form/SelectField");
var AddressField = require("components/form/AddressField");
var BooleanRadio = require('components/form/BooleanRadio');
var DateField = require('components/form/DateField');

var fields = {
  from: {label: "From", name: "from"},
  to: {label: "To", name: "to"},
  bcc: {label: "Bcc", name: "bcc"},
  cc: {label: "Cc", name: "cc"}
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

var EmailDashboardTab = React.createClass({
  mixins: [TextFormatMixin],

  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function() {
    return this.buildState(this.props.loan, this.props.property, this.props.loanMember, this.props.borrower);
  },

  buildState: function(loan, property, loanMember, borrower) {
    var state = {};

    state[fields.from.name] = loanMember.first_name + " " + loanMember.last_name + " <" + loanMember.email + ">";
    state[fields.to.name] = borrower.first_name + " " + borrower.last_name + " <" + borrower.user.email + ">";

    // var propertyValue = loan.purpose == "purchase" ? property.purchase_price : property.market_price;

    // state[fields.address.name] = property.address;
    // state[fields.loanType.name] = loan.amortization_type;
    // state[fields.propertyValue.name] = this.formatCurrency(propertyValue, "$");
    // state[fields.loanAmount.name] = this.formatCurrency(loan.amount, "$");

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

      },
      method: "POST",
      dataType: "json",
      success: function(response) {
        this.setState({saving: false});
        var state = this.buildState(response.loan, response.property, response.loan_member);
        this.setState(state);
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
            <h4 className="panel-title">Email Dashboard</h4>
          </div>
          <form className="form-horizontal form-checklist">
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.from.label}
                  keyName={fields.from.name}
                  value={this.state[fields.from.name]}
                  maxLength={11}
                  editable={false}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.to.label}
                  keyName={fields.to.name}
                  value={this.state[fields.to.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.bcc.label}
                  keyName={fields.bcc.name}
                  value={this.state[fields.bcc.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.cc.label}
                  keyName={fields.cc.name}
                  value={this.state[fields.cc.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
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

module.exports = EmailDashboardTab;
