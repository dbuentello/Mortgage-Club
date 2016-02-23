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
    console.log("loan_members_titles/"+this.state.titleId);
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
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>All Titles</h2>

            <table className="table table-striped">
              <thead>
                <tr>
                  <th>Title</th>
                  <th>Action</th>
                  <th></th>
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
                            <a className='btn btn-primary' href={'loan_members_titles/' + title.id + '/edit'} data-method='get'>Edit</a>
                          </span>

                        </td>
                        <td>
                          <span>
                            <a className='btn btn-danger' onClick={this.handleRemoveTitle} id={title.id}>Delete</a>
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
            <h2 className='mbl'>Add new title</h2>
            <Form Url={url} Method='POST' onReloadTable={this.onReloadTable}></Form>
          </div>
          <div className="modal fade" id="removeTitleItem" tabIndex="-1" role="dialog" aria-labelledby="Confirmation">
            <div className="modal-dialog modal-md" role="document">
              <div className="modal-content">
                <span className="glyphicon glyphicon-remove-sign closeBtn" data-dismiss="modal"></span>
                <div className="modal-body text-center">

                  <h3 className={this.props.bodyClass}>Are you sure you want to delete this title ?</h3>

                  <form className="form-horizontal">
                    <div className="form-group">
                      <div className="col-md-6">
                        <button type="button" className="btn btn-default" data-dismiss="modal">No</button>
                      </div>
                      <div className="col-md-6">
                        <button type="button" className="btn theBtn" onClick={this.handleRemove}>Yes</button>
                      </div>
                    </div>
                  </form>
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