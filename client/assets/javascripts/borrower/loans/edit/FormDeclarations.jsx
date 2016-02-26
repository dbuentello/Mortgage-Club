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
  outstandingJudgment: {
    label: 'Are there any outstanding judgments against you?',
    name: 'outstanding_judgment',
    error: "outstandingJudgmentError",
    validationTypes: ["empty"]
  },
  bankrupt: {
    label: 'Have you been declared bankrupt in the past 7 years?',
    name: 'bankrupt',
    error: "bankruptError",
    validationTypes: ["empty"]
  },
  propertyForeclosed: {
    label: 'Have you had property foreclosed upon or given title or deed in lieu thereof in the last 7 years?',
    name: 'property_foreclosed',
    error: "propertyForeclosedError",
    validationTypes: ["empty"]
  },
  partyToLawsuit: {
    label: 'Are you a party to a lawsuit?',
    name: 'party_to_lawsuit',
    error: "partyToLawsuitError",
    validationTypes: ["empty"]
  },
  loanForeclosure: {
    label: 'Have you been obligated on any loan resulted in foreclosure, transfer of title in lieu of foreclosure, or judgment?',
    name: 'loan_foreclosure',
    error: "loanForeclosureError",
    validationTypes: ["empty"]
  },
  presentDeliquentLoan: {
    label: 'Are you presently delinquent or in default on any Federal debt or any other loan, mortgage, financial, obligation, bond or loan guarantee?',
    name: 'present_delinquent_loan',
    error: "presentDeliquentLoanError",
    validationTypes: ["empty"]
  },
  childSupport: {
    label: 'Are you obligated to pay alimony, child support, or separate maintenance?',
    name: 'child_support',
    error: "childSupportError",
    validationTypes: ["empty"]
  },
  downPaymentBorrowed: {
    label: 'Is any part of the down payment borrowed?',
    name: 'down_payment_borrowed',
    error: "downPaymentBorrowedError",
    validationTypes: ["empty"]
  },
  coMakerOrEndorser: {
    label: 'Are you a co-maker or endorser on a note?',
    name: 'co_maker_or_endorser',
    error: "coMakerOrEndorserError",
    validationTypes: ["empty"]
  },
  usCitizen: {
    label: 'Are you a U.S citizen?',
    name: 'us_citizen',
    error: "usCitizenError",
    validationTypes: ["empty"]
  },
  permanentResidentAlien: {
    label: 'Are you a permanent resident alien?',
    name: 'permanent_resident_alien',
    error: "permanentResidentAlienError",
    validationTypes: ["empty"]
  },
  ownershipInterest: {
    label: 'Have you had an ownership interest in a property in the last three years?',
    name: 'ownership_interest',
    error: "ownershipInterestError",
    validationTypes: ["empty"]
  }
};

var selectBoxFields = {
  typeOfProperty: {label: '(1) What type of property did you own?', name: 'type_of_property', error: "typeOfPropertyError", validationTypes: ["empty"]},
  titleOfProperty: {label: '(2) How did you hold title to this property?', name: 'title_of_property', error: "titleOfPropertyError", validationTypes: ["empty"]}
}

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

    if(state[checkboxFields.usCitizen.name] == true) {
      state[checkboxFields.permanentResidentAlien.name + "_display"] = "none";
    }

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
    if(key == 'us_citizen') {
      if(value == true) {
        this.setState({'permanent_resident_alien_display': 'none'});
      }else {
        this.setState({'permanent_resident_alien_display': true});
      }
    }

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
        if(key == "permanentResidentAlien"){
          if(state[checkboxFields.usCitizen.name] == false)
          {
            state[checkboxFields[key].name] = declaration[checkboxFields[key].name];
          }
        }else{
          state[checkboxFields[key].name] = declaration[checkboxFields[key].name];
        }
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

    if (this.state.us_citizen == true) {
      this.state.permanent_resident_alien = null;
    }

    _.each(selectBoxFields, function (field) {
      declaration_attributes[field.name] = this.state[field.name];
    }, this);

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
                placeholder="Select your type of property"
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
                placeholder="Select your title of property"
                name={'title_of_property'}
                onChange={this.onChange}
                editMode={this.props.editMode}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-md-12">
              <button className="btn theBtn text-uppercase" id="continueBtn" onClick={this.save}>{ this.state.saving ? 'Saving' : 'Save and Continue' }<img src="/icons/arrowRight.png" alt="arrow"/></button>
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
    var commonCheckingFields = this.omitKeys(checkboxFields, ["permanentResidentAlien"]);

    _.each(commonCheckingFields, function(field) {
      requiredFields[field.error] = {value: this.state[field.name], validationTypes: field.validationTypes};
    }, this);

    if(this.state.permanent_resident_alien_display == true) {
      requiredFields[checkboxFields.permanentResidentAlien.error] = {value: this.state[checkboxFields.permanentResidentAlien.name], validationTypes: checkboxFields.permanentResidentAlien.validationTypes};
    }

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
