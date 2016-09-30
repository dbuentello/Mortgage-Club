var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var EditPage = React.createClass({
  render: function() {
    var url = '/loan_activity_name_managements/' + this.props.bootstrapData.activity_name.id;

    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Edit Activity Name</h2>
            <Form ActivityName={this.props.bootstrapData.activity_name} ActivityTypes={this.props.bootstrapData.activity_types} Url={url} Method={'PUT'}></Form>
          </div>
        </div>
      </div>
    )
  }

});

module.exports = EditPage;