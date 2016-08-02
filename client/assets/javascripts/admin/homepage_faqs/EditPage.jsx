var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var EditPage = React.createClass({
  render: function() {
    var url = '/homepage_faqs/' + this.props.bootstrapData.homepage_faq.id;

    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Edit Question</h2>
            <Form HomepageFaq={this.props.bootstrapData.homepage_faq} HomepageFaqTypes={this.props.bootstrapData.homepage_faq_types} Url={url} Method={'PUT'}></Form>
          </div>
        </div>
      </div>
    )
  }

});

module.exports = EditPage;