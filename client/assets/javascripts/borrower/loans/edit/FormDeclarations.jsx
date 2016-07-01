var _ = require('lodash');
var React = require('react/addons');
var ValidationObject = require("mixins/FormValidationMixin");
var AddressField = require('components/form/NewAddressField');
var SelectField = require('components/form/NewSelectField');
var TextField = require('components/form/NewTextField');
var BooleanRadio = require('components/form/NewBooleanRadio');

var Router = require('react-router');
var { Route, RouteHandler, Link } = Router;

var checkboxFields = {
  ownershipInterest: {
    label: 'Have you had an ownership interest in a property in the last three years?',
    name: 'ownership_interest',
    error: "ownershipInterestError",
    validationTypes: ["empty"]
  }
};

var selectBoxFields = {
  citizenshipStatus: {label: 'What\'s your citizenship status?', name: 'citizen_status', error: 'citizenshipStatusError', validationTypes: ["empty"]},
  isHispanicOrLatino: {label: 'I am', name: 'is_hispanic_or_latino', error: 'isHispanicOrLatinoError', validationTypes: ["empty"]},
  genderType: {label: 'What\'s your gender?', name: 'gender_type', error: 'genderTypeError', validationTypes: ["empty"]},
  raceType: {label: 'What\'s your race?', name: 'race_type', error: 'raceTypeError', validationTypes: ["empty"]},
  typeOfProperty: {label: '(1) What type of property did you own?', name: 'type_of_property', error: "typeOfPropertyError", validationTypes: ["empty"]},
  titleOfProperty: {label: '(2) How did you hold title to this property?', name: 'title_of_property', error: "titleOfPropertyError", validationTypes: ["empty"]}
}

var citizenshipStatusOptions = [
  {name: 'Citizen', value: 'C'},
  {name: 'Permanent Resident', value: 'PR'},
  {name: 'Others', value: 'O'}
];

var isHispanicOrLatinoOptions = [
  {name: 'Hispanic or Latino', value: 'Y'},
  {name: 'Not Hispanic or Latino', value: 'N'}
];

var genderTypeOptions = [
  {name: 'Male', value: 'M'},
  {name: 'Female', value: 'F'}
];

var raceTypeOptions = [
  {name: 'American Indian or Alaska Native', value: 'AIoAN'},
  {name: 'Asian', value: 'A'},
  {name: 'Black or African American', value: 'BoAA'},
  {name: 'Native Hawaiian or Other Pacific Islander', value: 'NHoOPI'},
  {name: 'White', value: 'W'}
];

var propertyOptions = [
  {name: 'Primary Residence', value: 'PR'},
  {name: 'Secondary Resident', value: 'SH'},
  {name: 'Investment Property', value: 'IP'}
];

var titlePropertyOptions = [
  {name: 'Self', value: 'S'},
  {name: 'With spouse', value: 'SP'},
  {name: 'Other', value: 'O'}
]

var FormDeclarations = React.createClass({
  mixins: [ValidationObject],

  getInitialState: function() {
    var state = this.buildStateFromLoan(this.props.loan);
    state.isValid = true;
    _.each(checkboxFields, function (field) {
      state[field.name] = state[field.name] === null ? null : state[field.name];
      state[field.name + '_display'] = true;
    });

    _.each(selectBoxFields, function (field) {
      state[field.name] = state[field.name] === null ? null : state[field.name];
    });

    if(state['ownership_interest'] == true) {
      state['display_sub_question'] = true;
    }else {
      state['display_sub_question'] = 'none';
    }

    return state;
  },

  componentDidUpdate: function(){
    if(!this.state.isValid)
      this.scrollTopError();
  },

  componentDidMount: function(){
    $("body").scrollTop(0);
  },

  onChange: function(change) {
    var key = Object.keys(change)[0];
    var value = change[key];
    if(key == 'ownership_interest') {
      if(value == true) {
        this.setState({'display_sub_question': true});
      }else {
        this.setState({'display_sub_question': 'none'});
      }
    }
    this.setState(change);
  },

  buildStateFromLoan: function(loan) {
    var declaration = loan.borrower.declaration;
    var state = {};
    if (declaration) {
      _.each(Object.keys(checkboxFields), function(key) {
        state[checkboxFields[key].name] = declaration[checkboxFields[key].name];
      });
      _.each(Object.keys(selectBoxFields), function(key) {
        state[selectBoxFields[key].name] = declaration[selectBoxFields[key].name];
      });
    }
    return state;
  },

  buildLoanFromState: function() {
    var loan = {};

    // For borrower data
    loan.borrower_attributes = {id: this.props.loan.borrower.id};

    var declaration_attributes = {};
    _.each(checkboxFields, function (field) {
      declaration_attributes[field.name] = this.state[field.name];
    }, this);

    if (this.state.ownership_interest == false) {
      this.state.type_of_property = null;
      this.state.title_of_property = null;
    }

    _.each(selectBoxFields, function (field) {
      declaration_attributes[field.name] = this.state[field.name];
    }, this);

    declaration_attributes['outstanding_judgment'] = false;
    declaration_attributes['bankrupt'] = false;
    declaration_attributes['property_foreclosed'] = false;
    declaration_attributes['party_to_lawsuit'] = false;
    declaration_attributes['loan_foreclosure'] = false;
    declaration_attributes['present_delinquent_loan'] = false;
    declaration_attributes['child_support'] = false;
    declaration_attributes['down_payment_borrowed'] = false;
    declaration_attributes['co_maker_or_endorser'] = false;

    if (this.props.loan.borrower.declaration) {
      declaration_attributes.id = this.props.loan.borrower.declaration.id;
    }

    loan.borrower_attributes.declaration_attributes = declaration_attributes;
    return loan;
  },

  render: function() {
    return (
      <div className='col-sm-9 col-xs-12 account-content'>
        <form className='form-horizontal'>
          <div className='form-group'>
            <p className="box-description col-sm-12">
              The government requires us to ask you these questions so they can monitor that we adhere to fair lending practices. We’ve made them as simple as possible.
            </p>
          </div>
          <div className='form-group'>
            <div className="col-md-6">
              <SelectField
                activateRequiredField={this.state[selectBoxFields.citizenshipStatus.error]}
                label={selectBoxFields.citizenshipStatus.label}
                keyName={selectBoxFields.citizenshipStatus.name}
                value={this.state[selectBoxFields.citizenshipStatus.name]}
                options={citizenshipStatusOptions}
                editable={true}
                name={'citizen_status'}
                allowBlank={true}
                onChange={this.onChange}
                editMode={this.props.editMode}/>
            </div>
          </div>
           <div className='form-group'>
            <div className="col-md-6">
              <SelectField
                activateRequiredField={this.state[selectBoxFields.isHispanicOrLatino.error]}
                label={selectBoxFields.isHispanicOrLatino.label}
                keyName={selectBoxFields.isHispanicOrLatino.name}
                value={this.state[selectBoxFields.isHispanicOrLatino.name]}
                options={isHispanicOrLatinoOptions}
                editable={true}
                name={'is_hispanic_or_latino'}
                allowBlank={true}
                onChange={this.onChange}
                editMode={this.props.editMode}/>
            </div>
          </div>
           <div className='form-group'>
            <div className="col-md-6">
              <SelectField
                activateRequiredField={this.state[selectBoxFields.raceType.error]}
                label={selectBoxFields.raceType.label}
                keyName={selectBoxFields.raceType.name}
                value={this.state[selectBoxFields.raceType.name]}
                options={raceTypeOptions}
                editable={true}
                name={'race_type'}
                allowBlank={true}
                onChange={this.onChange}
                editMode={this.props.editMode}/>
            </div>
          </div>
           <div className='form-group'>
            <div className="col-md-6">
              <SelectField
                activateRequiredField={this.state[selectBoxFields.genderType.error]}
                label={selectBoxFields.genderType.label}
                keyName={selectBoxFields.genderType.name}
                value={this.state[selectBoxFields.genderType.name]}
                options={genderTypeOptions}
                editable={true}
                name={'gender_type'}
                allowBlank={true}
                onChange={this.onChange}
                editMode={this.props.editMode}/>
            </div>
          </div>
          {
            _.map(Object.keys(checkboxFields), function(key) {
              return (
                <div className='form-group' key={key} style={{display: this.state[checkboxFields[key].name + '_display']}}>
                  <div className="col-md-12">
                    <BooleanRadio
                      activateRequiredField={this.state[checkboxFields[key].error]}
                      label={checkboxFields[key].label}
                      isDeclaration={true}
                      keyName={checkboxFields[key].name}
                      customColumn={"col-xs-2"}
                      editable={true}
                      checked={this.state[checkboxFields[key].name]}
                      onChange={this.onChange}
                      editMode={this.props.editMode}/>
                    </div>
                </div>
              )
            }, this)
          }

          <div className='form-group' style={{display: this.state.display_sub_question}}>
            <div className="col-md-6">
              <SelectField
                activateRequiredField={this.state[selectBoxFields.typeOfProperty.error]}
                label={selectBoxFields.typeOfProperty.label}
                keyName={selectBoxFields.typeOfProperty.name}
                value={this.state[selectBoxFields.typeOfProperty.name]}
                options={propertyOptions}
                editable={true}
                name={'type_of_property'}
                allowBlank={true}
                onChange={this.onChange}
                editMode={this.props.editMode}/>
            </div>
          </div>
          <div className='form-group' style={{display: this.state.display_sub_question}}>
            <div className="col-md-6">
              <SelectField
                activateRequiredField={this.state[selectBoxFields.titleOfProperty.error]}
                label={selectBoxFields.titleOfProperty.label}
                keyName={selectBoxFields.titleOfProperty.name}
                value={this.state[selectBoxFields.titleOfProperty.name]}
                options={titlePropertyOptions}
                editable={true}
                allowBlank={true}
                name={'title_of_property'}
                onChange={this.onChange}
                editMode={this.props.editMode}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-md-12">
              {
                this.props.editMode
                ?
                  <button className="btn text-uppercase" id="continueBtn" onClick={this.save}>{ this.state.saving ? 'Saving' : 'Save and Continue' }<img src="/icons/arrowRight.png" alt="arrow"/></button>
                :
                  <button className="btn text-uppercase" id="nextBtn" onClick={this.next}>Return to dashboard</button>
              }
            </div>
          </div>
        </form>
      </div>
    );
  },

  omitKeys: function(obj, keys) {
    var dup = {};
    for (var key in obj) {
      if (keys.indexOf(key) == -1) {
        dup[key] = obj[key];
      }
    }
    return dup;
  },

  mapValueToRequiredFields: function() {
    var requiredFields = {};

    _.each(checkboxFields, function(field) {
      requiredFields[field.error] = {value: this.state[field.name], validationTypes: field.validationTypes};
    }, this);

    requiredFields[selectBoxFields.citizenshipStatus.error] = {value: this.state[selectBoxFields.citizenshipStatus.name], validationTypes: selectBoxFields.citizenshipStatus.validationTypes};
    requiredFields[selectBoxFields.isHispanicOrLatino.error] = {value: this.state[selectBoxFields.isHispanicOrLatino.name], validationTypes: selectBoxFields.isHispanicOrLatino.validationTypes};
    requiredFields[selectBoxFields.raceType.error] = {value: this.state[selectBoxFields.raceType.name], validationTypes: selectBoxFields.raceType.validationTypes};
    requiredFields[selectBoxFields.genderType.error] = {value: this.state[selectBoxFields.genderType.name], validationTypes: selectBoxFields.genderType.validationTypes};

    if(this.state.display_sub_question == true) {
      requiredFields[selectBoxFields.typeOfProperty.error] = {value: this.state[selectBoxFields.typeOfProperty.name], validationTypes: selectBoxFields.typeOfProperty.validationTypes};
      requiredFields[selectBoxFields.titleOfProperty.error] = {value: this.state[selectBoxFields.titleOfProperty.name], validationTypes:selectBoxFields.titleOfProperty.validationTypes};
    }

    return requiredFields;
  },

  valid: function(){
    var isValid = true;
    var requiredFields = this.mapValueToRequiredFields();
    if(!_.isEmpty(this.getStateOfInvalidFields(requiredFields))) {
      this.setState(this.getStateOfInvalidFields(requiredFields));
      isValid = false;
    }

    return isValid;
  },

  scrollTopError: function(){
    var offset = $(".tooltip").first().parents(".form-group").offset();
    var top = offset === undefined ? 0 : offset.top;
    $('html, body').animate({scrollTop: top}, 1000);
    this.setState({isValid: true});
  },

  next: function(event){
    this.props.next(7, true);
    event.preventDefault();
  },

  save: function(event) {
    event.preventDefault();
    if(this.valid() == false){
      this.setState({saving: false, isValid: false});
      return false;
    }

    this.setState({saving: true, isValid: true});
    this.props.saveLoan(this.buildLoanFromState(), 6, true, true);
  }

});

module.exports = FormDeclarations;
