var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var Managements = React.createClass({
  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function() {
    return {
      faqs: this.props.bootstrapData.faqs
    }
  },

  onReloadTable: function(faqs) {
    this.setState(
      {faqs: faqs}
    )
  },

  render: function() {
    var url = '/loan_faq_managements/';

    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>FAQ Managements</h2>
            <table className="table table-striped">
              <thead>
                <tr>
                  <th>Question</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {
                  _.map(this.state.faqs, function(faq) {
                    return (
                      <tr key={faq.id}>
                        <td>{faq.question}</td>
                        <td>
                          <span>
                            <a className='linkTypeReversed btn btn-primary' href={'loan_faq_managements/' + faq.id + '/edit'} data-method='get'>Edit</a>
                          </span>
                        </td>
                      </tr>
                    )
                  }, this)
                }
              </tbody>
            </table>
          </div>
          <div className='row'>
            <h2 className='mbl'>Add new FAQ</h2>
            <Form Url={url} Method='POST' onReloadTable={this.onReloadTable}></Form>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Managements;