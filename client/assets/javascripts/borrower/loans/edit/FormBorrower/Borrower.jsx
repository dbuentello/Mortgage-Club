var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var ObjectHelperMixin = require("mixins/ObjectHelperMixin");

var AddressField = require("components/form/NewAddressField");
var DateField = require("components/form/NewDateField");
var SelectField = require("components/form/NewSelectField");
var TextField = require("components/form/NewTextField");
var BooleanRadio = require("components/form/NewBooleanRadio");
var maritalStatuses = [
  {name: "Married", value: "married"},
  {name: "Unmarried", value: "unmarried"},
  {name: "Separated", value: "separated"}
];

var Borrower = React.createClass({
  mixins: [TextFormatMixin, ObjectHelperMixin],

  render: function() {
    return (
      <div>
        <div className="form-group">
          <div className="col-md-3">
            <TextField
              label={this.props.fields.firstName.label}
              keyName={this.props.fields.firstName.name}
              value={this.props.firstName}
              customClass={"account-text-input"}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.firstName)}
              onChange={this.props.onChange}/>
          </div>
          <div className="col-md-3">
            <TextField
              label={this.props.fields.middleName.label}
              keyName={this.props.fields.middleName.name}
              value={this.props.middleName}
              customClass={"account-text-input"}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.middleName)}
              onChange={this.props.onChange}/>
          </div>
          <div className="col-md-3">
            <TextField
              label={this.props.fields.lastName.label}
              keyName={this.props.fields.lastName.name}
              value={this.props.lastName}
              customClass={"account-text-input"}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.lastName)}
              onChange={this.props.onChange}/>
          </div>
          <div className="col-md-3">
            <TextField
              label={this.props.fields.suffix.label}
              keyName={this.props.fields.suffix.name}
              value={this.props.suffix}
              customClass={"account-text-input"}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.suffix)}
              onChange={this.props.onChange}/>
          </div>
        </div>
        <div className="form-group">
            { this.props.isSecondary
              ?
              <div className="col-md-6">
                <TextField
                  label={this.props.fields.email.label}
                  keyName={this.props.fields.email.name}
                  value={this.props.email}
                  customClass={"account-text-input"}
                  onFocus={_.bind(this.props.onFocus, this, this.props.fields.email)}
                  onChange={this.props.onChange}/>
              </div>
              :
                null
            }
          <div className="col-md-6">
            <DateField
              label={this.props.fields.dob.label}
              keyName={this.props.fields.dob.name}
              value={this.props.dob}
              customClass={"account-text-input"}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.dob)}
              onChange={this.props.onChange}/>
          </div>
        </div>
        <div className="form-group">
          <div className="col-md-6">
            <TextField
              label={this.props.fields.ssn.label}
              keyName={this.props.fields.ssn.name}
              value={this.props.ssn}
              customClass={"account-text-input"}
              format={this.formatSSN}
              liveFormat={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.ssn)}
              onChange={this.props.onChange}/>
          </div>
          <div className="col-md-6">
            <TextField
              label={this.props.fields.phone.label}
              keyName={this.props.fields.phone.name}
              value={this.props.phone}
              customClass={"account-text-input"}
              liveFormat={true}
              maxLength={14}
              format={this.formatPhoneNumber}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.phone)}
              onChange={this.props.onChange}/>
          </div>
        </div>
        <div className="form-group">
          <div className="col-md-6">
            <TextField
              label={this.props.fields.yearsInSchool.label}
              keyName={this.props.fields.yearsInSchool.name}
              value={this.props.yearsInSchool}
              customClass={"account-text-input"}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.yearsInSchool)}
              onChange={this.props.onChange}/>
          </div>
          <div className="col-md-6">
            <SelectField
              label={this.props.fields.maritalStatus.label}
              keyName={this.props.fields.maritalStatus.name}
              value={this.props.maritalStatus}
              options={maritalStatuses}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.maritalStatus)}
              onChange={this.props.onChange}/>
          </div>
        </div>
        <div className="form-group">
          <div className="col-md-6">
            <TextField
              label={this.props.fields.numberOfDependents.label}
              keyName={this.props.fields.numberOfDependents.name}
              value={this.props.numberOfDependents}
              customClass={"account-text-input"}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.numberOfDependents)}
              onChange={this.props.onChange}/>
          </div>
          <div className="col-md-6">
            { parseInt(this.props.numberOfDependents, 10) > 0 ?
              <TextField
                label={this.props.fields.dependentAges.label}
                keyName={this.props.fields.dependentAges.name}
                value={this.props.dependentAges}
                customClass={"account-text-input"}
                placeholder="e.g. 12, 7, 3"
                onFocus={_.bind(this.props.onFocus, this, this.props.fields.dependentAges)}
                onChange={this.props.onChange}/>
            : null }
          </div>
        </div>
        <div className="form-group">
          <div className="col-md-12">
            <AddressField
              label={this.props.fields.currentAddress.label}
              address={this.props.currentAddress}
              keyName={this.props.fields.currentAddress.name}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.currentAddress)}
              onChange={this.props.onChange}
              placeholder=""/>
          </div>
        </div>
        <div className="form-group">
          <div className="col-md-4">
            <BooleanRadio
              label={this.props.fields.currentlyOwn.label}
              checked={this.props.currentlyOwn}
              keyName={this.props.fields.currentlyOwn.name}
              yesLabel={"Own"}
              noLabel={"Rent"}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.currentlyOwn)}
              onChange={this.props.onChange}/>
          </div>
          <div className="col-md-4">
            { this.props.currentlyOwn ? null
              :
                <TextField
                  label={this.props.fields.currentMonthlyRent.label}
                  value={this.props.currentMonthlyRent}
                  keyName={this.props.fields.currentMonthlyRent.name}
                  customClass={"account-text-input"}
                  liveFormat={true}
                  format={this.formatCurrency}
                  onFocus={_.bind(this.props.onFocus, this, this.props.fields.currentMonthlyRent)}
                  onChange={this.props.onChange}/>
            }
          </div>
          <div className="col-md-4">
            <TextField
              label={this.props.fields.yearsInCurrentAddress.label}
              value={this.props.yearsInCurrentAddress}
              keyName={this.props.fields.yearsInCurrentAddress.name}
              customClass={"account-text-input"}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.yearsInCurrentAddress)}
              onChange={this.props.onChange}/>
          </div>
        </div>
        <div className="form-group">
          <div className="col-md-4">
            <BooleanRadio
              label={this.props.fields.selfEmployed.label}
              checked={this.props.selfEmployed}
              keyName={this.props.fields.selfEmployed.name}
              yesLabel={"Yes"}
              noLabel={"No"}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.selfEmployed)}
              onChange={this.props.onChange}/>
          </div>
        </div>
        { parseInt(this.props.yearsInCurrentAddress, 10) < 2 ?
          <div>
          <div className="form-group">
            <div className="col-md-12">
              <AddressField
                label={this.props.fields.previousAddress.label}
                address={this.props.previousAddress}
                keyName={this.props.fields.previousAddress.name}
                editable={true}
                onFocus={_.bind(this.props.onFocus, this, this.props.fields.previousAddress)}
                onChange={this.props.onChange}
                placeholder=""/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-md-6">
              <BooleanRadio
                label={this.props.fields.previouslyOwn.label}
                checked={this.props.previouslyOwn}
                keyName={this.props.fields.previouslyOwn.name}
                yesLabel={"Own"}
                noLabel={"Rent"}
                editable={true}
                onFocus={_.bind(this.props.onFocus, this, this.props.fields.previouslyOwn)}
                onChange={this.props.onChange}/>
            </div>
            <div className="col-md-4">
              { this.props.previouslyOwn ? null
                :
                  <TextField
                    label={this.props.fields.previousMonthlyRent.label}
                    value={this.props.previousMonthlyRent}
                    keyName={this.props.fields.previousMonthlyRent.name}
                    customClass={"account-text-input"}
                    liveFormat={true}
                    format={this.formatCurrency}
                    onFocus={_.bind(this.props.onFocus, this, this.props.fields.previousMonthlyRent)}
                    onChange={this.props.onChange}/>
              }
            </div>
          </div>
          <div className="form-group">
            <div className="col-xs-6">
              <TextField
                label={this.props.fields.yearsInPreviousAddress.label}
                value={this.props.yearsInPreviousAddress}
                keyName={this.props.fields.yearsInPreviousAddress.name}
                customClass={"account-text-input"}
                onFocus={_.bind(this.props.onFocus, this, this.props.fields.yearsInPreviousAddress)}
                onChange={this.props.onChange}/>
            </div>
          </div>
        </div>
        : null }
      </div>
    )
  }
});

module.exports = Borrower;