var React = require("react/addons");
var Dropzone = require("components/form/NewDropzone");
var TextField = require("components/form/NewTextField");
var TextFormatMixin = require("mixins/TextFormatMixin");
var ClientPart = require("public/ClientPart");
var HowPart = require("public/HowPart");

var RefinancingAlert = React.createClass({

  render: function() {
      return (
      <div>
        <HowPart> </HowPart>
        <ClientPart> </ClientPart>
      </div>
    );
  }
});

module.exports = RefinancingAlert;
