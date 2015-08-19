var _ = require('lodash');
var React = require('react/addons');

var FlashHandler = require('mixins/FlashHandler');
var SelectField = require('components/form/SelectField');

var Loans = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    return {
    };
  },

  getDefaultProps: function() {
  },

  componentDidMount: function() {
  },

  render: function() {
    var loanOptions = []
    _.map(this.props.bootstrapData.loans, function(loan) {

    })
    return (
      <div className='content container'>
        <h2 className='mbl'>Loans Assignments</h2>
        {
          _.map(this.props.bootstrapData.loans, function(loan) {
            return (
              <p key={loan.id}>
                <a href={"/loans/" + loan.id}>Loan of {loan.user.to_s} (email: {loan.user.email})</a>
              </p>
              <div className='formContent'>
                <div className='pal'>
                  <div className='box mtn'>
                    <div className='row'>
                      <div className='col-xs-6'>
                        <SelectField
                          label={first_borrower_fields.applyingAs.label}
                          keyName={first_borrower_fields.applyingAs.name}
                          value={this.state[first_borrower_fields.applyingAs.name]}
                          options={borrowerCountOptions}
                          editable={this.state.borrower_editable}
                          onFocus={this.onFocus.bind(this, first_borrower_fields.applyingAs)}
                          onChange={this.coBorrowerHanlder}/>
                      </div>
                    </div>
                  </div>
                </div>
            )
          })
        }
      </div>
    )
  }

});

module.exports = Loans;