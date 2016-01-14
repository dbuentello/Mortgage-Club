var React = require('react/addons');
var Dropzone = require('components/form/Dropzone');

var ChecklistUpload = React.createClass({
  propTypes: {
    id: React.PropTypes.string.isRequired,
    name: React.PropTypes.string,
    klass: React.PropTypes.string,
    title: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return this.buildState();
  },

  buildState: function() {
    var state = {};
    var doc_type = this.props.checklist.document_type;
    var borrower_document = _.find(this.props.borrower.documents, { 'document_type': doc_type });

    if (borrower_document){
      state[doc_type] = borrower_document.original_filename;
      state[doc_type + '_downloadUrl'] = '/document_uploaders/base_document/' + borrower_document.id + '/download';
      state[doc_type + '_removedUrl'] = '/document_uploaders/base_document/' + borrower_document.id;
    }
    else {
      state[doc_type] = 'drag file here or browse';
      state[doc_type + '_downloadUrl'] = 'javascript:void(0)';
      state[doc_type + '_removedUrl'] = 'javascript:void(0)';
    }
    return state;
  },

  getDefaultProps: function() {
    return {
      id: "modal-checklist",
      klass: "btn",
      title: 'Confirmation',
    };
  },

  render: function() {
    var checklist = this.props.checklist;
    var dataTarget = '#' + this.props.id;
    var labelId = this.props.id + 'Label';
    var field = {label: checklist.document_description, name: checklist.document_type , placeholder: 'drag file here or browse'}
    var uploadUrl = '/document_uploaders/base_document/upload';

    var customParams = [
      {document_type: checklist.document_type},
      {subject_id: this.props.subject.id},
      {subject_type: checklist.subject_name},
      {description: checklist.document_description}
    ];
    console.dir('324234423423')
    console.dir(checklist)
    return (
      <span>
        {
          this.props.name ?
          <a className={this.props.klass} data-toggle="modal" data-target={dataTarget}><i className={this.props.icon}/>{this.props.name}</a>
          :
          null
        }

        <div className="modal fade" id={this.props.id} tabIndex="-1" role="dialog" aria-labelledby={labelId}>
          <div className="modal-dialog modal-upload" role="document">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 className="modal-title" id={labelId}>{this.props.title}</h4>
              </div>
              <div className="modal-body" >
                <div className="upload-zone">
                  <div className="drop_zone">
                    <Dropzone field={field}
                      uploadUrl={uploadUrl}
                      downloadUrl={this.state[checklist.document_type + '_downloadUrl']}
                      removeUrl={this.state[checklist.document_type + '_removedUrl']}
                      tip={this.state[checklist.document_type]}
                      maxSize={10000000}
                      customParams={customParams}
                      uploadSuccessCallback={this.props.uploadSuccessCallback}/>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </span>
    );
  }
});

module.exports = ChecklistUpload;
