var _ = require("lodash");
var React = require("react/addons");
var Dropzone = require("components/form/AdminDropzone");
var FlashHandler = require("mixins/FlashHandler");

var OtherDocument = React.createClass({
  render: function() {
    var label = this.props.label ? this.props.label : "Other Document";
    var fields = {label: label, placeholder: "Drop files to upload or CLICK"};
    var customParams = [
      {template_id: this.props.otherTemplate.id},
      {loan_id: this.props.loanId}
    ];

    return (
      <div className="drop_zone">
        <Dropzone field={fields}
          uploadUrl={"/loan_members/lender_documents/"}
          downloadUrl={this.props.downloadUrl}
          removeUrl={this.props.removeUrl}
          tip={this.props.name}
          maxSize={10000000}
          customParams={customParams}
          supportOtherDescription={this.props.supportOtherDescription}
          uploadSuccessCallback={this.props.uploadSuccessCallback}
          removeSuccessCallback={this.props.removeSuccessCallback}
          useCustomDescription={true}/>
      </div>
    )
  }
});
module.exports = OtherDocument;
