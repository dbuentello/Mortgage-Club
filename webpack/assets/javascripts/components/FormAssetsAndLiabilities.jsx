var _ = require('lodash');
var React = require('react/addons');
var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');

var fields = {
  employerName: {label: 'Name of current employer', name: 'employer_name', helpText: 'I am a helpful text.'},
  employerAddress: {label: 'Address of current employer', name: 'employer_address', helpText: null},
  jobTitle: {label: 'Job Title', name: 'job_title', helpText: null},
  yearsAtEmployer: {label: 'Years at this employer', name: 'years_at_employer', helpText: null},
  monthsAtEmployer: {label: 'Months at this employer', name: 'months_at_employer', helpText: null},
  employerContactName: {label: 'Contact Name', name: 'employer_contact_name', helpText: null},
  employerContactNumber: {label: 'Contact Phone Number', name: 'employer_contact_number', helpText: null},
  grossIncome: {label: 'Gross Income', name: 'gross_income', helpText: null},
  grossOvertime: {label: 'Gross Overtime', name: 'gross_overtime', helpText: null},
  grossBonus: {label: 'Gross Bonus', name: 'gross_bonus', helpText: null},
  grossCommission: {label: 'Gross Commission', name: 'gross_commission', helpText: null}
};

var FormAssetsAndLiabilities = React.createClass({
  getInitialState: function() {
    var currentUser = this.props.bootstrapData.currentUser;
    var state = {};

    _.each(fields, function (field) {
      state[field.name] = null;
    });

    return state;
  },

  onChange: function(change) {
    this.setState(change);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  render: function() {
    var borrowerCountOptions = [
      {name: 'As an individual', value: 1},
      {name: 'With a co-borrower', value: 2}
    ];

    var maritalStatuses = [
      {name: 'Married (includes registered domestic partners)', value: 'married'},
      {name: 'Unmarried (includes single, divorced, widowed)', value: 'unmarried'},
      {name: 'Separated', value: 'separated'}
    ];

    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mtn'>
              <TextField
                label={fields.employerName.label}
                keyName={fields.employerName.name}
                value={this.state[fields.employerName.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.employerName)}
                onChange={this.onChange}/>

              <AddressField
                label={fields.employerAddress.label}
                address={this.state[fields.employerAddress.name]}
                keyName={fields.employerAddress.name}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.employerAddress)}
                onChange={this.onChange}
                placeholder='Please enter the address of the employer'/>

              <TextField
                label={fields.jobTitle.label}
                keyName={fields.jobTitle.name}
                value={this.state[fields.jobTitle.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.jobTitle)}
                onChange={this.onChange}/>

              <div className='row'>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.yearsAtEmployer.label}
                    keyName={fields.yearsAtEmployer.name}
                    value={this.state[fields.yearsAtEmployer.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.yearsAtEmployer)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.monthsAtEmployer.label}
                    keyName={fields.monthsAtEmployer.name}
                    value={this.state[fields.monthsAtEmployer.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.monthsAtEmployer)}
                    onChange={this.onChange}/>
                </div>
              </div>
              <div className='h5 typeDeemphasize'>Best contact to confirm employment:</div>
              <div className='row'>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.employerContactName.label}
                    keyName={fields.employerContactName.name}
                    value={this.state[fields.employerContactName.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.employerContactName)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.employerContactNumber.label}
                    keyName={fields.employerContactNumber.name}
                    value={this.state[fields.employerContactNumber.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.employerContactNumber)}
                    onChange={this.onChange}/>
                </div>
              </div>
              <div className='row'>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.grossIncome.label}
                    keyName={fields.grossIncome.name}
                    value={this.state[fields.grossIncome.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.grossIncome)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.grossOvertime.label}
                    keyName={fields.grossOvertime.name}
                    value={this.state[fields.grossOvertime.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.grossOvertime)}
                    onChange={this.onChange}/>
                </div>
              </div>
              <div className='row'>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.grossBonus.label}
                    keyName={fields.grossBonus.name}
                    value={this.state[fields.grossBonus.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.grossBonus)}
                    onChange={this.onChange}/>
                </div>
                <div className='col-xs-6'>
                  <TextField
                    label={fields.grossCommission.label}
                    keyName={fields.grossCommission.name}
                    value={this.state[fields.grossCommission.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.grossCommission)}
                    onChange={this.onChange}/>
                </div>
              </div>
            </div>

            <div className='box text-right'>
              <a className='btn btnSml btnPrimary'>Next</a>
            </div>
          </div>
        </div>

        <div className='helpSection sticky pull-right overlayRight overlayTop pal bls'>
          {this.state.focusedField && this.state.focusedField.helpText
          ? <div>
              <span className='typeEmphasize'>{this.state.focusedField.label}:</span>
              <br/>{this.state.focusedField.helpText}
            </div>
          : null}
        </div>
      </div>
    );
  }
});

module.exports = FormAssetsAndLiabilities;
