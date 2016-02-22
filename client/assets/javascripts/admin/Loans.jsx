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

  onAssignClick: function() {
    var loan_id = $('.loan-list').val();
    var member_id = $('.member-list').val();
    var title = $('.title-list').val();

    $.ajax({
      url: '/loan_assignments',
      data: {
        loan_id: loan_id,
        loan_member_id: member_id,
        title: title
      },
      dataType: 'json',
      context: this,
      method: 'POST',
      success: function(response) {
        this.setState({associations: response.associations});
      }
    });
  },

  onRemoveClick: function(event) {
    var loan_id = $('.loan-list').val();
    $.ajax({
      url: '/loan_assignments/' + event.target.value,
      data: {
        loan_id: loan_id
      },
      dataType: 'json',
      method: 'DELETE',
      context: this,
      success: function(response) {
        var flash = { "alert-success": "Updated successfully!" };
        this.showFlashes(flash);
        this.setState({associations: response.associations});
      }
    });
  },

  onLoanChange: function(event) {
    $.ajax({
      url: '/loan_assignments/loan_members',
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
      <div>
          {/* Page header */ }
      <div className="page-header">
        <div className="page-header-content">
          <div className="page-title">
            <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Loan Assignment</span> - Management</h4>
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
                <h5 className="panel-title">Loan Assignments</h5>
                <div className="heading-elements">

                </div>
              </div>
              <div className="panel-body">
                <div className='row'>
                <div className='col-xs-3'>
                  <label className='pan'>
                    <span className='h7 typeBold'>Loans</span>
                  </label>
                  <select className='form-control loan-list' onChange={this.onLoanChange}>
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
                  <select className='form-control member-list'>
                    {
                      _.map(this.props.bootstrapData.loan_members, function(member) {
                        return (
                          <option value={member.id} key={member.id}>{member.user.to_s}</option>
                        )
                      })
                    }
                  </select>
                </div>
                <div className='col-xs-3'>
                  <label className='pan'>
                    <span className='h7 typeBold'>Title</span>
                  </label>
                  <select className='form-control title-list text-capitalize'>
                    {
                      _.map(this.props.bootstrapData.loan_members_titles, function(title) {
                        return (
                            <option value={title.id} key={title.id}>{title.title}</option>
                          )
                      })
                    }
                  </select>
                </div>
                <div className='col-xs-3' style={{'margin-top': '25px'}}  >
                  <button className='btn btn-primary' onClick={this.onAssignClick}>Assign</button>
                </div>
              </div>
              </div>
              <div className="table-responsive">
                <table className="table table-striped table-hover">
                  <thead>
                    <tr>
                      <th>Assignee</th>
                      <th>Title</th>
                      <th style={{'width': '10%'}}>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {
                      _.map(this.state.associations, function(association) {
                        return (
                          <tr key={association.id}>
                            <td>{association.loan_member.user.to_s}</td>
                            <td>{association.pretty_title}</td>
                            <td><button className='btn btn-danger' value={association.id} onClick={this.onRemoveClick}>Remove</button></td>
                          </tr>
                        )
                      }, this)
                    }
                  </tbody>
                </table>
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
    )
  }

});

module.exports = Loans;
