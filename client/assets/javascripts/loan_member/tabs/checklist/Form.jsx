var _ = require('lodash');
var React = require('react/addons');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var FlashHandler = require('mixins/FlashHandler');
var documentDescription = {
  'AppraisalReport': 'Appraised property value',
  'FloodZoneCertification': 'Flood zone certification',
  'HomeownersInsurance': "Homeowner's insurance",
  'InspectionReport': 'Home inspection report',
  'LeaseAgreement': 'Lease agreement',
  'MortgageStatement': 'Latest mortgage statement of subject property',
  'PurchaseAgreement': 'Executed purchase agreement',
  'RiskReport': "Home seller's disclosure report",
  'TermiteReport': 'Termite report',
  'TitleReport': 'Preliminary title report',
  'OtherPropertyReport': 'Other Property Report',
  'FirstW2': 'W2 - Most recent tax year',
  'SecondW2': 'W2 - Previous tax year',
  'FirstPaystub': 'Paystub - Most recent month',
  'SecondPaystub': 'Paystub - Previous month',
  'FirstBankStatement': 'Bank statement - Most recent month',
  'SecondBankStatement': 'Bank statement - Previous month',
  'FirstBusinessTaxReturn': 'Business tax return - Most recent year',
  'SecondBusinessTaxReturn': 'Business tax return - Previous year',
  'FirstPersonalTaxReturn': 'Personal tax return - Most recent year',
  'SecondPersonalTaxReturn': 'Personal tax return - Previous year',
  'FirstFederalTaxReturn': 'Federal tax return - Most recent year',
  'SecondFederalTaxReturn': 'Federal tax return - Previous year',
  'OtherBorrowerReport': 'Other Borrower Report',
  'HudEstimate': 'Estimated settlement statement',
  'HudFinal': 'Final settlement statement',
  'LoanEstimate': 'Loan estimate',
  'UniformResidentialLendingApplication': 'Loan application form',
  'OtherLoanReport': 'Other Loan Report',
  'ClosingDisclosure': 'Closing Disclosure',
  'DeedOfTrust': 'Deed of Trust',
  'LoanDoc': 'Closing - Loan Document',
  'OtherClosingReport': 'Other Closing Report'
 };

var Form = React.createClass({
  mixins: [FlashHandler],

  getDefaultProps: function() {
    return {
      checklistTypes: [
        {name: '', value: ''},
        {name: 'Explain', value: 'explain'},
        {name: 'Upload', value: 'upload'}
      ],
      documents: [
        {name: 'Property', value: 'property'},
        {name: 'Borrower', value: 'borrower'},
        {name: 'Loan', value: 'loan'},
        {name: 'Closing', value: 'closing'},
      ]
    };
  },

  getInitialState: function() {
    if(this.props.checklist) {
      return {
        type: this.props.checklist.checklist_type,
        name: this.props.checklist.name,
        info: this.props.checklist.info,
        dueDate: this.props.checklist.due_date,
        question: this.props.checklist.question,
        document: this.props.checklist.document,
        documentType: this.props.checklist.document_type,
        documentTemplate: this.props.checklist.template_id,
        description: this.props.checklist.document_description,
        documentTypes: this.loadDocumentTypes(this.props.checklist.document)
      };
    }else {
      return {
        type: 'explain',
        document: 'property',
        description: 'Appraised property value',
        documentType: 'AppraisalReport',
        documentTypes: [
          {name: 'Appraised property value', value: 'AppraisalReport'},
          {name: 'Flood zone certification', value: 'FloodZoneCertification'},
          {name: "Homeowner's insurance", value: 'HomeownersInsurance'},
          {name: 'Home inspection report', value: 'InspectionReport'},
          {name: 'Lease agreement', value: 'LeaseAgreement'},
          {name: 'Latest mortgage statement of subject property', value: 'MortgageStatement'},
          {name: 'Executed purchase agreement', value: 'PurchaseAgreement'},
          {name: "Home seller's disclosure report", value: 'RiskReport'},
          {name: 'Termite report', value: 'TermiteReport'},
          {name: 'Preliminary title report', value: 'TitleReport'},
          {name: 'Other Property Report', value: 'OtherPropertyReport'}
        ]
      };
    }
  },

  onChange: function(change) {
    this.setState(change);
    var key = Object.keys(change)[0];
    var value = change[key];
    switch(key) {
      case "document":
        var documentTypes = this.loadDocumentTypes(value);
        this.setState({documentTypes});
        if(documentTypes.length > 0){
          this.setState({description: documentTypes[0].name})
        }
        break;
      case "documentType":
        this.setState({description: documentDescription[value]});
        break;
      case "type":
        this.setState({
          question: null,
          documentTemplate: null
        })
        break;
    }
  },

  loadDocumentTypes: function(document) {
    switch(document) {
      case "property":
        var documentTypes = [
          {name: 'Appraised property value', value: 'AppraisalReport'},
          {name: 'Flood zone certification', value: 'FloodZoneCertification'},
          {name: "Homeowner's insurance", value: 'HomeownersInsurance'},
          {name: 'Home inspection report', value: 'InspectionReport'},
          {name: 'Lease agreement', value: 'LeaseAgreement'},
          {name: 'Latest mortgage statement of subject property', value: 'MortgageStatement'},
          {name: 'Executed purchase agreement', value: 'PurchaseAgreement'},
          {name: "Home seller's disclosure report", value: 'RiskReport'},
          {name: 'Termite report', value: 'TermiteReport'},
          {name: 'Preliminary title report', value: 'TitleReport'},
          {name: 'Other Property Report', value: 'OtherPropertyReport'}
        ]
        break;
      case "borrower":
        var documentTypes = [
          {name: 'Business tax return - Most recent year', value: 'FirstBusinessTaxReturn'},
          {name: 'Business tax return - Previous year', value: 'SecondBusinessTaxReturn'},
          {name: 'Personal tax return - Most recent year', value: 'FirstPersonalTaxReturn'},
          {name: 'Personal tax return - Previous year', value: 'SecondPersonalTaxReturn'},
          {name: 'Federal tax return - Most recent year', value: 'FirstFederalTaxReturn'},
          {name: 'Federal tax return - Previous year', value: 'SecondFederalTaxReturn'},

          {name: 'W2 - Most recent tax year', value: 'FirstW2'},
          {name: 'W2 - Previous tax year', value: 'SecondW2'},
          {name: 'Paystub - Most recent month', value: 'FirstPaystub'},
          {name: 'Paystub - Previous month', value: 'SecondPaystub'},
          {name: 'Bank statement - Most recent month', value: 'FirstBankStatement'},
          {name: 'Bank statement - Previous month', value: 'SecondBankStatement'},
          {name: 'Other Borrower Report', value: 'OtherBorrowerReport'},
        ]
        break;
      case "loan":
        var documentTypes = [
          {name: 'Estimated settlement statement', value: 'HudEstimate'},
          {name: 'Final settlement statement', value: 'HudFinal'},
          {name: 'Loan estimate', value: 'LoanEstimate'},
          {name: 'Loan application form', value: 'UniformResidentialLendingApplication'},
          {name: 'Other Loan Report', value: 'OtherLoanReport'},
        ]
        break;
      case "closing":
        var documentTypes = [
          {name: 'Closing Disclosure', value: 'ClosingDisclosure'},
          {name: 'Deed of Trust', value: 'DeedOfTrust'},
          {name: 'Closing - Loan Document', value: 'LoanDoc'},
          {name: 'Other Closing Report', value: 'OtherClosingReport'},
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
            question: response.checklist.question,
            documentType: response.checklist.document_type,
            documentTemplate: response.checklist.template_id,
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
    var document_templates = new Array();
    document_templates.push({name: '', value: ''});
    _.each(this.props.templates, function(template) {
      document_templates.push({name: template.name, value: template.id})
    })
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
              editable={true}/>
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
        <div className='form-group'>
          <div className='col-sm-4'>
            <SelectField
              label='Document'
              keyName='document'
              name='checklist[document]'
              value={this.state.document}
              options={this.props.documents}
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
        <div className='form-group' style={{'display': this.state.type == 'explain' ? null : 'none'}}>
          <div className='col-sm-4'>
            <TextField
              label='Question'
              keyName='question'
              name='checklist[question]'
              value={this.state.question}
              onChange={this.onChange}
              editable={true}/>
          </div>
          <div className='col-sm-4'>
            <SelectField
              label='Docusign Template'
              keyName='documentTemplate'
              name='checklist[template_id]'
              value={this.state.documentTemplate}
              options={document_templates}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-sm-2'>
            <button className='btn btn-primary' onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
          </div>
        </div>
      </form>
    );
  }
});
module.exports = Form;