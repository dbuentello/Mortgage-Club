var _ = require('lodash');
var React = require('react/addons');

var AddressField = require('components/form/AddressField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var BooleanRadio = require('components/form/BooleanRadio');

var Router = require('react-router');
var { Route, RouteHandler, Link } = Router;

var checkboxFields = {
  outstandingJudgment: {
    label: 'Are there any outstanding judgments against you?',
    name: 'outstanding_judgment'
  },
  bankrupt: {
    label: 'Have you been declared bankrupt in the past 7 years?',
    name: 'bankrupt'
  },
  propertyForeclosed: {
    label: 'Have you had property foreclosed upon or given title or deed in lieu thereof in the last 7 years?',
    name: 'property_foreclosed'
  },
  partyToLawsuit: {
    label: 'Are you a party to a lawsuit?',
    name: 'party_to_lawsuit'
  },
  loanForeclosure: {
    label: 'Have you been obligated on any loan resulted in foreclosure, transfer of title in lieu of foreclosure, or judgment?',
    name: 'loan_foreclosure'
  },
  presentDeliquentLoan: {
    label: 'Are you presently delinquent or in default on any Federal debt or any other loan, mortgage, financial, obligation, bond or loan guarantee?',
    name: 'present_deliquent_loan'
  },
  childSupport: {
    label: 'Are you obligated to pay alimony, child support, or separate maintenance?',
    name: 'child_support'
  },
  downPaymentBorrowed: {
    label: 'Is any part of the down payment borrowed?',
    name: 'down_payment_borrowed'
  },
  coMakerOrEndorser: {
    label: 'Are you a co-maker or endorser on a note?',
    name: 'co_maker_or_endorser'
  },
  usCitizen: {
    label: 'Are you a U.S citizen?',
    name: 'us_citizen'
  },
  permanentResidentAlien: {
    label: 'Are you a permanent resident alien?',
    name: 'permanent_resident_alien'
  },
  ownershipInterest: {
    label: 'Have you had an ownership interest in a property in the last three years?',
    name: 'ownership_interest'
  }
};

var selectBoxFields = {
  typeOfProperty: {label: '(1) What type of property did you own?', name: 'type_of_property'},
  titleOfProperty: {label: '(2) How did you hold title to this property?', name: 'title_of_property'}
}

var propertyOptions = [
  {name: 'Primary Residence', value: 'primary_residence'},
  {name: 'Secondary Resident', value: 'secondary_residence'},
  {name: 'Investment Property', value: 'investment_property'}
];

var titlePropertyOptions = [
  {name: 'Self', value: 'self'},
  {name: 'With spouse', value: 'with_spouse'},
  {name: 'Other', value: 'other'}
]

var FormDeclarations = React.createClass({
  getInitialState: function() {
    var currentUser = this.props.bootstrapData.currentUser;
    var state = this.buildStateFromLoan(this.props.loan);

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
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mtn'>
              {
                _.map(Object.keys(checkboxFields), function(key) {
                  return (
                    <div key={key} style={{display: this.state[checkboxFields[key].name + '_display']}}>
                      <BooleanRadio
                        label={checkboxFields[key].label}
                        keyName={checkboxFields[key].name}
                        editable={true}
                        checked={this.state[checkboxFields[key].name]}
                        onChange={this.onChange}/>
                    </div>
                  )
                },this)
              }
              <div className='selectBox col-xs-6' style={{display: this.state.display_sub_question}}>
                <SelectField
                  label={selectBoxFields.typeOfProperty.label}
                  keyName={selectBoxFields.typeOfProperty.name}
                  value={this.state[selectBoxFields.typeOfProperty.name]}
                  options={propertyOptions}
                  editable={true}
                  name={'type_of_property'}
                  onChange={this.onChange}/>
                <SelectField
                  label={selectBoxFields.titleOfProperty.label}
                  keyName={selectBoxFields.titleOfProperty.name}
                  value={this.state[selectBoxFields.titleOfProperty.name]}
                  options={titlePropertyOptions}
                  editable={true}
                  name={'title_of_property'}
                  onChange={this.onChange}/>
              </div>
            </div>
            <div className='box text-right'>
              <a className='btn btnSml btnPrimary' onClick={this.save} disabled={this.state.saving}>
                { this.state.saving ? 'Saving' : 'Save and Continue' }<i className='icon iconRight mls'/>
              </a>
            </div>
          </div>
        </div>
        <div className='helpSection sticky pull-right overlayRight overlayTop'>
        </div>
      </div>
    );
  },

  save: function() {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 5, true, true);
  }

});

module.exports = FormDeclarations;
