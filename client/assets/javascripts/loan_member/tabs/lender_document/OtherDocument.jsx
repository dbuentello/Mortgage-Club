var _ = require("lodash");
var React = require("react/addons");
var Dropzone = require("components/form/Dropzone");
var FlashHandler = require("mixins/FlashHandler");

var OtherDocument = React.createClass({
  render: function() {
    var fields = {label: this.props.label, placeholder: "drag file here or browse"};
    var customParams = [
      {template_id: this.props.otherTemplate.id},
      {description: this.props.otherTemplate.description},
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
          supportOtherDescription={true}/>
      </div>
    )
  }
});
module.exports = OtherDocument;
