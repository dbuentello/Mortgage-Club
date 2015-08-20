var _ = require('lodash');
var React = require('react/addons');
var BorrowerUploader = require('../form_uploader/Borrower');
var PropertyUploader = require('../form_uploader/Property');
var LoanUploader = require('../form_uploader/Loan');
var ClosingUploader = require('../form_uploader/Closing');
var DocumentTab = React.createClass({
  getInitialState: function() {
    return {
      displayProperty: {display: true},
      displayBorrower: {display: 'none'},
      displayLoan: {display: 'none'},
      displayClosing: {display: 'none'}
    };
  },

  onChange: function(event) {
    switch(event.target.value) {
      case "property":
        this.setState({displayProperty: {display: true}});
        this.setState({displayBorrower: {display: 'none'}});
        this.setState({displayLoan: {display: 'none'}});
        this.setState({displayClosing: {display: 'none'}});
        break;
      case "borrower":
        this.setState({displayBorrower: {display: true}});
        this.setState({displayProperty: {display: 'none'}});
        this.setState({displayLoan: {display: 'none'}});
        this.setState({displayClosing: {display: 'none'}});
        break;
      case "loan":
        this.setState({displayLoan: {display: true}});
        this.setState({displayProperty: {display: 'none'}});
        this.setState({displayBorrower: {display: 'none'}});
        this.setState({displayClosing: {display: 'none'}});
        break;
      case "closing":
        this.setState({displayClosing: {display: true}});
        this.setState({displayLoan: {display: 'none'}});
        this.setState({displayProperty: {display: 'none'}});
        this.setState({displayBorrower: {display: 'none'}});
        break;
    }
  },

  render: function() {
    return (
      <div className='content container backgroundBasic'>
        <div className="row ptl">
          <div className="col-xs-4">
            <select className="form-control" onChange={this.onChange}>
              <option value="property">Property Document</option>
              <option value="borrower">Borrower Document</option>
              <option value="loan">Loan Document</option>
              <option value="closing">Closing Document</option>
            </select>
          </div>
        </div>
        <div id="property_uploader" className="row" style={this.state.displayProperty}>
          <PropertyUploader property={this.props.property}></PropertyUploader>
        </div>
        <div id="borrower_document_uploader" className="row" style={this.state.displayBorrower}>
          <BorrowerUploader borrower={this.props.loan.borrower}></BorrowerUploader>
        </div>
        <div id="loan_uploader" className="row" style={this.state.displayLoan}>
          <LoanUploader loan={this.props.loan}></LoanUploader>
        </div>
        <div id="closing_uploader" className="row" style={this.state.displayClosing}>
          <ClosingUploader closing={this.props.closing}></ClosingUploader>
        </div>
      </div>
    );
  }
});

module.exports = DocumentTab;