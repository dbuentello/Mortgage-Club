var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var EditPage = React.createClass({
  render: function() {
    var url = '/loan_activity_type_managements/' + this.props.bootstrapData.activity_type.id;

    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Edit Activity Type</h2>
            <Form ActivityType={this.props.bootstrapData.activity_type} Url={url} Method={'PUT'}></Form>
          </div>
        </div>
      </div>
    )
  }

});

module.exports = EditPage;