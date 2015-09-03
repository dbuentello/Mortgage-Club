var React = require('react/addons');

/**
 * HelpTooltipView renders a pretty little circle with a question mark that
 * displays a helpful tooltip when hovered over.
 */
var ModalUpload = React.createClass({
  propTypes: {
    id: React.PropTypes.string.isRequired,
    name: React.PropTypes.string,
    class: React.PropTypes.string,
    title: React.PropTypes.string.isRequired,
    body: React.PropTypes.string.isRequired,
    yesCallback: React.PropTypes.func.isRequired
  },

  getDefaultProps: function() {
    return {
      id: "modal-checklist",
      class: "btn",
      title: 'Confirmation',
      body: 'Are you sure?'
    };
  },

  loadDocusign: function() {
    $.ajax({
      url: "/electronic_signature/template/",
      method: 'POST',
      data: {
        template_name: this.state.templateName,
        id: this.props.loan.id
      },
      dataType: 'json',
      success: function(response) {
        // console.log(response);

        if (response.message == "don't render iframe") {
          alert("Okay, done!");
        } else if (response.message == "template does not exist yet") {
          alert(response.details);
        } else {
          $(this.refs.iframe.getDOMNode()).attr("src", response.message.url);
          $(this.refs.iframe.getDOMNode()).css("display", "block");
        }
      }.bind(this),
      error: function(response, status, error) {
        alert(error);
      }
    });
  },

  render: function() {
    var dataTarget = '#' + this.props.id;
    var labelId = this.props.id + 'Label';

    return (
      <span>
        {
          this.props.name ?
          <a className={this.props.class} data-toggle="modal" data-target={dataTarget}><i className={this.props.icon}/>{this.props.name}</a>
          :
          null
        }

        <div className="modal fade" id={this.props.id} tabIndex="-1" role="dialog" aria-labelledby={labelId}>
          <div className="modal-dialog" role="document">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 className="modal-title" id={labelId}>{this.props.title}</h4>
              </div>
              <div className="modal-body">
                <iframe ref='iframe' height='600px' width='100%' ></iframe>
              </div>
            </div>
          </div>
        </div>
      </span>
    );
  }
});

module.exports = ModalUpload;
