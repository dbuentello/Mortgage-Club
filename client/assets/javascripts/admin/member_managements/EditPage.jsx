var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var EditPage = React.createClass({
  render: function() {
    var url = '/loan_member_managements/' + this.props.bootstrapData.loan_member.id;

    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Edit Member</h2>
            <Form Member={this.props.bootstrapData.loan_member} Url={url} Method={'PUT'}></Form>
          </div>
        </div>
      </div>
    )
  }

});

module.exports = EditPage;