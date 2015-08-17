var React = require('react/addons');

/**
 * HelpTooltipView renders a pretty little circle with a question mark that
 * displays a helpful tooltip when hovered over.
 */
var ModalLink = React.createClass({
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
      id: "modal",
      name: "Delete",
      class: "btn",
      title: 'Confirmation',
      body: 'Are you sure?'
    };
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
