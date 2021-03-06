/**
 * Refinance alert for user and billy run ads in FB
 */
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

var RefinanceAlert = React.createClass({
  render: function() {
      return (
        <div className="homepage">
          <HomePart data={this.props.bootstrapData} ></HomePart>
          <BankPart></BankPart>
          <RateAlert bootstrapData={this.props.bootstrapData}/>
        </div>
    );
  }
});

module.exports = RefinanceAlert;
