var _ = require('lodash');
var React = require('react/addons');
var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var BooleanRadio = require('components/form/BooleanRadio');

var FormBorrower = React.createClass({
  getInitialState: function() {
    var currentUser = this.props.bootstrapData.currentUser;

    return {
      borrower_count: 1,
      firstName: currentUser.firstName,
      lastName: currentUser.lastName,
      middleName: currentUser.middleName,
      suffix: currentUser.suffix,
      yearsInSchool: null,
      maritalStatus: null,
      hasDependents: null
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
              <TextField label='Social Security Number' keyName='ssn' value={this.state.ssn} editable={true} onChange={this.onChange}/>
              <TextField label='Phone Number' keyName='phone' value={this.state.phone} editable={true} onChange={this.onChange}/>
              <TextField label='Years in school' keyName='yearsInSchool' value={this.state.yearsInSchool} editable={true} onChange={this.onChange}/>
              <SelectField label='Marital Status' keyName='maritalStatus' value={this.state.maritalStatus} options={maritalStatuses} editable={true} onChange={this.onChange}/>
              <TextField label='Number of dependents' keyName='numberOfDependents' value={this.state.numberOfDependents} editable={true} onChange={this.onChange}/>
              {this.state.numberOfDependents > 0 ?
                <TextField label='Please enter the age(s) of your dependents, separated by comma' keyName='dependentAges' onChange={this.onChange}/>
              : null}
              <AddressField label='Address of the current property you live in' address={this.state.currentAddress} keyName='currentAddress' editable={true} onChange={this.onChange} placeholder='Please enter your current address'/>
              <BooleanRadio label='Do you own this property?' checked={this.state.currentlyOwn} keyName='currentlyOwn' editable={true} onChange={this.onChange}/>
              <TextField label='Number of years you have lived in this address' value={this.state.yearsInCurrentAddress} keyName='yearsInCurrentAddress' editable={true} onChange={this.onChange}/>
              {parseInt(this.state.yearsInCurrentAddress, 10) < 2 ?
                <div>
                  <AddressField label='Your previous address' address={this.state.previousAddress} keyName='previousAddress' editable={true} onChange={this.onChange} placeholder='Please enter your current address'/>
                  <BooleanRadio label='Do you own this property?' checked={this.state.previouslyOwn} keyName='previouslyOwn' editable={true} onChange={this.onChange} placeholder='Please enter your previous address'/>
                  <TextField label='Number of years you have lived in this address' value={this.state.yearsInPreviousAddress} keyName='yearsInPreviousAddress' editable={true} onChange={this.onChange}/>
                </div>
              : null}
            </div>

            <div className='box text-right'>
              <a className='btn btnSml btnPrimary'>Next</a>
            </div>
          </div>
        </div>
        <div className='helpSection sticky pull-right overlayRight overlayTop'>
        </div>
      </div>
    );
  }
});

module.exports = FormBorrower;
