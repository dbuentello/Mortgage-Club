var _ = require('lodash');
var React = require('react/addons');
var BorrowerUploader = require('../form_uploader/Borrower');
var PropertyUploader = require('../form_uploader/Property');
var DocumentTab = React.createClass({
  render: function() {
    return (
      <div className='content container backgroundBasic'>
        <div className="row ptl">
          <div className="col-xs-4">
            <select className="form-control">
              <option value="property">Property Document</option>
              <option value="borrower">Borrower Document</option>
              <option value="loan">Loan Document</option>
            </select>
          </div>
        </div>
        <div className="row">
          <PropertyUploader property={this.props.property}></PropertyUploader>
        </div>
      </div>
    );
  }
});

module.exports = DocumentTab;