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
    name: 'outstanding_judgment',
    fieldName: 'outstanding_judgment'
  },
  bankrupt: {
    label: 'Have you been declared bankrupt in the past 7 years?',
    name: 'bankrupt',
    fieldName: 'bankrupt'
  },
  propertyForeclosed: {
    label: 'Have you had property foreclosed upon or given title or deed in lieu thereof in the last 7 years?',
    name: 'property_foreclosed',
    fieldName: 'property_foreclosed'
  },
  partyToLawsuit: {
    label: 'Are you a party to a lawsuit?',
    name: 'party_to_lawsuit',
    fieldName: 'party_to_lawsuit'
  },
  loanForeclosure: {
    label: 'Have you been obligated on any loan resulted in foreclosure, transfer of title in lieu of foreclosure, or judgment?',
    name: 'loan_foreclosure',
    fieldName: 'loan_foreclosure'
  },
  presentDeliquentLoan: {
    label: 'Are you presently delinquent or in default on any Federal debt or any other loan, mortgage, financial, obligation, bond or loan guarantee?',
    name: 'present_deliquent_loan',
    fieldName: 'present_deliquent_loan'
  },
  childSupport: {
    label: 'Are you obligated to pay alimony, child support, or separate maintenance?',
    name: 'child_support',
    fieldName: 'child_support'
  },
  downPaymentBorrowed: {
    label: 'Is any part of the down payment borrowed?',
    name: 'down_payment_borrowed',
    fieldName: 'down_payment_borrowed'
  },
  coMakerOrEndorser: {
    label: 'Are you a co-maker or endorser on a note?',
    name: 'co_maker_or_endorser',
    fieldName: 'co_maker_or_endorser'
  },
  usCitizen: {
    label: 'Are you a U.S citizen?',
    name: 'us_citizen',
    fieldName: 'us_citizen'
  },
  permanentResidentAlien: {
    label: 'Are you a permanent resident alien?',
    name: 'permanent_resident_alien',
    fieldName: 'permanent_resident_alien'
  },
  ownershipInterest: {
    label: 'Have you had an ownership interest in a property in the last three years?',
    name: 'ownership_interest',
    fieldName: 'ownership_interest'
  }
};

var select_box_fields = {
  typeOfProperty: {label: '(1) What type of property did you own?', name: 'type_of_property', fieldName: 'type_of_property'},
  titleOfProperty: {label: '(2) How did you hold title to this property?', name: 'title_of_property', fieldName: 'title_of_property'}
}

var propertyOptions = [
  {name: 'Primary Residence', value: 1},
  {name: 'Secondary Resident', value: 2},
  {name: 'Investment Property', value: 2}
];

var titlePropertyOptions = [
  {name: 'Self', value: 'self'},
  {name: 'With spouse', value: 'with_spouse'},
  {name: 'Other', value: 'other'}
]

var FormDeclarations = React.createClass({
  getInitialState: function() {
    var currentUser = this.props.bootstrapData.currentUser;
    var state = {};

    _.each(checkboxFields, function (field) {
      state[field.name] = null;
      state[field.name + '_display'] = true;
    });
    state['display_sub_question'] = 'none';

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
              <div className='selectBox' style={{display: this.state.display_sub_question}}>
                <SelectField
                  label={select_box_fields.typeOfProperty.label}
                  keyName={select_box_fields.typeOfProperty.name}
                  value={this.state[select_box_fields.typeOfProperty.name]}
                  options={propertyOptions}
                  editable={true}
                  onChange={this.onChange}/>
                <SelectField
                  label={select_box_fields.titleOfProperty.label}
                  keyName={select_box_fields.titleOfProperty.name}
                  value={this.state[select_box_fields.titleOfProperty.name]}
                  options={titlePropertyOptions}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
            </div>
            <div className='box text-right'>
              <Link to='rates' className='btn btnSml btnPrimary'>Next</Link>
            </div>
          </div>
        </div>
        <div className='helpSection sticky pull-right overlayRight overlayTop'>
        </div>
      </div>
    );
  }
});

module.exports = FormDeclarations;
