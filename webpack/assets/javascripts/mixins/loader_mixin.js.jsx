/**
 * @jsx React.DOM
 */

var LoaderMixin = {
  getInitialState: function() {
    return {
      loaded: false
    };
  },

  renderLoader: function() {
    return (
      <div className="overlayContainer pvxl rbl rbr">
        <div className="overlayDefault overlayFull text-center pts">
          <div className="loaderLarge"></div>
        </div>
      </div>
    );
  }
};

module.exports = LoaderMixin;
