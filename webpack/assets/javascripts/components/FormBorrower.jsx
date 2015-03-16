var _ = require('lodash');
var React = require('react/addons');
var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');

var FormBorrower = React.createClass({
  getInitialState: function() {
    var currentUser = this.props.bootstrapData.currentUser;

    return {
      borrower_count: 1,
      firstName: currentUser.firstName,
      lastName: currentUser.lastName,
      middleName: currentUser.middleName,
      suffix: currentUser.suffix
    };
  },

  onChange: function(change) {
    this.setState(change);
  },

  render: function() {
    var borrowerCountOptions = [
      {name: 'As an individual', value: 1},
      {name: 'With a co-borrower', value: 2}
    ];

    var marital_statuses = [
      {name: 'Married (includes registered domestic partners)', value: 'married'},
      {name: 'Unmarried (includes single, divorced, widowed)', value: 'unmarried'},
      {name: 'Separated', value: 'separated'}
    ];

    return (
      <div>
        <div className='box mtn'>
          <SelectField label='I am applying' keyName='borrowerCount' value={this.state.borrowerCount} options={borrowerCountOptions} editable={true} onChange={this.onChange}/>
          <div className='row'>
            <div className='col-xs-6'>
              <TextField label='First Name' keyName='firstName' value={this.state.firstName} editable={true} onChange={this.onChange}/>
            </div>
            <div className='col-xs-6'>
              <TextField label='Middle Name' keyName='middleName' value={this.state.middleName} editable={true} onChange={this.onChange}/>
            </div>
          </div>
          <div className='row'>
            <div className='col-xs-6'>
              <TextField label='Last Name' keyName='lastName' value={this.state.lastName} editable={true} onChange={this.onChange}/>
            </div>
            <div className='col-xs-6'>
              <TextField label='Suffix' keyName='suffix' value={this.state.suffix} editable={true} onChange={this.onChange}/>
            </div>
          </div>

          <DateField label='Date of birth' keyName='dob' value={this.state.dob} editable={true} onChange={this.onChange}/>
          <TextField label='Social Security Number' keyName='ssn' value={this.state.ssn} editable={true}/>
          <TextField label='Phone Number' keyName='phone' value={this.state.phone} editable={true}/>
          <TextField label='Years in school' keyName='years_in_school' value={this.state.years_in_school} editable={true}/>
          <SelectField label='Marital Status' keyName='marital_status' value={this.state.marital_status} options={marital_statuses} editable={true}/>

        </div>

        <div className='box text-right'>
          <a className='btn btnSml btnPrimary'>Next</a>
        </div>
      </div>
    );
  }
});

module.exports = FormBorrower;
