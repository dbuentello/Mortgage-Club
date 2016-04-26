var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var MortgageDataTable = require("./MortgageDataTable")

var Borrowers = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    return {
    }
  },


  render: function() {
    return (
    <div>
      <form name="search">
        <input type="text" id="search_value" name="search[search]"/>
        <button type="submit">Search </button>
      </form>
    </div>
    );
  }
});

module.exports = Borrowers;
