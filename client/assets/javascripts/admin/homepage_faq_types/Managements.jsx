/**
 * Manage homepage faq type
 */
var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var Managements = React.createClass({
  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function() {
    return {
      homepage_faq_types: this.props.bootstrapData.homepage_faq_types
    }
  },

  onReloadTable: function(homepage_faq_types) {
    this.setState({homepage_faq_types: homepage_faq_types});
  },

  render: function() {
    var url = '/homepage_faq_types/';

    return (
      <div>

        {/* header */}
    <div className="page-header">
      <div className="page-header-content">
        <div className="page-title">
          <h4>
            <i className="icon-arrow-left52 position-left"> </i>
            <span className="text-semibold"> Homepage Faq Type - Managements </span>
          </h4>
        </div>
      </div>
    </div>
{/* end header */}

  <div className="page-container">
    <div className="page-content">
      <div className="content-wrapper">
        <div className="panel panel-flat">
          <div className="panel-heading">
            <h5 className="panel-title">Homepage Faq Type</h5>
            </div>
              <div class="panel-body">
                </div>
                  <div className="table-responsive">
                    <table className="table table-striped">
                      <thead>
                        <tr>
                          <th>Name</th>
                          <th></th>
                        </tr>
                      </thead>
                      <tbody>
                        {
                          _.map(this.state.homepage_faq_types, function(homepage_faq_type) {
                            return (
                              <tr key={homepage_faq_type.id}>
                                <td>{homepage_faq_type.name}</td>
                                <td>
                                  <span>
                                    <a className='linkTypeReversed btn btn-primary' href={'homepage_faq_types/' + homepage_faq_type.id + '/edit'} data-method='get'>Edit</a>
                                  </span>
                                </td>
                              </tr>
                            )
                          }, this)
                        }
                      </tbody>
                    </table>
                  </div>
              </div>
              <div className="row">
                <div className="col-md-12">
                  <div className="panel panel-flat">
                    <div className="panel-heading">
                      <h5 className="panel-title">Add new Homepage Faq Type</h5>
                      <div className="heading-elements">
                      </div>
                    </div>
                    <div className="panel-body">
                    <Form Url={url} Method='POST' onReloadTable={this.onReloadTable}></Form>  </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Managements;
