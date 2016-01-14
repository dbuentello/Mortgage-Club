var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var AddressField = require("components/form/NewAddressField");
var DateField = require("components/form/NewDateField");
var TextField = require("components/form/NewTextField");
var SelectField = require("components/form/NewSelectField");
var OtherIncome = require("./OtherIncome");

var incomeFrequencies = [
  {value: "monthly", name: "Monthly"},
  {value: "semimonthly", name: "Semi-monthly"},
  {value: "biweekly", name: "Bi-weekly"},
  {value: "weekly", name: "Weekly"}
];

var Income = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    return {
      otherIncomes: this.props.otherIncomes
    }
  },

  eachOtherIncome: function(income, index) {
    return (
      <OtherIncome
        key={index}
        index={index}
        type={income.type}
        amount={income.amount}
        onChangeType={this.changeIncomeType}
        onChangeAmount={this.changeIncomeAmount}
        onRemove={this.removeOtherIncome}/>
    );
  },

  changeIncomeType: function(value, i) {
    var arr = this.state.otherIncomes;
    arr[i].type = value;
    this.setState({otherIncomes: arr});
    this.props.updateOtheIncomes(this.props.fields, arr);
  },

  changeIncomeAmount: function(value, i) {
    var arr = this.state.otherIncomes;
    arr[i].amount = value;
    this.setState({otherIncomes: arr});
    this.props.updateOtheIncomes(this.props.fields, arr);
  },

  addOtherIncome: function() {
    var arr = this.state.otherIncomes.concat(this.getDefaultOtherIncomes());
    this.setState({otherIncomes: arr});
    this.props.updateOtheIncomes(this.props.fields, arr);
  },

  getDefaultOtherIncomes: function() {
    return [{
      type: null,
      amount: null
    }];
  },

  removeOtherIncome: function(index) {
    var arr = this.state.otherIncomes;
    arr.splice(index, 1);
    this.setState({otherIncomes: arr});
  },

  render: function() {
    return (
      <div>
        <div className='form-group'>
          <div className='col-md-6'>
            <TextField
              activateRequiredField={this.props.currentEmployerName.error}
              label={this.props.fields.currentEmployerName.label}
              keyName={this.props.fields.currentEmployerName.name}
              value={this.props.currentEmployerName}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.currentEmployerName)}
              onChange={this.props.onChange}/>
          </div>
          <div className='col-md-6'>
            <TextField
              activateRequiredField={this.props.activateError}
              label={this.props.fields.currentEmployerAddress.label}
              keyName={this.props.fields.currentEmployerFullTextAddress.name}
              value={this.props.currentEmployerFullTextAddress}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.currentEmployerFullTextAddress)}
              onChange={this.props.onChange}/>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-md-6'>
            <TextField
              activateRequiredField={this.props.activateError}
              label={this.props.fields.currentJobTitle.label}
              keyName={this.props.fields.currentJobTitle.name}
              value={this.props.currentJobTitle}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.currentJobTitle)}
              onChange={this.props.onChange}/>
          </div>
          <div className='col-md-6'>
            <TextField
              activateRequiredField={this.props.activateError}
              label={this.props.fields.currentYearsAtEmployer.label}
              keyName={this.props.fields.currentYearsAtEmployer.name}
              value={this.props.currentYearsAtEmployer}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.currentYearsAtEmployer)}
              onChange={this.props.onChange}/>
          </div>
        </div>
        {
          parseInt(this.props.currentYearsAtEmployer, 10) < 2
          ?
            <div className="previous-employment">
              <div className="form-group">
                <div className="col-md-6">
                  <TextField
                    label={this.props.fields.previousEmployerName.label}
                    keyName={this.props.fields.previousEmployerName.name}
                    value={this.props.previousEmployerName}
                    editable={true}
                    onFocus={_.bind(this.props.onFocus, this, this.props.fields.previousEmployerName)}
                    onChange={this.props.onChange}/>
                </div>
                <div className="col-md-6">
                  <TextField
                    activateRequiredField={this.props.activateError}
                    label={this.props.fields.previousMonthlyIncome.label}
                    keyName={this.props.fields.previousMonthlyIncome.name}
                    value={this.props.previousMonthlyIncome}
                    format={this.formatCurrency}
                    liveFormat={true}
                    editable={true}
                    onFocus={_.bind(this.props.onFocus, this, this.props.fields.previousMonthlyIncome)}
                    onChange={this.props.onChange}/>
                </div>
              </div>
              <div className="form-group">
                <div className="col-md-6">
                  <TextField
                    activateRequiredField={this.props.activateError}
                    label={this.props.fields.previousJobTitle.label}
                    keyName={this.props.fields.previousJobTitle.name}
                    value={this.props.previousJobTitle}
                    editable={true}
                    onFocus={_.bind(this.props.onFocus, this, this.props.fields.previousJobTitle)}
                    onChange={this.props.onChange}/>
                </div>
                <div className="col-md-6">
                  <TextField
                    activateRequiredField={this.props.activateError}
                    label={this.props.fields.previousYearsAtEmployer.label}
                    keyName={this.props.fields.previousYearsAtEmployer.name}
                    value={this.props.previousYearsAtEmployer}
                    editable={true}
                    onFocus={_.bind(this.props.onFocus, this, this.props.fields.previousYearsAtEmployer)}
                    onChange={this.props.onChange}/>
                </div>
              </div>
            </div>
          : null
        }

        <h3 className="text-uppercase">best contact to confirm employment</h3>
        <div className="form-group">
          <div className="col-md-6">
            <TextField
              activateRequiredField={this.props.activateError}
              label={this.props.fields.employerContactName.label}
              keyName={this.props.fields.employerContactName.name}
              value={this.props.employerContactName}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.employerContactName)}
              onChange={this.props.onChange}/>
          </div>
          <div className="col-md-6">
            <TextField
              activateRequiredField={this.props.activateError}
              label={this.props.fields.employerContactNumber.label}
              keyName={this.props.fields.employerContactNumber.name}
              value={this.props.employerContactNumber}
              format={this.formatPhoneNumber}
              liveFormat={true}
              maxLength={14}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.employerContactNumber)}
              onChange={this.props.onChange}/>
          </div>
        </div>
        <h3 className="text-uppercase">income details</h3>
        <div className="form-group">
          <div className="col-md-6">
            <TextField
              activateRequiredField={this.props.activateError}
              label={this.props.fields.baseIncome.label}
              keyName={this.props.fields.baseIncome.name}
              value={this.props.baseIncome}
              liveFormat={true}
              format={this.formatCurrency}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.baseIncome)}
              onChange={this.props.onChange}
              placeholder="e.g. 99,000"/>
          </div>
          <div className="col-md-6">
            <SelectField
              activateRequiredField={this.props.activateError}
              label={this.props.fields.incomeFrequency.label}
              keyName={this.props.fields.incomeFrequency.name}
              value={this.props.incomeFrequency}
              options={incomeFrequencies}
              editable={true}
              onChange={this.props.onChange}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.incomeFrequency)}
              allowBlank={true}/>
          </div>
        </div>

        {this.state.otherIncomes.map(this.eachOtherIncome)}

        <div className="form-group">
          <div className="col-md-12 clickable" onClick={this.addOtherIncome}>
            <h5>
              <span className="glyphicon glyphicon-plus-sign"></span>
                Add other income
            </h5>
          </div>
        </div>
      </div>
    )
  }
})

module.exports = Income;