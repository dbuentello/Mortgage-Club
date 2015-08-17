var React = require('react/addons');

/**
 * HelpTooltipView renders a pretty little circle with a question mark that
 * displays a helpful tooltip when hovered over.
 */
var ModalLink = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
    class: React.PropTypes.string,
    title: React.PropTypes.string,
    body: React.PropTypes.string,
    yesCallback: React.PropTypes.func.isRequired
  },

  getDefaultProps: function() {
    return {
      name: "Delete",
      class: "btn",
      title: 'Confirmation',
      body: 'Are you sure?'
    };
  },

  onClick: function() {
  },

  render: function() {
    return (
      <span>
        <a className="btn btnSml btnDanger mlm mbm" data-toggle="modal" data-target="#myModal">{this.props.name}</a>

        <div className="modal fade" id="myModal" tabIndex="-1" role="dialog" aria-labelledby="myModalLabel">
          <div className="modal-dialog" role="document">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 className="modal-title" id="myModalLabel">{this.props.title}</h4>
              </div>
              <div className="modal-body">
                {this.props.body}
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-default" data-dismiss="modal">No</button>
                <button type="button" className="btn btn-primary" onClick={this.props.yesCallback}>Yes</button>
              </div>
            </div>
          </div>
        </div>
      </span>
    );
  }
});

module.exports = ModalLink;
