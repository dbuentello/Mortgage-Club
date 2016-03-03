var React = require("react/addons");
var Dropzone = require("components/form/NewDropzone");
var TextField = require("components/form/NewTextField");
var TextFormatMixin = require("mixins/TextFormatMixin");
var ClientPart = require("public/ClientPart");
var HowPart = require("public/HowPart");
var WhyPart = require("public/WhyPart");
var BankPart = require("public/BankPart");

var RefinancingAlert = React.createClass({

  render: function() {
      return (
      <div>
        <BankPart></BankPart>
        <WhyPart> </WhyPart>
        <HowPart> </HowPart>
        <ClientPart> </ClientPart>
      </div>
    );
  }
});

module.exports = RefinancingAlert;
