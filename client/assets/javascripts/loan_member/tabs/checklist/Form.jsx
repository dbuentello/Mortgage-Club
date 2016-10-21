var _ = require('lodash');
var React = require('react/addons');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var SelectPicker = require('components/admin/SelectPicker');
var TextField = require('components/form/TextField');
var FlashHandler = require('mixins/FlashHandler');
var documentDescription = {
  'appraisal_report': 'Appraised property value',
  'flood_zone_certification': 'Flood zone certification',
  'homeowners_insurance': "Homeowner's insurance",
  'inspection_report': 'Home inspection report',
  'lease_agreement': 'Lease agreement',
  'mortgage_statement': 'Latest mortgage statement of subject property',
  'purchase_agreement': 'Executed purchase agreement',
  'risk_report': "Home seller's disclosure report",
  'termite_report': 'Termite report',
  'title_report': 'Preliminary title report',
  'other_property_report': 'Other Property Report',
  'first_w2': 'W2 - Most recent tax year',
  'second_w2': 'W2 - Previous tax year',
  'first_paystub': 'Paystub - Most recent period',
  'second_paystub': 'Paystub - Previous period',
  'first_bank_statement': 'Bank statement - Most recent month',
  'second_bank_statement': 'Bank statement - Previous month',
  'first_business_tax_return': 'Business tax return - Most recent year',
  'second_business_tax_return': 'Business tax return - Previous year',
  'first_personal_tax_return': 'Personal tax return - Most recent year',
  'second_personal_tax_return': 'Personal tax return - Previous year',
  'other_borrower_report': 'Other Borrower Report',
  'hud_estimate': 'Estimated settlement statement',
  'hud_final': 'Final settlement statement',
  'loan_estimate': 'Loan estimate',
  'uniform_residential_lending_application': 'Loan application form',
  'other_loan_report': 'Other Loan Report',
  'closing_disclosure': 'Closing Disclosure',
  'deed_of_trust': 'Deed of Trust',
  'loan_doc': 'Closing - Loan Document',
  'other_closing_report': 'Other Closing Report'
 };

var Form = React.createClass({
  mixins: [FlashHandler],

  getDefaultProps: function() {
    return {
      checklistTypes: [
        {name: '', value: ''},
        {name: 'Upload', value: 'upload'},
        {name: 'Check Email', value: 'check_email'}
      ],
      checklistStatus: [
        {name: 'Pending', value: 'pending'},
        {name: 'Done', value: 'done'}
      ],
      subjects: [
        {name: 'Property', value: 'Property'},
        {name: 'Borrower', value: 'Borrower'},
        {name: 'Loan', value: 'Loan'},
        {name: 'Closing', value: 'Closing'},
      ]
    };
  },

  getInitialState: function() {
    if(this.props.checklist) {
      return {
        id: this.props.checklist.id,
        type: this.props.checklist.checklist_type,
        name: this.props.checklist.name,
        info: this.props.checklist.info,
        dueDate: this.props.checklist.due_date,
        subject_name: this.props.checklist.subject_name,
        documentType: this.props.checklist.document_type,
        description: this.props.checklist.document_description,
        documentTypes: this.loadDocumentTypes(this.props.checklist.subject_name),
        status: this.props.checklist.status
      };
    } else {
      return {
        id: null,
        status: 'pending',
        type: 'upload',
        subject_name: 'Property',
        description: 'Appraised property value',
        documentType: 'AppraisalReport',
        documentTypes: [
          {name: 'Appraised property value', value: 'appraisal_report'},
          {name: 'Flood zone certification', value: 'flood_zone_certification'},
          {name: "Homeowner's insurance", value: 'homeowners_insurance'},
          {name: 'Home inspection report', value: 'inspection_report'},
          {name: 'Lease agreement', value: 'lease_agreement'},
          {name: 'Latest mortgage statement of subject property', value: 'mortgage_statement'},
          {name: 'Executed purchase agreement', value: 'purchase_agreement'},
          {name: "Home seller's disclosure report", value: 'risk_report'},
          {name: 'Termite report', value: 'termite_report'},
          {name: 'Preliminary title report', value: 'title_report'},
          {name: 'Other Property Report', value: 'other_property_report'}
        ]
      };
    }
  },

  onChange: function(change) {
    this.setState(change);
    var key = Object.keys(change)[0];
    var value = change[key];
    switch(key) {
      case "subjectName":
        var documentTypes = this.loadDocumentTypes(value);
        this.setState({documentTypes});
        if(documentTypes.length > 0){
          this.setState({description: documentTypes[0].name})
        }
        break;
      case "documentType":
        this.setState({description: documentDescription[value]});
        break;
    }
  },

  loadDocumentTypes: function(document) {
    switch(document) {
      case "Property":
        var documentTypes = [
          {name: 'Appraised property value', value: 'appraisal_report'},
          {name: 'Flood zone certification', value: 'flood_zone_certification'},
          {name: "Homeowner's insurance", value: 'homeowners_insurance'},
          {name: 'Home inspection report', value: 'inspection_report'},
          {name: 'Lease agreement', value: 'lease_agreement'},
          {name: 'Latest mortgage statement of subject property', value: 'mortgage_statement'},
          {name: 'Executed purchase agreement', value: 'purchase_agreement'},
          {name: "Home seller's disclosure report", value: 'risk_report'},
          {name: 'Termite report', value: 'termite_report'},
          {name: 'Preliminary title report', value: 'title_report'},
          {name: 'Other Property Report', value: 'other_property_report'}
        ]
        break;
      case "Borrower":
        var documentTypes = [
          {name: 'Business tax return - Most recent year', value: 'first_business_tax_return'},
          {name: 'Business tax return - Previous year', value: 'second_business_tax_return'},
          {name: 'Personal tax return - Most recent year', value: 'first_personal_tax_return'},
          {name: 'Personal tax return - Previous year', value: 'second_personal_tax_return'},
          {name: 'W2 - Most recent tax year', value: 'first_w2'},
          {name: 'W2 - Previous tax year', value: 'second_w2'},
          {name: 'Paystub - Most recent period', value: 'first_paystub'},
          {name: 'Paystub - Previous period', value: 'second_paystub'},
          {name: 'Bank statement - Most recent month', value: 'first_bank_statement'},
          {name: 'Bank statement - Previous month', value: 'second_bank_statement'},
          {name: 'Other Borrower Report', value: 'other_borrower_report'},
        ]
        break;
      case "Loan":
        var documentTypes = [
          {name: 'Estimated settlement statement', value: 'hud_estimate'},
          {name: 'Final settlement statement', value: 'hud_final'},
          {name: 'Loan estimate', value: 'loan_estimate'},
          {name: 'Loan application form', value: 'uniform_residential_lending_application'},
          {name: 'Other Loan Report', value: 'other_loan_report'},
        ]
        break;
      case "Closing":
        var documentTypes = [
          {name: 'Closing Disclosure', value: 'closing_disclosure'},
          {name: 'Deed of Trust', value: 'deed_of_trust'},
          {name: 'Closing - Loan Document', value: 'loan_doc'},
          {name: 'Other Closing Report', value: 'other_closing_report'},
        ]
        break;
      default:
        var documentTypes = []
    }
    return documentTypes;
  },

  onClick: function(event) {
    event.preventDefault();
    this.setState({saving: true});
    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      data: $('.form-checklist').serialize(),
      success: function(response) {
        this.setState(
          {
            type: response.checklist.checklist_type,
            name: response.checklist.name,
            info: response.checklist.info,
            dueDate: response.checklist.due_date,
            documentType: response.checklist.document_type,
            status: response.checklist.status,
            saving: false
          }
        );
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        if(response.checklists){
          this.props.onReloadTable(response.checklists);
        }
        this.setState({saving: false});
      }.bind(this),
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.message };
        this.showFlashes(flash);
        this.setState({saving: false});
      }.bind(this)
    });
  },

  render: function() {
    return (
      <form className='form-horizontal form-checklist'>
        <input type='hidden' value={this.props.loan.id} name='loan_id'/>
        <div className='form-group'>
          <div className='col-sm-4'>
            <SelectField
              label='Type'
              keyName='type'
              name='checklist[checklist_type]'
              value={this.state.type}
              options={this.props.checklistTypes}
              onChange={this.onChange}
              editable={true}
              id="checklistTypes"/>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-sm-4'>
            <DateField
              label='Due Date'
              keyName='dueDate'
              name='checklist[due_date]'
              value={this.state.dueDate}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Name'
              keyName='name'
              name='checklist[name]'
              value={this.state.name}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-sm-6'>
            <TextField
              label='Info'
              keyName='info'
              name='checklist[info]'
              value={this.state.info}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>
        {
          this.state.type == "upload" ?
            <div className='form-group'>
              <div className='col-sm-4'>
                <SelectField
                  label='Subject'
                  keyName='subjectName'
                  name='checklist[subject_name]'
                  value={this.state.subjectName}
                  options={this.props.subjects}
                  onChange={this.onChange}
                  editable={true}/>
              </div>
              <div className='col-sm-4'>
                <SelectField
                  label='Document Type'
                  keyName='documentType'
                  name='checklist[document_type]'
                  value={this.state.documentType}
                  options={this.state.documentTypes}
                  onChange={this.onChange}
                  editable={true}/>
              </div>
              <div className='col-sm-4'>
                <TextField
                  label='Document Description'
                  keyName='description'
                  name='checklist[document_description]'
                  value={this.state.description}
                  onChange={this.onChange}
                  editable={true}/>
              </div>
            </div>
            : null
        }
        {
          this.state.id != null && this.state.type == "check_email"
          ?
            <div className='form-group'>
              <div className='col-sm-4'>
                <SelectField
                  label='Status'
                  keyName='status'
                  name='checklist[status]'
                  value={this.state.status}
                  options={this.props.checklistStatus}
                  onChange={this.onChange}
                  editable={true}
                  id="checklistStatus"/>
              </div>
            </div>
          :
            null
        }
        <div className='form-group'>
          <div className='col-sm-2'>
            <button className='btn btn-primary' id='submit-checklist' onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
          </div>
        </div>
      </form>
    );
  }
});
module.exports = Form;
