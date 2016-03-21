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
      class: "btn",
      title: 'Confirmation',
      body: 'Are you sure?',
      labelNo: 'No',
      labelYes: 'Yes'
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
          <div className="modal-dialog modal-md" role="document">
            <div className="modal-content">
              <span className="glyphicon glyphicon-remove-sign closeBtn" data-dismiss="modal"></span>
              <div className="modal-body text-center">
                <h2>{this.props.title}</h2>
                <h3 className={this.props.bodyClass}>{this.props.body}</h3>

                <form className="form-horizontal">
                  <div className="form-group">
                    <div className="col-md-6">
                      <button type="button" className="btn btn-default" data-dismiss="modal">{this.props.labelNo}</button>
                    </div>
                    <div className="col-md-6">
                      <button type="button" className="btn btn-mc" onClick={this.props.yesCallback}>{this.props.labelYes}</button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </span>
    );
  }
});

module.exports = ModalLink;
