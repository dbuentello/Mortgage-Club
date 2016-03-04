var React = require("react/addons");
var Dropzone = require("components/form/NewDropzone");
var TextField = require("components/form/NewTextField");
var TextFormatMixin = require("mixins/TextFormatMixin");

var ClientPart = require("public/homepage/ClientPart");
var HowPart = require("public/homepage/HowPart");
var WhyPart = require("public/homepage/WhyPart");
var BankPart = require("public/homepage/BankPart");
var HomePart = require("public/homepage/HomePart");

var RateAlert = require('public/RateAlert');

var RateDropAlert = React.createClass({

  render: function() {
      return (
      <div className="homepage">
        <HomePart data={this.props.bootstrapData} ></HomePart>
        <BankPart></BankPart>
        
      </div>
    );
  }
});

module.exports = RateDropAlert;
