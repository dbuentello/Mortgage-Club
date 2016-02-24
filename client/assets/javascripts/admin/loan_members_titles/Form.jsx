var _ = require('lodash');
var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');
var TextField = require('components/form/TextField');
var UploadField = require('components/form/UploadField');
var ModalLink = require('components/ModalLink');
var BooleanRadio = require('components/form/BooleanRadio');

var Form = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    return {
      saving: false,
      title: this.props.Title
    }
  },

  onRemove: function() {
    if(this.props.Title) {
      this.setState({removing: true});

      $.ajax({
        url: this.props.Url,
        method: 'DELETE',
        success: function(response) {
          var flash = { "alert-success": response.message };
          this.showFlashes(flash);
          location.href = '/loan_members_titles';
        }.bind(this),
        error: function(response, status, error) {
          var flash = { "alert-danger": response.responseJSON.message };
          this.showFlashes(flash);
        }.bind(this)
      });
    }
  },

  onChange: function(event) {
    this.setState(event)
  },


  onClick: function(event) {
    this.setState({saving: true});
    event.preventDefault();
    var title = $("#title").val();
    console.log(title);

    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      data: {
        title: title
      },

      success: function(response) {
        console.log(response)
        this.setState(
          {
            title: response.title.title,
            titles: response.loan_members_titles,
            saving: false
          }
        );

        if(response.loan_members_titles){
          this.props.onReloadTable(response.loan_members_titles);
        }
        this.setState({saving: false});
      }.bind(this),
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.message };
        this.showFlashes(flash);
        this.setState({saving: false});
      }.bind(this)
    });
  },

  render: function() {
    return (
      <div>
        <form className="form-horizontal form-loan-member-title">
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Title"
                keyName="title"
                name="title"
                value={this.state.title ? this.state.title.title : null}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>

          <div className="form-group">
            <div className="col-sm-10">
              <button className="btn btn-primary" onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
              &nbsp;
              { this.props.Title ?
                <a className="btn btn-danger" data-toggle="modal" data-target="#removeTitle" disabled={this.state.removing}>{ this.state.removing ? 'Removing' : 'Remove' }</a>
              : null
              }
            </div>
          </div>
        </form>
        <ModalLink
          id="removeTitle"
          title="Confirmation"
          body="Are you sure to remove this title?"
          yesCallback={this.onRemove}
        />
      </div>
    )
  }
});

module.exports = Form;
