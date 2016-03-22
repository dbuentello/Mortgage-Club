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
        typeError={income.typeError}
        name={this.props.fields.otherIncomes.name}
        amountError={income.amountError}
        onChangeType={this.changeIncomeType}
        onChangeAmount={this.changeIncomeAmount}
        onRemove={this.removeOtherIncome}
        editMode={this.props.editMode}/>
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
      amount: null,
      typeError: false,
      amountError: false
    }];
  },

  removeOtherIncome: function(index) {
    var arr = this.state.otherIncomes;
    arr.splice(index, 1);
    this.setState({otherIncomes: arr});
  },

  componentDidUpdate: function() {

  },

  componentDidMount: function() {
    $("#" + this.props.fields.currentEmployerName.name).autoComplete({
      minChars: 1,
      source: function(term, response){
        $.getJSON("https://autocomplete.clearbit.com/v1/companies/suggest", { query: term }, function(data){ response(data); });
      },
      renderItem: function (item, search) {
        var default_logo = "/unknown-logo.gif";

        if(item.logo == null) {
          var logo = default_logo;
        } else {
          var logo = item.logo + "?size=25x25";
        }

        var container = "<div class='autocomplete-suggestion' data-domain='" + item.domain + "' data-name='" + item.name + "' data-val='" + search + "'>";
        container += '<span class="icon"><img align="center" src="'+ logo + '" onerror="this.src=\'' + default_logo + '\'"></span> ';
        container += item.name + "<span class='domain'>" + item.domain + "</span></div>";
        return container;
      },
      onSelect: function(e, term, item){
        var state = {};
        state[this.props.fields.currentEmployerName.name] = item.data("name");

        $.getJSON("/company_info", {domain: item.data("domain")} ,function(data){ this.processCompanyData(data); }.bind(this));

        this.props.onChange(state);
      }.bind(this)
    });
  },

  processCompanyData: function(responseData){
    var state = {};
    console.log(responseData);
    var companyInfo = responseData.data.company_info;
    var currentAddress = this.props.currentEmployerAddress || {};

    var phoneNumber = companyInfo.contact_phone_number == "" ? "" : companyInfo.contact_phone_number.replace(/-/g, "");
    state[this.props.fields.employerContactNumber.name] = this.formatPhoneNumber(phoneNumber);
    state[this.props.fields.employerContactName.name] = companyInfo.contact_name;

    currentAddress.city = companyInfo.city;
    currentAddress.state = companyInfo.state;
    currentAddress.street_address = companyInfo.street_address;
    currentAddress.zip = companyInfo.zip;
    currentAddress.full_text = $.grep([companyInfo.street_address, companyInfo.city, companyInfo.state], Boolean).join(", ") + " " + companyInfo.zip;

    state[this.props.fields.currentEmployerAddress.name] = currentAddress;
    this.props.onChange(state);
  },

  render: function() {
    return (
      <div>
        <div className='form-group'>
          <div className='col-md-6'>
            <TextField
              customClass={"autocomplete-input"}
              activateRequiredField={this.props.currentEmployerNameError}
              label={this.props.fields.currentEmployerName.label}
              keyName={this.props.fields.currentEmployerName.name}
              value={this.props.currentEmployerName}
              editable={true}
              maxLength={100}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.currentEmployerName)}
              onChange={this.props.onChange}
              editMode={this.props.editMode}/>
          </div>
          <div className='col-md-6'>
            <AddressField
              activateRequiredField={this.props.currentEmployerAddressError}
              label={this.props.fields.currentEmployerAddress.label}
              address={this.props.currentEmployerAddress}
              keyName={this.props.fields.currentEmployerAddress.name}
              editable={true}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.currentEmployerAddress)}
              onChange={this.props.onChange}
              editMode={this.props.editMode}/>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-md-6'>
            <TextField
              activateRequiredField={this.props.currentJobTitleError}
              label={this.props.fields.currentJobTitle.label}
              keyName={this.props.fields.currentJobTitle.name}
              value={this.props.currentJobTitle}
              editable={true}
              maxLength={100}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.currentJobTitle)}
              onChange={this.props.onChange}
              editMode={this.props.editMode}/>
          </div>
          <div className='col-md-6'>
            <TextField
              activateRequiredField={this.props.currentYearsAtEmployerError}
              label={this.props.fields.currentYearsAtEmployer.label}
              keyName={this.props.fields.currentYearsAtEmployer.name}
              value={this.props.currentYearsAtEmployer}
              editable={true}
              maxLength={2}
              liveFormat={true}
              format={this.formatInteger}
              validationTypes={["integer"]}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.currentYearsAtEmployer)}
              onChange={this.props.onChange}
              editMode={this.props.editMode}/>
          </div>
        </div>
        {
          parseInt(this.props.currentYearsAtEmployer, 10) < 2
          ?
            <div className="previous-employment">
              <div className="form-group">
                <div className="col-md-6">
                  <TextField
                    activateRequiredField={this.props.previousEmployerNameError}
                    label={this.props.fields.previousEmployerName.label}
                    keyName={this.props.fields.previousEmployerName.name}
                    value={this.props.previousEmployerName}
                    editable={true}
                    maxLength={100}
                    onFocus={_.bind(this.props.onFocus, this, this.props.fields.previousEmployerName)}
                    onChange={this.props.onChange}
                    editMode={this.props.editMode}/>
                </div>
                <div className="col-md-6">
                  <TextField
                    activateRequiredField={this.props.previousMonthlyIncomeError}
                    label={this.props.fields.previousMonthlyIncome.label}
                    keyName={this.props.fields.previousMonthlyIncome.name}
                    value={this.props.previousMonthlyIncome}
                    format={this.formatCurrency}
                    editable={true}
                    validationTypes={["currency"]}
                    maxLength={15}
                    onFocus={_.bind(this.props.onFocus, this, this.props.fields.previousMonthlyIncome)}
                    onChange={this.props.onChange}
                    onBlur={this.props.onBlur}
                    editMode={this.props.editMode}/>
                </div>
              </div>
              <div className="form-group">
                <div className="col-md-6">
                  <TextField
                    activateRequiredField={this.props.previousJobTitleError}
                    label={this.props.fields.previousJobTitle.label}
                    keyName={this.props.fields.previousJobTitle.name}
                    value={this.props.previousJobTitle}
                    editable={true}
                    maxLength={100}
                    onFocus={_.bind(this.props.onFocus, this, this.props.fields.previousJobTitle)}
                    onChange={this.props.onChange}
                    editMode={this.props.editMode}/>
                </div>
                <div className="col-md-6">
                  <TextField
                    activateRequiredField={this.props.previousYearsAtEmployerError}
                    label={this.props.fields.previousYearsAtEmployer.label}
                    keyName={this.props.fields.previousYearsAtEmployer.name}
                    value={this.props.previousYearsAtEmployer}
                    editable={true}
                    maxLength={2}
                    liveFormat={true}
                    format={this.formatInteger}
                    validationTypes={["integer"]}
                    onFocus={_.bind(this.props.onFocus, this, this.props.fields.previousYearsAtEmployer)}
                    onChange={this.props.onChange}
                    editMode={this.props.editMode}/>
                </div>
              </div>
            </div>
          : null
        }
        <h6 className="text-capitalize title-h6">best contact to confirm employment</h6>
        <div className="form-group">
          <div className="col-md-6">
            <TextField
              activateRequiredField={this.props.employerContactNameError}
              label={this.props.fields.employerContactName.label}
              keyName={this.props.fields.employerContactName.name}
              value={this.props.employerContactName}
              editable={true}
              maxLength={100}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.employerContactName)}
              onChange={this.props.onChange}
              editMode={this.props.editMode}/>
          </div>
          <div className="col-md-6">
            <TextField
              activateRequiredField={this.props.employerContactNumberError}
              label={this.props.fields.employerContactNumber.label}
              keyName={this.props.fields.employerContactNumber.name}
              value={this.props.employerContactNumber}
              format={this.formatPhoneNumber}
              liveFormat={true}
              maxLength={14}
              editable={true}
              validationTypes={["phoneNumber"]}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.employerContactNumber)}
              onChange={this.props.onChange}
              editMode={this.props.editMode}/>
          </div>
        </div>
        <h6 className="text-capitalize title-h6">income details</h6>
        <div className="form-group">
          <div className="col-md-6">
            <TextField
              activateRequiredField={this.props.baseIncomeError}
              label={this.props.fields.baseIncome.label}
              keyName={this.props.fields.baseIncome.name}
              value={this.props.baseIncome}
              format={this.formatCurrency}
              editable={true}
              validationTypes={["currency"]}
              maxLength={15}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.baseIncome)}
              onChange={this.props.onChange}
              placeholder="e.g. 99,000"
              onBlur={this.props.onBlur}
              editMode={this.props.editMode}/>
          </div>
          <div className="col-md-6">
            <SelectField
              activateRequiredField={this.props.incomeFrequencyError}
              label={this.props.fields.incomeFrequency.label}
              keyName={this.props.fields.incomeFrequency.name}
              value={this.props.incomeFrequency}
              options={incomeFrequencies}
              editable={true}
              onChange={this.props.onChange}
              onFocus={_.bind(this.props.onFocus, this, this.props.fields.incomeFrequency)}
              allowBlank={true}
              editMode={this.props.editMode}/>
          </div>
        </div>

        {this.state.otherIncomes.map(this.eachOtherIncome)}

        {
          this.props.editMode
          ?
            <div className="form-group">
              <div className="col-md-12 clickable" onClick={this.addOtherIncome}>
                <h5>
                  <span className="glyphicon glyphicon-plus-sign"></span>
                    Add Other Income
                </h5>
              </div>
            </div>
          : null
        }
      </div>
    )
  }
})

module.exports = Income;