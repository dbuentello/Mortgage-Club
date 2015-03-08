var ButtonGroup = React.createClass({
  propTypes: {
    // if @onClick is provided, when user clicks a button, the method is invoked with
    // the index of the button that was clicked
    onClick: React.PropTypes.func,
    // Items is just an array of labels
    items: React.PropTypes.arrayOf(React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.number
    ]))
  },

  handleClick : function(i) {
    this.props.onClick(i);
  },

  render: function() {
    var items = this.props.items,
        activeIndex = this.props.activeIndex;

    return (
      <div className={"btn-group btn-group-justified " + this.props.className} role="group">
        {_.map(items, function (item, i) {
          var extraClass = "";
          if(i === (activeIndex - 1)) {
            extraClass = "leftActive";
          } else if(i === activeIndex) {
            extraClass = "active";
          }
          return (
            <div className="btn-group" key={i}>
              <button onClick={this.handleClick.bind(this, i)} type="button" className={"btn btn-home " + extraClass}>{item}</button>
            </div>
          );
        }, this)}
      </div>
    );
  }
});

module.exports = ButtonGroup;
