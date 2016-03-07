var React = require('react/addons');
// var ModalMixin = require('mixins/ModalMixin');

var ModalMixin = function() {
  var handlerProps = ['handleShow', 'handleShown', 'handleHide', 'handleHidden']

  var bsModalEvents = {
    handleShow: 'show.bs.modal',
    handleShown: 'shown.bs.modal',
    handleHide: 'hide.bs.modal',
    handleHidden: 'hidden.bs.modal'
  }

  return {
    propTypes: {
      handleShow: React.PropTypes.func,
      handleShown: React.PropTypes.func,
      handleHide: React.PropTypes.func,
      handleHidden: React.PropTypes.func,
      backdrop: React.PropTypes.bool,
      keyboard: React.PropTypes.bool,
      show: React.PropTypes.bool,
      remote: React.PropTypes.string
    },
    getDefaultProps: function() {
      return {
        backdrop: true,
        keyboard: true,
        show: true,
        remote: ''
      }
    },
    componentDidMount: function() {
      var $modal = $(this.getDOMNode()).modal({
        backdrop: this.props.backdrop,
        keyboard: this.props.keyboard,
        show: this.props.show,
        remote: this.props.remote
      })
      handlerProps.forEach(function(prop) {
        if (this[prop]) {
          $modal.on(bsModalEvents[prop], this[prop])
        }
        if (this.props[prop]) {
          $modal.on(bsModalEvents[prop], this.props[prop])
        }
      }.bind(this))
    },
    componentWillUnmount: function() {
      var $modal = $(this.getDOMNode())
      handlerProps.forEach(function(prop) {
        if (this[prop]) {
          $modal.off(bsModalEvents[prop], this[prop])
        }
        if (this.props[prop]) {
          $modal.off(bsModalEvents[prop], this.props[prop])
        }
      }.bind(this))
    },
    hide: function() {
      $(this.getDOMNode()).modal('hide')
    },
    show: function() {
      $(this.getDOMNode()).modal('show')
      this.loadDocusign()
    },
    toggle: function() {
      $(this.getDOMNode()).modal('toggle')
    },
    renderCloseButton: function() {
      return <button
        type="button"
        className="close"
        onClick={this.hide}
        dangerouslySetInnerHTML={{__html: '&times'}} />
    }
  }
}()

var ChecklistExplanation = React.createClass({
  mixins: [ModalMixin],

  propTypes: {
    id: React.PropTypes.string.isRequired,
    name: React.PropTypes.string,
    class: React.PropTypes.string,
    title: React.PropTypes.string.isRequired,
  },
  loadDocusign: function() {
    if ($(this.refs.iframe.getDOMNode()).css('display') == 'block') {
      return;
    }
    $(this.refs.indicator.getDOMNode()).css("display", "block");
    $.ajax({
      url: "/my/checklists/load_docusign/",
      method: 'GET',
      data: {
        id: this.props.checklist.id,
        template_name: "Generic Explanation",
        loan_id: this.props.loan.id
      },
      dataType: 'json',
      success: function(response) {
        if (response.message == "don't render iframe") {
          alert("Okay, done!");
        } else if (response.message == "template does not exist yet") {
          alert(response.details);
        } else {
          $(this.refs.iframe.getDOMNode()).attr("src", response.message.url);
          $(this.refs.iframe.getDOMNode()).css("display", "block");
        }
        $(this.refs.indicator.getDOMNode()).css("display", "none");
      }.bind(this),
      error: function(response, status, error) {
        $(this.refs.indicator.getDOMNode()).css("display", "none");
        alert(error);
      }
    });
  },

  getDefaultProps: function() {
    return {
      id: "modal-checklist",
      class: "btn",
      title: 'Generic Explanation',
    };
  },

  render: function() {
    var dataTarget = '#' + this.props.id;
    var labelId = this.props.id + 'Label';

    return (
      <div className="modal fade" id={this.props.id} tabIndex="-1" role="dialog" aria-labelledby={labelId}>
        <div className="modal-dialog modal-docusign" role="document">
          <div className="modal-content">
            <div className="modal-header">
              <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <h4 className="modal-title" id={labelId}>{this.props.title}</h4>
            </div>
            <div className="modal-body">
              <iframe ref='iframe' height='500px' width='100%'></iframe>
              <div ref='indicator' className="progress-indicator"><div className="spinner"></div></div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = ChecklistExplanation;
