/**
 * Manage docusign templates (show in the rightbar of dashboard)
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
      docusign_templates: this.props.bootstrapData.docusign_templates
    }
  },

  onReloadTable: function(docusign_templates) {
    this.setState({docusign_templates: docusign_templates});
  },

  render: function() {
    var url = '/docusign_template_managements/';

    return (
      <div>
          {/* Page header */ }
      <div className="page-header">
        <div className="page-header-content">
          <div className="page-title">
            <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Docusign Template</span> - Management</h4>
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
                <h5 className="panel-title">Docusign Template</h5>
                <div className="heading-elements">

                </div>
              </div>
              <div className="panel-body">

              </div>
              <div className="table-responsive">
                <table className="table table-striped table-hover">
                  <thead>
                    <tr>
                      <th>Name</th>
                      <th>Docusign Id</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {
                      _.map(this.state.docusign_templates, function(docusign_template) {
                        return (
                          <tr key={docusign_template.id}>
                            <td>{docusign_template.name}</td>
                            <td>{docusign_template.docusign_id}</td>
                            <td>
                              <span>
                                <a className='linkTypeReversed btn btn-primary' href={'docusign_template_managements/' + docusign_template.id + '/edit'} data-method='get'>Edit</a>
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
            {/* /table */ }

            {/* Grid */ }
            <div className="row">
              <div className="col-md-12">

                {/* Horizontal form */ }
                <div className="panel panel-flat">
                  <div className="panel-heading">
                    <h5 className="panel-title">Add new Docusign Template</h5>
                    <div className="heading-elements">

                    </div>
                  </div>

                  <div className="panel-body">
                      <Form Url={url} Method='POST' onReloadTable={this.onReloadTable}></Form>
                  </div>
                </div>
                {/* /horizotal form */ }
              </div>
            </div>
            {/* /grid */ }
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

module.exports = Managements;
