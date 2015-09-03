var _ = require('lodash');
var React = require('react/addons');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var FlashHandler = require('mixins/FlashHandler');

var Form = React.createClass({
  mixins: [FlashHandler],

  getDefaultProps: function() {
    return {
      checklistTypes: [
        {name: '', value: ''},
        {name: 'Explain', value: 'explain'},
        {name: 'Upload', value: 'upload'}
      ],
      documentTypes: [
        {name: '', value: ''},
        {name: 'W2 - Most recent tax year', value: 'FirstW2'},
        {name: 'W2 - Previous tax year', value: 'SecondW2'},
        {name: 'Paystub - Most recent month', value: 'FirstPaystub'},
        {name: 'Paystub - Previous month', value: 'SecondPaystub'},
        {name: 'Bank statement - Most recent month', value: 'FirstBankStatement'},
        {name: 'Bank statement - Previous month', value: 'SecondBankStatement'},
        {name: 'Other Borrower Report', value: 'OtherBorrowerReport'},
        {name: 'Closing Disclosure', value: 'ClosingDisclosure'},
        {name: 'Deed of Trust', value: 'DeedOfTrust'},
        {name: 'Closing - Loan Document', value: 'LoanDoc'},
        {name: 'Other Closing Report', value: 'OtherClosingReport'},
        {name: 'Estimated settlement statement', value: 'HudEstimate'},
        {name: 'Final settlement statement', value: 'HudFinal'},
        {name: 'Loan estimate', value: 'LoanEstimate'},
        {name: 'Loan application form', value: 'UniformResidentialLendingApplication'},
        {name: 'Other Loan Report', value: 'OtherLoanReport'},
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
        {name: 'Other Closing Report', value: 'OtherPropertyReport'}
      ],
    };
  },

  getInitialState: function() {
    if(this.props.checklist) {
      return {
        type: this.props.checklist.checklist_type,
        name: this.props.checklist.name,
        description: this.props.checklist.description,
        dueDate: this.props.checklist.due_date,
        question: this.props.checklist.question,
        documentType: this.props.checklist.document_type,
        documentTemplate: this.props.checklist.template_id
      };
    }else {
      return {
        type: 'explain'
      };
    }
  },

  onChange: function(change) {
    this.setState(change);
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
            description: response.checklist.description,
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
      }.bind(this),
      error: function(response, status, error) {
        var flash = { "alert-danger": response.message };
        this.showFlashes(flash);
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
              label='Description'
              keyName='description'
              name='checklist[description]'
              value={this.state.description}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>
        <div className='form-group' style={{'display': this.state.type == 'explain' ? null : 'none'}}>
          <div className='col-sm-6'>
            <TextField
              label='Question'
              keyName='question'
              name='checklist[question]'
              value={this.state.question}
              onChange={this.onChange}
              editable={true}/>
          </div>
          <div className='col-sm-6'>
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
        <div className='form-group' style={{'display': this.state.type == 'upload' ? null : 'none'}}>
          <div className='col-sm-6'>
            <SelectField
              label='Document Type'
              keyName='documentType'
              name='checklist[document_type]'
              value={this.state.documentType}
              options={this.props.documentTypes}
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