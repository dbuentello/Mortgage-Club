var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var MortgageDataTable = require("./MortgageDataTable");
var SearchBox = require("./SearchBox");

var Borrowers = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    return {
    }
  },

  render: function() {
    return (
      <div>
          {/* Page header */ }
      <div className="page-header">
        <div className="page-header-content">
          <div className="page-title">
            <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Borrowers</span> - Management</h4>
          </div>
        </div>
      </div>
      {/* /page header */ }

      {/* Page container */ }
      <div className="page-container">

        {/* Page content */ }
        <div className="page-content">

          {/* Main content */ }
          <div className="content-wrapper">

            {/* Table */ }
            <div className="panel panel-flat">
              <div className="panel-heading">
                <h5 className="panel-title">Mortgage Data</h5>
                <div className="heading-elements">
                  <SearchBox/>
                </div>
              </div>
              <div className="panel-body">
                <MortgageDataTable MortgageData={this.props.bootstrapData.mortgage_data}/>
              </div>
            </div>
            {/* /table */ }

          </div>
          {/* /main content */ }

        </div>
        {/* /page content */ }

      </div>
      {/* /page container */ }
    </div>
    );
  }
});

module.exports = Borrowers;
