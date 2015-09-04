var React = require('react/addons');
var Dropzone = require('components/form/Dropzone');


var fields = {
  first_w2: {label: 'W2 - Most recent tax year', name: 'first_w2', placeholder: 'drap file here or browse', type: 'FirstW2'}
};

var ModalUpload = React.createClass({
  propTypes: {
    id: React.PropTypes.string.isRequired,
    name: React.PropTypes.string,
    class: React.PropTypes.string,
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
      class: "btn",
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
          <a className={this.props.class} data-toggle="modal" data-target={dataTarget}><i className={this.props.icon}/>{this.props.name}</a>
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
                    />
                  </div>
                </div>
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" className="btn btn-primary" onClick={this.props.yesCallback}>OK</button>
              </div>
            </div>
          </div>
        </div>
      </span>
    );
  }
});

module.exports = ModalUpload;
