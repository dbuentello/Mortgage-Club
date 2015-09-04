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
    return this.buildStateFromBorrower();
  },
  buildStateFromBorrower: function() {
    var state = {};
    _.map(Object.keys(fields), function(key) {
      if (this.props.borrower[key]) { // has a document
        state[fields[key].name] = this.props.borrower[key].attachment_file_name;
        state[fields[key].id] = this.props.borrower[key].id;
        state[fields[key].name + '_downloadUrl'] = '/document_uploaders/base_document/' + this.props.borrower[key].id +
                                         '/download?type=' + fields[key].type;
        state[fields[key].name + '_removedUrl'] = '/document_uploaders/base_document/' + this.props.borrower[key].id +
                                         '/remove?type=' + fields[key].type;
      } else {
        state[fields[key].name] = fields[key].placeholder;
        state[fields[key].name + '_downloadUrl'] = 'javascript:void(0)';
        state[fields[key].name + '_removedUrl'] = 'javascript:void(0)';
      }
    }, this);
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

    var uploadUrl = '/document_uploaders/borrowers/upload';

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
                {
                  _.map(Object.keys(fields), function(key) {
                    var customParams = [
                      {type: fields[key].type},
                      {borrower_id: this.props.borrower.id}
                    ];
                    return(
                      <div className="drop_zone" key={key}>
                        <Dropzone field={fields[key]}
                          uploadUrl={uploadUrl}
                          downloadUrl={this.state[fields[key].name + '_downloadUrl']}
                          removeUrl={this.state[fields[key].name + '_removedUrl']}
                          tip={this.state[fields[key].name]}
                          maxSize={10000000}
                          customParams={customParams}
                          supportOtherDescription={fields[key].customDescription}
                        />
                      </div>
                    )
                  }, this)
                }
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
