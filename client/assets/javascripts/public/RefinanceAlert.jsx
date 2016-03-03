var React = require("react/addons");
var Dropzone = require("components/form/NewDropzone");
var TextField = require("components/form/NewTextField");
var TextFormatMixin = require("mixins/TextFormatMixin");

var ClientPart = require("public/homepage/ClientPart");
var HowPart = require("public/homepage/HowPart");
var WhyPart = require("public/homepage/WhyPart");
var BankPart = require("public/homepage/BankPart");
var HomePart = require("public/homepage/HomePart");

var InitialQuotes = require('public/InitialQuotes/Form');

var RefinancingAlert = React.createClass({

  render: function() {
      return (
      <div className="homepage">
        <HomePart bootstrapData={this.props.bootstrapData} ></HomePart>
        <BankPart></BankPart>
        <InitialQuotes bootstrapData={this.props.bootstrapData}/>
        <WhyPart> </WhyPart>
        <HowPart> </HowPart>
        <ClientPart> </ClientPart>
      </div>
    );
  }
});

module.exports = RefinancingAlert;
