var _ = require('lodash');
var React = require('react/addons');

var TextFormatMixin = require('mixins/TextFormatMixin');
var Dropzone = require('components/form/NewDropzone');
var BooleanRadio = require('components/form/NewBooleanRadio');
var TabDocumentsCompleted = require('mixins/CompletedLoanMixins/TabDocuments');

var owner_upload_fields = {
  first_personal_tax_return: {label: 'Personal tax return - Most recent year', name: 'first_personal_tax_return'},
  second_personal_tax_return: {label: 'Personal tax return - Previous year', name: 'second_personal_tax_return'},
  first_business_tax_return: {label: 'Business tax return - Most recent year', name: 'first_business_tax_return'},
  second_business_tax_return: {label: 'Business tax return - Previous year', name: 'second_business_tax_return'},
  first_w2: {label: 'W2 - Most recent tax year', name: 'first_w2'},
  second_w2: {label: 'W2 - Previous tax year', name: 'second_w2'},
  first_paystub: {label: "Paystub - Most recent period", name: 'first_paystub'},
  second_paystub: {label: 'Paystub - Previous period', name: 'second_paystub'},
  first_bank_statement: {label: 'Bank statement - Most recent month', name: 'first_bank_statement'},
  second_bank_statement: {label: 'Bank statement - Previous month', name: 'second_bank_statement'}
};

var co_borrower_upload_fields = {
  first_personal_tax_return: {label: 'Personal tax return - Most recent year', name: 'co_first_personal_tax_return'},
  second_personal_tax_return: {label: 'Personal tax return - Previous year', name: 'co_second_personal_tax_return'},
  first_business_tax_return: {label: 'Business tax return - Most recent year', name: 'co_first_business_tax_return'},
  second_business_tax_return: {label: 'Business tax return - Previous year', name: 'co_second_business_tax_return'},
  first_w2: {label: 'W2 - Most recent tax year', name: 'co_first_w2'},
  second_w2: {label: 'W2 - Previous tax year', name: 'co_second_w2'},
  first_paystub: {label: "Paystub - Most recent period", name: 'co_first_paystub'},
  second_paystub: {label: 'Paystub - Previous period', name: 'co_second_paystub'}
};

var uploaded_files = [];
var upload_fields = [];
var co_upload_fields = [];

var FormDocuments = React.createClass({
  mixins: [TextFormatMixin, TabDocumentsCompleted],

  getInitialState: function() {
    return this.buildStateFromLoan(this.props.loan);
  },

  onChange: function(change) {
    var key = Object.keys(change)[0];
    var value = change[key];
    this.setState(change);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  onDrop: function(files, field) {
    this.refresh();
  },

  refresh: function() {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 2, true);
  },

  componentDidUpdate: function(prevProps, prevState){
    if(!this.valid()){
      if(this.props.loan.secondary_borrower !== undefined && this.state.activateCoRequiredField === true && this.state.activateRequiredField === true)
        this.scrollTopError();
      else if (this.props.loan.secondary_borrower === undefined && this.state.activateRequiredField === true)
        this.scrollTopError();
    }
  },

  componentDidMount: function(){
    $("body").scrollTop(0);
  },

  render: function() {
    var uploadUrl = '/document_uploaders/base_document/upload';
    var borrower = this.props.loan.borrower;
    var secondary_borrower = this.props.loan.secondary_borrower;

    upload_fields = _.filter(borrower.documents, function(document){ return document.is_required == true }).map(function(document) { return document.document_type });

    if (secondary_borrower) {
      co_upload_fields = _.filter(secondary_borrower.documents, function(document){ return document.is_required == true }).map(function(document) { return document.document_type })
    }

    var otherField = {label: "Other", placeholder: "Click to upload"};

    var customOtherParams = [
      {document_type: "other_borrower_report"},
      {subject_id: borrower.id},
      {subject_type: "Borrower"},
      {description: "Other"}
    ];

    return (
      <div className="col-md-3 col-sm-12 account-content">
        <form className="form-horizontal">
          <div className='form-group'>
            <p className="box-description col-sm-12 text-xs-justify text-sm-justify">
              At the minimum, we’d need these documents to submit your loan application to underwriting. Please help us gather these documents.
            </p>
          </div>
          {
            _.map(Object.keys(owner_upload_fields), function(key) {
              if (upload_fields.indexOf(key) > -1) {
                var customParams = [
                  {document_type: key},
                  {subject_id: borrower.id},
                  {subject_type: "Borrower"},
                  {description: owner_upload_fields[key].label}
                ];
                return(
                  <div className="drop_zone" key={key}>
                    <Dropzone field={owner_upload_fields[key]}
                      uploadUrl={uploadUrl}
                      activateRequiredField={this.state.activateRequiredField}
                      downloadUrl={this.state[owner_upload_fields[key].name + '_downloadUrl']}
                      removeUrl={this.state[owner_upload_fields[key].name + '_removedUrl']}
                      tip={this.state[owner_upload_fields[key].name]}
                      maxSize={10000000}
                      customParams={customParams}
                      supportOtherDescription={owner_upload_fields[key].customDescription}
                      uploadSuccessCallback={this.afterUploadingDocumentBorrower}
                      removeSuccessCallback={this.afterRemovingDocumentBorrower}
                      editMode={this.props.editMode}
                      delete="no"/>
                  </div>
                )
              }
            }, this)
          }
          {
            _.map(this.state.otherBorrowerDocuments, function(borrowerDocument) {
              var customParams = [
                {document_type: "other_borrower_report"},
                {subject_id: borrower.id},
                {subject_type: "Borrower"},
                {description: borrowerDocument.description},
                {document_id: borrowerDocument.id}
              ];
              var deleteText = borrowerDocument.is_required == true ? "no" : "yes";
              var field = {label: borrowerDocument.description};
              return(
                <div className="drop_zone" style={{"margin-top": "10px"}} key={borrowerDocument.id}>
                  <Dropzone
                    field={field}
                    uploadUrl={uploadUrl}
                    downloadUrl={borrowerDocument.downloadUrl}
                    removeUrl={borrowerDocument.removeUrl}
                    tip={borrowerDocument.attachment_file_name}
                    maxSize={10000000}
                    customParams={customParams}
                    supportOtherDescription={false}
                    uploadSuccessCallback={this.reloadOtherDocuments}
                    removeSuccessCallback={this.reloadOtherDocuments}
                    editMode={this.props.editMode}
                    delete={deleteText}/>
                </div>
              )
            }, this)
          }
          {
            <div>
              {
                secondary_borrower
                ?
                <div className="box mtn">
                  <h3>
                    Please upload the following documents for your co-borrower.
                  </h3>
                </div>
                : null
              }
              {
                _.map(Object.keys(co_borrower_upload_fields), function(key) {
                  if (co_upload_fields.indexOf(key) > -1) {
                    var customParams = [
                      {document_type: key},
                      {subject_id: secondary_borrower.id},
                      {subject_type: "Borrower"},
                      {description: co_borrower_upload_fields[key].label}
                    ];
                    return(
                      <div className="drop_zone" key={key}>
                        <Dropzone field={co_borrower_upload_fields[key]}
                          uploadUrl={uploadUrl}
                          activateRequiredField={this.state.activateCoRequiredField}
                          downloadUrl={this.state[co_borrower_upload_fields[key].name + '_downloadUrl']}
                          removeUrl={this.state[co_borrower_upload_fields[key].name + '_removedUrl']}
                          tip={this.state[co_borrower_upload_fields[key].name]}
                          maxSize={10000000}
                          customParams={customParams}
                          supportOtherDescription={co_borrower_upload_fields[key].customDescription}
                          uploadSuccessCallback={this.afterUploadingDocumentCoBorrower}
                          removeSuccessCallback={this.afterRemovingDocumentCoBorrower}
                          editMode={this.props.editMode}
                          delete="no"/>
                      </div>
                    )
                  }
                }, this)
              }
            </div>
          }

          <div className="drop_zone" style={{"margin-top": "10px"}} key={"other_document"}>
            <Dropzone field={otherField}
              uploadUrl={uploadUrl}
              maxSize={10000000}
              customParams={customOtherParams}
              supportOtherDescription={true}
              uploadSuccessCallback={this.reloadOtherDocuments}
              resetAfterUploading={true}
              editMode={this.props.editMode}/>
          </div>
          <div className='form-group'>
            <div className='col-md-12'>
              {
                this.props.editMode
                ?
                  <button className="btn text-uppercase" id="continueBtn" onClick={this.save}>Next<img src="/icons/arrowRight.png" alt="arrow"/></button>
                :
                  <button className="btn text-uppercase" id="nextBtn" onClick={this.next}>Next<img src="/icons/arrowRight.png" alt="arrow"/></button>
              }
            </div>
          </div>
        </form>
      </div>
    );
  },

  reloadOtherDocuments: function(){
    $.ajax({
      url: "/loans/borrower_other_documents",
      method: "GET",
      context: this,
      dataType: "json",
      data: {
        borrower_id: this.props.loan.borrower.id
      },
      success: function(response) {
        if(response.borrower_documents !== undefined && response.borrower_documents !== null) {
          var state = this.state;
          _.each(response.borrower_documents, function(otherDocument) {
            if(otherDocument.original_filename){
              var removeUrl = "/document_uploaders/base_document/" + otherDocument.id;
              if(otherDocument.is_required == true){
                removeUrl += "?delete=no"
              }

              otherDocument.downloadUrl = "/document_uploaders/base_document/" + otherDocument.id + "/download";
              otherDocument.removeUrl = removeUrl;
            }
          }, this);
          state.otherBorrowerDocuments = response.borrower_documents;
          this.setState(state);
        }
      }.bind(this)
    });
  },

  afterUploadingDocumentBorrower: function(typeDocument, name, id) {
    this.props.updateDocuments("borrower", typeDocument, "upload", name, id);
  },

  afterRemovingDocumentBorrower: function(typeDocument) {
    this.props.updateDocuments("borrower", typeDocument, "remove");
  },

  afterUploadingDocumentCoBorrower: function(typeDocument, name, id) {
    this.props.updateDocuments("coborrower", typeDocument, "upload", name, id);
  },

  afterRemovingDocumentCoBorrower: function(typeDocument) {
    this.props.updateDocuments("coborrower", typeDocument, "remove");
  },

  componentWillReceiveProps: function(nextProps) {
    this.setState(_.extend(this.buildStateFromLoan(nextProps.loan), {
      saving: false
    }));
  },

  buildStateFromLoan: function(loan) {
    var borrower = loan.borrower;
    var secondary_borrower = loan.secondary_borrower;
    var state = {};
    state.activateRequiredField = false;
    state.activateCoRequiredField = false;

    uploaded_files = [];

    this.setStateForUploadFields(borrower, state, owner_upload_fields);
    if(borrower.other_documents !== undefined && borrower.other_documents !== null){
      state.otherBorrowerDocuments = borrower.other_documents;

      _.each(state.otherBorrowerDocuments, function(otherDocument) {
        if(otherDocument.original_filename){
          var removeUrl = "/document_uploaders/base_document/" + otherDocument.id;
          if(otherDocument.is_required == true){
            removeUrl += "?delete=no"
          }

          otherDocument.downloadUrl = "/document_uploaders/base_document/" + otherDocument.id + "/download";
          otherDocument.removeUrl = removeUrl;
        }
      }, this);
    }
    if (secondary_borrower) {
      this.setStateForUploadFields(secondary_borrower, state, co_borrower_upload_fields);
      state.hasSecondaryBorrower = true;
    }
    return state;
  },

  setStateForUploadFields: function(borrower, state, upload_fields) {
    _.map(Object.keys(upload_fields), function(key) {
      var borrowerDocument = _.find(borrower.documents, { 'document_type': key });
      if (borrowerDocument){
        state[upload_fields[key].id] = borrowerDocument.id;

        if(borrowerDocument.original_filename){
          uploaded_files.push(upload_fields[key].name);

          state[upload_fields[key].name] = borrowerDocument.original_filename;
          state[upload_fields[key].name + '_downloadUrl'] = '/document_uploaders/base_document/' + borrowerDocument.id + '/download';
          state[upload_fields[key].name + '_removedUrl'] = '/document_uploaders/base_document/' + borrowerDocument.id + "?delete=no";
        }
      }
    }, this);
  },

  buildLoanFromState: function() {
    var loan = this.props.loan;
    loan.borrower_attributes = {id: this.props.loan.borrower.id};
    return loan;
  },

  scrollTopError: function(){
    var offset = $(".tooltip").first().parents(".form-group").offset();
    if(offset !== undefined)
      $('html, body').animate({scrollTop: offset.top}, 1000);
  },

  valid: function(){
    var borrower_uploaded_files = [];
    var co_borrower_uploaded_files = [];

    // _.each(upload_fields, function(upload_field) {
    //   if(upload_field != "other_borrower_report"){
    //     borrower_uploaded_files.push(owner_upload_fields[upload_field].name);
    //   }
    // });

    // _.each(co_upload_fields, function(co_upload_field) {
    //   co_borrower_uploaded_files.push(co_borrower_upload_fields[co_upload_field].name);
    // });

    // var other_file = _.find(this.state.otherBorrowerDocuments, function(otherDocument){ return otherDocument.original_filename == null && otherDocument.is_required == true });
    // var result = borrower_uploaded_files.concat(co_borrower_uploaded_files).filter(function(i) {
    //   return uploaded_files.indexOf(i) < 0;
    // });

    // if(result.length == 0 && other_file === undefined)
    //   return true;
    // return false;

    return true;
  },

  save: function(event) {
    this.setState({saving: true});
    // this.setState({saving: true, activateRequiredField: true, activateCoRequiredField: true, activateFileTaxesJointlyError: true});
    var isValid = this.valid();
    if(isValid){
      this.props.saveLoan(this.buildLoanFromState(), 2);
    }
    else{
      this.setState({saving: false});
    }
    event.preventDefault();
  },

  next: function(event){
    this.props.next(3);
    event.preventDefault();
  },
});

module.exports = FormDocuments;