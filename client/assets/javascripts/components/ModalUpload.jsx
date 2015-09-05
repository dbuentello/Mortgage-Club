var React = require('react/addons');
var Dropzone = require('components/form/Dropzone');

var ModalUpload = React.createClass({
  propTypes: {
    id: React.PropTypes.string.isRequired,
    name: React.PropTypes.string,
    klass: React.PropTypes.string,
    title: React.PropTypes.string.isRequired,
    yesCallback: React.PropTypes.func.isRequired
  },
  getInitialState: function() {
    return this.buildState();
  },
  buildState: function() {
    var state = {};
    var doc_type = this.props.checklist.document_type;

    state[doc_type] = 'drap file here or browse';
    state[doc_type + '_downloadUrl'] = 'javascript:void(0)';
    state[doc_type + '_removedUrl'] = 'javascript:void(0)';
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
    var dataTarget = '#' + this.props.id;
    var labelId = this.props.id + 'Label';
    var document = this.props.checklist.document
    var doc_type = this.props.checklist.document_type;
    var field = {label: document.label, name: document.name , placeholder: 'drap file here or browse', type: doc_type}

    var subject_key_name = document.subject_key_name;
    var subject_params = {};
    subject_params[subject_key_name] = this.props.subject.id;
    var customParams = [
      {type: doc_type},
      subject_params
    ];

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
                      uploadUrl={document.upload_path}
                      downloadUrl={this.state[doc_type + '_downloadUrl']}
                      removeUrl={this.state[doc_type + '_removedUrl']}
                      tip={this.state[doc_type]}
                      maxSize={10000000}
                      customParams={customParams}
                      uploadSuccessCallback={this.props.uploadSuccessCallback}
                    />
                  </div>
                </div>
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-default" data-dismiss="modal">Cancel</button>
              </div>
            </div>
          </div>
        </div>
      </span>
    );
  }
});

module.exports = ModalUpload;
