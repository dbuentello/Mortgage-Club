/**
 * Manage loan member titles
 */
var _ = require('lodash');
var React = require('react/addons');
var ModalLink = require('components/ModalLink');
var Form = require('./Form');

var Managements = React.createClass({
  getInitialState: function() {
    return {
      titles: this.props.bootstrapData.loan_members_titles
    }
  },
  onReloadTable: function(titles) {
    this.setState(
      {titles: titles}
    )
  },

  handleRemoveTitle: function(event) {
    this.setState({titleId: event.target.id});
    $("#removeTitleItem").modal();
  },

  handleRemove: function(event) {
   $.ajax({
      url: "loan_members_titles/"+this.state.titleId,
      method: "DELETE",
      success: function(response) {
          location.href = '/loan_members_titles';
        }.bind(this),
        error: function(response, status, error) {
          console.log(response);
        }.bind(this)
    });
  },

  render: function() {
    var url = '/loan_members_titles/';

    return (
      <div>
          {/* Page header */ }
        <div className="page-header">
          <div className="page-header-content">
            <div className="page-title">
              <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Team member</span> - Management</h4>
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
                  <h5 className="panel-title">Team Members</h5>
                  <div className="heading-elements">

                  </div>
                </div>
                <div className="panel-body">

                </div>
                <div className="table-responsive">
                  <table className="table table-striped table-hover">
                    <thead>
                      <tr>
                        <th>Title</th>
                        <th>Actions</th>

                      </tr>
                    </thead>
                    <tbody>
                      {
                        _.map(this.state.titles, function(title) {
                          return (
                            <tr key={title.id}>

                              <td>{title.title}</td>

                              <td>
                                <span>
                                  <a className='linkTypeReversed btn btn-primary member-title-action' href={'loan_members_titles/' + title.id + '/edit'} data-method='get'>Edit</a>
                                </span>
                                <span></span>
                                <span>
                                  <a className='linkTypeReversed btn btn-danger member-title-action' onClick={this.handleRemoveTitle} id={title.id}>Remove</a>
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
                      <h5 className="panel-title">Add new member</h5>
                      <div className="heading-elements">

                      </div>
                    </div>

                    <div className="panel-body">
                       <Form Url={url} Method='POST' onReloadTable={this.onReloadTable}></Form>
                    </div>
                    <div className="modal fade" id="removeTitleItem" tabIndex="-1" role="dialog" aria-labelledby="Confirmation">
                      <div className="modal-dialog modal-md" role="document">
                        <div className="modal-content">
                          <span className="glyphicon glyphicon-remove-sign closeBtn" data-dismiss="modal"></span>
                          <div className="modal-body text-center">

                            <h3 className={this.props.bodyClass}>Are you sure you want to remove this title?</h3>

                            <form className="form-horizontal">
                              <div className="form-group">
                                <div className="col-md-6">
                                  <button type="button" className="btn btn-default" data-dismiss="modal">No</button>
                                </div>
                                <div className="col-md-6">
                                  <button type="button" className="btn btn-mc" onClick={this.handleRemove}>Yes</button>
                                </div>
                              </div>
                            </form>
                          </div>
                        </div>
                      </div>
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