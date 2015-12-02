var _ = require("lodash");
var React = require("react/addons");
var Dropzone = require("components/form/Dropzone");

var LenderDocumentTab = React.createClass({
  getInitialState: function() {
    var state = {};
    _.each(this.props.templates, function(template) {
      var lender_document = _.find(this.props.loan.lender_documents, {"required_template_id": template.id});
      if (lender_document) {
        state[template.id] = lender_document.id;
        state[template.id + "_name"] = lender_document.attachment_file_name;
        state[template.id + "_downloadUrl"] = "/loan_members/lender_documents/" + lender_document.id + "/download";
        state[template.id + "_removedUrl"] = "/loan_members/lender_documents/" + lender_document.id + "/remove";
      }else {
        state[template.id + "_name"] = "drap file here or browse";
        state[template.id + "_downloadUrl"] = "javascript:void(0)";
        state[template.id + "_removedUrl"] = "javascript:void(0)";
      }
    }, this);
    return state;
  },

  render: function() {
    return (
      <div className='content container backgroundBasic'>
        <div className='pal'>
          <div className='box mtn'>
            <div className='row'>
              {
                _.map(this.props.templates, function(template) {
                  var fields = {label: template.name, name: template.name, placeholder: 'drap file here or browse'};
                  var customParams = [
                    {template_id: template.id},
                    {description: template.description},
                    {loan_id: this.props.loan.id}
                  ];
                  console.dir(this.state[template.id + '_downloadUrl']);
                  return(
                    <div className="drop_zone" key={template.id}>
                      <Dropzone field={fields}
                        uploadUrl={'/loan_members/lender_documents/'}
                        downloadUrl={this.state[template.id + '_downloadUrl']}
                        removeUrl={this.state[template.id + '_removedUrl']}
                        tip={this.state[template.id + "_name"]}
                        maxSize={10000000}
                        customParams={customParams}
                        supportOtherDescription={template.is_other}/>
                    </div>
                  )
                }, this)
              }
            </div>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = LenderDocumentTab;
