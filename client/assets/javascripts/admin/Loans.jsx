var _ = require('lodash');
var React = require('react/addons');

var FlashHandler = require('mixins/FlashHandler');
var SelectField = require('components/form/SelectField');

var Loans = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    return {
      associations: this.props.bootstrapData.associations,
    };
  },

  getDefaultProps: function() {
  },

  componentDidMount: function() {
  },

  onActionClick: function() {
  },

  onLoanChange: function(event) {
    console.dir(event);
    $.ajax({
      url: '/admin/loan_assignments/loan_members',
      data: {
        loan_id: event.target.value
      },
      dataType: 'json',
      context: this,
      success: function(response) {
        this.setState({associations: response.associations});
      }
    });
  },

  render: function() {
    var loanOptions = [];
    var memberOptions = [];
    _.map(this.props.bootstrapData.loans, function(loan) {
      loanOptions.push({value: loan.id, name: 'Loan of ' + loan.user.to_s})
    });

    _.map(this.props.bootstrapData.loan_members, function(member) {
      memberOptions.push({value: member.id, name:  member.user.to_s})
    });

    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Loan Assignment</h2>
            <div className='box mtn'>
              <div className='row'>
                <div className='col-xs-3'>
                  <label className='pan'>
                    <span className='h7 typeBold'>Loans</span>
                  </label>
                  <select className='form-control' onChange={this.onLoanChange}>
                    {
                      _.map(this.props.bootstrapData.loans, function(loan) {
                        return (
                          <option value={loan.id} key={loan.id}>{'Loan of ' + loan.user.to_s}</option>
                        )
                      })
                    }
                  </select>
                </div>
                <div className='col-xs-3'>
                  <label className='pan'>
                    <span className='h7 typeBold'>Members</span>
                  </label>
                  <select className='form-control'>
                    {
                      _.map(this.props.bootstrapData.loan_members, function(member) {
                        return (
                          <option value={member.id} key={member.id}>{'Loan of ' + member.user.to_s}</option>
                        )
                      })
                    }
                  </select>
                </div>
                <div className='col-xs-3'>
                  <label className='pan'>
                    <span className='h7 typeBold'>Title</span>
                  </label>
                  <select className='form-control'>
                    <option value='sale'>Sale</option>
                    <option value='premier_agent'>Premier Agent</option>
                    <option value='manager'>Manager</option>
                  </select>
                </div>
                <div className='col-xs-3 ptl'>
                  <button className='btn btn-primary' onClick={this.onActionClick}>Assign</button>
                </div>
              </div>
            </div>
          </div>
          <div className='row'>
            <div className='table-responsive'>
              <table className='mtxl table table-bordered table-striped table-hover'>
                <thead>
                  <tr>
                    <th>Assignee</th>
                    <th>Title</th>
                    <th style={{'width': '10%'}}></th>
                  </tr>
                </thead>
                <tbody>
                  {
                    _.map(this.state.associations, function(association) {
                      return (
                        <tr key={association.id}>
                          <td>{association.loan_member.user.to_s}</td>
                          <td>{association.title}</td>
                          <td><button className='btn btn-danger' onClick={null}>Remove</button></td>
                        </tr>
                      )
                    })
                  }
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    )
  }

});

module.exports = Loans;