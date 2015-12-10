var _ = require("lodash");
var React = require("react/addons");
var Dropzone = require("components/form/Dropzone");
var FlashHandler = require("mixins/FlashHandler");

var OtherDocument = React.createClass({
  render: function() {
    var label = this.props.label ? this.props.label : "Other Document";
    var fields = {label: label, placeholder: "drag file here or browse"};
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
          uploadSuccessCallback={this.props.uploadSuccessCallback}/>
      </div>
    )
  }
});
module.exports = OtherDocument;
