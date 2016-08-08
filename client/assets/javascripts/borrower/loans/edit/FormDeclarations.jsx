var _ = require('lodash');
var React = require('react/addons');
var ValidationObject = require("mixins/FormValidationMixin");
var AddressField = require('components/form/NewAddressField');
var SelectField = require('components/form/NewSelectField');
var TextField = require('components/form/NewTextField');
var BooleanRadio = require('components/form/NewBooleanRadio');

var Router = require('react-router');
var { Route, RouteHandler, Link } = Router;

var borrowerFields = {
  ownershipInterest: { label: 'Have you had an ownership interest in a property in the last three years?', name: 'ownership_interest', error: "ownershipInterestError", validationTypes: ["empty"] },
  citizenshipStatus: { label: 'What\'s your citizenship status?', name: 'citizen_status', error: 'citizenshipStatusError', validationTypes: ["empty"] },
  isHispanicOrLatino: { label: 'I am', name: 'is_hispanic_or_latino', error: 'isHispanicOrLatinoError', validationTypes: ["empty"] },
  genderType: { label: 'What\'s your gender?', name: 'gender_type', error: 'genderTypeError', validationTypes: ["empty"] },
  raceType: { label: 'What\'s your race?', name: 'race_type', error: 'raceTypeError', validationTypes: ["empty"] },
  typeOfProperty: { label: '(1) What type of property did you own?', name: 'type_of_property', error: "typeOfPropertyError", validationTypes: ["empty"] },
  titleOfProperty: { label: '(2) How did you hold title to this property?', name: 'title_of_property', error: "titleOfPropertyError", validationTypes: ["empty"] }
}

var coBorrowerFields = {
  ownershipInterest: { label: 'Have you had an ownership interest in a property in the last three years?', name: 'co_borrower_ownership_interest', error: "coBorrowerOwnershipInterestError", validationTypes: ["empty"] },
  citizenshipStatus: { label: 'What\'s your citizenship status?', name: 'co_borrower_citizen_status', error: 'coBorrowerCitizenshipStatusError', validationTypes: ["empty"] },
  isHispanicOrLatino: { label: 'I am', name: 'co_borrower_is_hispanic_or_latino', error: 'coBorrowerIsHispanicOrLatinoError', validationTypes: ["empty"] },
  genderType: { label: 'What\'s your gender?', name: 'co_borrower_gender_type', error: 'coBorrowerGenderTypeError', validationTypes: ["empty"] },
  raceType: { label: 'What\'s your race?', name: 'co_borrower_race_type', error: 'coBorrowerRaceTypeError', validationTypes: ["empty"] },
  typeOfProperty: { label: '(1) What type of property did you own?', name: 'co_borrower_type_of_property', error: "coBorrowerTypeOfPropertyError", validationTypes: ["empty"] },
  titleOfProperty: { label: '(2) How did you hold title to this property?', name: 'co_borrower_title_of_property', error: "coBorrowerTitleOfPropertyError", validationTypes: ["empty"] }
}

var citizenshipStatusOptions = [
  {name: 'Citizen', value: 'C'},
  {name: 'Permanent Resident', value: 'PR'},
  {name: 'Other', value: 'O'}
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

    _.each(borrowerFields, function (field) {
      state[field.name] = state[field.name] === null ? null : state[field.name];
    });

    _.each(coBorrowerFields, function (field) {
      state[field.name] = state[field.name] === null ? null : state[field.name];
    });

    if(state['ownership_interest'] == true) {
      state['display_sub_question'] = true;
    }else {
      state['display_sub_question'] = 'none';
    }

    if(state['co_borrower_ownership_interest'] == true) {
      state['co_borrower_display_sub_question'] = true;
    }else {
      state['co_borrower_display_sub_question'] = 'none';
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

    if(key == 'co_borrower_ownership_interest') {
      if(value == true) {
        this.setState({'co_borrower_display_sub_question': true});
      }else {
        this.setState({'co_borrower_display_sub_question': 'none'});
      }
    }

    this.setState(change);
  },

  buildStateFromLoan: function(loan) {
    var declaration = loan.borrower.declaration;

    var state = {};
    if (declaration) {
      state = this.buildStateFromDeclaration(declaration, borrowerFields, state);
    }
    if(loan.secondary_borrower){
      state = this.buildStateFromDeclaration(loan.secondary_borrower.declaration, coBorrowerFields, state);
    }
    return state;
  },

  buildStateFromDeclaration: function(declaration, fields, state){
    if(declaration){
      state[fields.ownershipInterest.name] = declaration.ownership_interest;
      state[fields.isHispanicOrLatino.name] = declaration.is_hispanic_or_latino;
      state[fields.citizenshipStatus.name] = declaration.citizen_status;
      state[fields.raceType.name] = declaration.race_type;
      state[fields.genderType.name] = declaration.gender_type;
      state[fields.typeOfProperty.name] = declaration.type_of_property;
      state[fields.titleOfProperty.name] = declaration.title_of_property;
    }

    return state;
  },

  buildLoanFromState: function() {
    var loan = {};

    // For borrower data
    loan.borrower_attributes = {id: this.props.loan.borrower.id};

    var declaration_attributes = {};

    if (this.state.ownership_interest == false) {
      this.state.type_of_property = null;
      this.state.title_of_property = null;
    }

    _.each(borrowerFields, function (field) {
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

    //For co-borrower data
    if(this.props.loan.secondary_borrower){
      loan.secondary_borrower_attributes = {id: this.props.loan.secondary_borrower.id};

      var co_borrower_declaration_attributes = {};

      if (this.state.co_borrower_ownership_interest == false) {
        this.state.co_borrower_type_of_property = null;
        this.state.co_borrower_title_of_property = null;
      }

      co_borrower_declaration_attributes[borrowerFields.ownershipInterest.name] = this.state[coBorrowerFields.ownershipInterest.name];
      co_borrower_declaration_attributes[borrowerFields.isHispanicOrLatino.name] = this.state[coBorrowerFields.isHispanicOrLatino.name];
      co_borrower_declaration_attributes[borrowerFields.citizenshipStatus.name] = this.state[coBorrowerFields.citizenshipStatus.name];
      co_borrower_declaration_attributes[borrowerFields.raceType.name] = this.state[coBorrowerFields.raceType.name];
      co_borrower_declaration_attributes[borrowerFields.genderType.name] = this.state[coBorrowerFields.genderType.name];
      co_borrower_declaration_attributes[borrowerFields.typeOfProperty.name] = this.state[coBorrowerFields.typeOfProperty.name];
      co_borrower_declaration_attributes[borrowerFields.titleOfProperty.name] = this.state[coBorrowerFields.titleOfProperty.name];

      co_borrower_declaration_attributes['outstanding_judgment'] = false;
      co_borrower_declaration_attributes['bankrupt'] = false;
      co_borrower_declaration_attributes['property_foreclosed'] = false;
      co_borrower_declaration_attributes['party_to_lawsuit'] = false;
      co_borrower_declaration_attributes['loan_foreclosure'] = false;
      co_borrower_declaration_attributes['present_delinquent_loan'] = false;
      co_borrower_declaration_attributes['child_support'] = false;
      co_borrower_declaration_attributes['down_payment_borrowed'] = false;
      co_borrower_declaration_attributes['co_maker_or_endorser'] = false;

      if (this.props.loan.secondary_borrower.declaration) {
        co_borrower_declaration_attributes.id = this.props.loan.secondary_borrower.declaration.id;
      }

      loan.secondary_borrower_attributes.declaration_attributes = co_borrower_declaration_attributes;
    }

    return loan;
  },

  render: function() {
    return (
      <div className='col-md-9 col-sm-12 account-content'>
        <form className='form-horizontal'>
          <div className='form-group'>
            <p className="box-description col-sm-12 text-xs-justify text-sm-justify">
              The government requires us to ask you these questions so they can monitor that we adhere to fair lending practices. We’ve made them as simple as possible.
            </p>
          </div>
          <div className='form-group'>
            <div className="col-md-6">
              <SelectField
                activateRequiredField={this.state[borrowerFields.citizenshipStatus.error]}
                label={borrowerFields.citizenshipStatus.label}
                keyName={borrowerFields.citizenshipStatus.name}
                value={this.state[borrowerFields.citizenshipStatus.name]}
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
                activateRequiredField={this.state[borrowerFields.isHispanicOrLatino.error]}
                label={borrowerFields.isHispanicOrLatino.label}
                keyName={borrowerFields.isHispanicOrLatino.name}
                value={this.state[borrowerFields.isHispanicOrLatino.name]}
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
                activateRequiredField={this.state[borrowerFields.raceType.error]}
                label={borrowerFields.raceType.label}
                keyName={borrowerFields.raceType.name}
                value={this.state[borrowerFields.raceType.name]}
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
                activateRequiredField={this.state[borrowerFields.genderType.error]}
                label={borrowerFields.genderType.label}
                keyName={borrowerFields.genderType.name}
                value={this.state[borrowerFields.genderType.name]}
                options={genderTypeOptions}
                editable={true}
                name={'gender_type'}
                allowBlank={true}
                onChange={this.onChange}
                editMode={this.props.editMode}/>
            </div>
          </div>
          <div className='form-group'>
            <div className="col-md-12">
              <BooleanRadio
                activateRequiredField={this.state[borrowerFields.ownershipInterest.error]}
                label={borrowerFields.ownershipInterest.label}
                isDeclaration={true}
                keyName={borrowerFields.ownershipInterest.name}
                customColumn={"col-xs-2"}
                editable={true}
                checked={this.state[borrowerFields.ownershipInterest.name]}
                onChange={this.onChange}
                editMode={this.props.editMode}/>
              </div>
          </div>

          <div className='form-group' style={{display: this.state.display_sub_question}}>
            <div className="col-md-6">
              <SelectField
                activateRequiredField={this.state[borrowerFields.typeOfProperty.error]}
                label={borrowerFields.typeOfProperty.label}
                keyName={borrowerFields.typeOfProperty.name}
                value={this.state[borrowerFields.typeOfProperty.name]}
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
                activateRequiredField={this.state[borrowerFields.titleOfProperty.error]}
                label={borrowerFields.titleOfProperty.label}
                keyName={borrowerFields.titleOfProperty.name}
                value={this.state[borrowerFields.titleOfProperty.name]}
                options={titlePropertyOptions}
                editable={true}
                allowBlank={true}
                name={'title_of_property'}
                onChange={this.onChange}
                editMode={this.props.editMode}/>
            </div>
          </div>
          {
            this.props.loan.secondary_borrower == null || this.props.loan.secondary_borrower == undefined
            ?
              null
            :
              <div className="box mtn">
                <hr/>
                <h3>Please provide information about your co-borrower</h3>
                <div className='form-group'>
                  <div className="col-md-6">
                    <SelectField
                      activateRequiredField={this.state[coBorrowerFields.citizenshipStatus.error]}
                      label={coBorrowerFields.citizenshipStatus.label}
                      keyName={coBorrowerFields.citizenshipStatus.name}
                      value={this.state[coBorrowerFields.citizenshipStatus.name]}
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
                      activateRequiredField={this.state[coBorrowerFields.isHispanicOrLatino.error]}
                      label={coBorrowerFields.isHispanicOrLatino.label}
                      keyName={coBorrowerFields.isHispanicOrLatino.name}
                      value={this.state[coBorrowerFields.isHispanicOrLatino.name]}
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
                      activateRequiredField={this.state[coBorrowerFields.raceType.error]}
                      label={coBorrowerFields.raceType.label}
                      keyName={coBorrowerFields.raceType.name}
                      value={this.state[coBorrowerFields.raceType.name]}
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
                      activateRequiredField={this.state[coBorrowerFields.genderType.error]}
                      label={coBorrowerFields.genderType.label}
                      keyName={coBorrowerFields.genderType.name}
                      value={this.state[coBorrowerFields.genderType.name]}
                      options={genderTypeOptions}
                      editable={true}
                      name={'gender_type'}
                      allowBlank={true}
                      onChange={this.onChange}
                      editMode={this.props.editMode}/>
                  </div>
                </div>
                <div className='form-group'>
                  <div className="col-md-12">
                    <BooleanRadio
                      activateRequiredField={this.state[coBorrowerFields.ownershipInterest.error]}
                      label={coBorrowerFields.ownershipInterest.label}
                      isDeclaration={true}
                      keyName={coBorrowerFields.ownershipInterest.name}
                      customColumn={"col-xs-2"}
                      editable={true}
                      checked={this.state[coBorrowerFields.ownershipInterest.name]}
                      onChange={this.onChange}
                      editMode={this.props.editMode}/>
                    </div>
                </div>
                <div className='form-group' style={{display: this.state.co_borrower_display_sub_question}}>
                  <div className="col-md-6">
                    <SelectField
                      activateRequiredField={this.state[coBorrowerFields.typeOfProperty.error]}
                      label={coBorrowerFields.typeOfProperty.label}
                      keyName={coBorrowerFields.typeOfProperty.name}
                      value={this.state[coBorrowerFields.typeOfProperty.name]}
                      options={propertyOptions}
                      editable={true}
                      name={'type_of_property'}
                      allowBlank={true}
                      onChange={this.onChange}
                      editMode={this.props.editMode}/>
                  </div>
                </div>
                <div className='form-group' style={{display: this.state.co_borrower_display_sub_question}}>
                  <div className="col-md-6">
                    <SelectField
                      activateRequiredField={this.state[coBorrowerFields.titleOfProperty.error]}
                      label={coBorrowerFields.titleOfProperty.label}
                      keyName={coBorrowerFields.titleOfProperty.name}
                      value={this.state[coBorrowerFields.titleOfProperty.name]}
                      options={titlePropertyOptions}
                      editable={true}
                      allowBlank={true}
                      name={'title_of_property'}
                      onChange={this.onChange}
                      editMode={this.props.editMode}/>
                  </div>
                </div>
              </div>
          }
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

    requiredFields[borrowerFields.ownershipInterest.error] = { value: this.state[borrowerFields.ownershipInterest.name], validationTypes: borrowerFields.ownershipInterest.validationTypes };
    requiredFields[borrowerFields.citizenshipStatus.error] = { value: this.state[borrowerFields.citizenshipStatus.name], validationTypes: borrowerFields.citizenshipStatus.validationTypes };
    requiredFields[borrowerFields.isHispanicOrLatino.error] = { value: this.state[borrowerFields.isHispanicOrLatino.name], validationTypes: borrowerFields.isHispanicOrLatino.validationTypes };
    requiredFields[borrowerFields.raceType.error] = { value: this.state[borrowerFields.raceType.name], validationTypes: borrowerFields.raceType.validationTypes };
    requiredFields[borrowerFields.genderType.error] = { value: this.state[borrowerFields.genderType.name], validationTypes: borrowerFields.genderType.validationTypes };

    if(this.state.display_sub_question == true) {
      requiredFields[borrowerFields.typeOfProperty.error] = { value: this.state[borrowerFields.typeOfProperty.name], validationTypes: borrowerFields.typeOfProperty.validationTypes };
      requiredFields[borrowerFields.titleOfProperty.error] = { value: this.state[borrowerFields.titleOfProperty.name], validationTypes:borrowerFields.titleOfProperty.validationTypes };
    }

    if(this.props.loan.secondary_borrower){
      requiredFields[coBorrowerFields.ownershipInterest.error] = { value: this.state[coBorrowerFields.ownershipInterest.name], validationTypes: coBorrowerFields.ownershipInterest.validationTypes };
      requiredFields[coBorrowerFields.citizenshipStatus.error] = { value: this.state[coBorrowerFields.citizenshipStatus.name], validationTypes: coBorrowerFields.citizenshipStatus.validationTypes };
      requiredFields[coBorrowerFields.isHispanicOrLatino.error] = { value: this.state[coBorrowerFields.isHispanicOrLatino.name], validationTypes: coBorrowerFields.isHispanicOrLatino.validationTypes };
      requiredFields[coBorrowerFields.raceType.error] = { value: this.state[coBorrowerFields.raceType.name], validationTypes: coBorrowerFields.raceType.validationTypes };
      requiredFields[coBorrowerFields.genderType.error] = { value: this.state[coBorrowerFields.genderType.name], validationTypes: coBorrowerFields.genderType.validationTypes };

      if(this.state.co_borrower_display_sub_question == true) {
        requiredFields[coBorrowerFields.typeOfProperty.error] = { value: this.state[coBorrowerFields.typeOfProperty.name], validationTypes: coBorrowerFields.typeOfProperty.validationTypes };
        requiredFields[coBorrowerFields.titleOfProperty.error] = { value: this.state[coBorrowerFields.titleOfProperty.name], validationTypes:coBorrowerFields.titleOfProperty.validationTypes };
      }
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