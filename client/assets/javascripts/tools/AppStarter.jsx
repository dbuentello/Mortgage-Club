var $ = require('jquery');
var _ = require('lodash');
var React = require('react/addons');
var Router = require('react-router');

var CLASS_NAME_ATTR = 'data-react-class';
var PROPS_ATTR = 'data-react-props';

var mountReactComponents = function(routes) {
  var nodes = findReactDOMNodes();

  for (var i = 0; i < nodes.length; ++i) {
    var node = nodes[i];
    var className = node.getAttribute(CLASS_NAME_ATTR);
    // Assume className is simple and can be found at top-level (window).
    // Fallback to eval to handle cases like 'My.React.ComponentName'.
    var constructor = window[className] || eval.call(window, className);
    var propsJson = node.getAttribute(PROPS_ATTR);
    var props = propsJson && JSON.parse(propsJson);

    Router.run(routes, Router.HistoryLocation, function (Handler) {
      React.render(React.createElement(Handler, props), node);
    });
  }
};

var unmountReactComponents = function() {
  var nodes = findReactDOMNodes();
  for (var i = 0; i < nodes.length; ++i) {
    React.unmountComponentAtNode(nodes[i]);
  }
};

var handleTurbolinksEvents = function(routes) {
  var handleEvent;
  if ($) {
    handleEvent = function(eventName, callback) {
      $(document).on(eventName, callback);
    }
  } else {
    handleEvent = function(eventName, callback) {
      document.addEventListener(eventName, callback);
    }
  }
  handleEvent('page:change', _.bind(mountReactComponents, this, routes));
  handleEvent('page:receive', unmountReactComponents);
};

var handleNativeEvents = function(routes) {
  $(_.bind(mountReactComponents, this, routes));
  $(window).on('unload', unmountReactComponents);
};

var findReactDOMNodes = function() {
  var SELECTOR = '[' + CLASS_NAME_ATTR + ']';
  if ($) {
    return $(SELECTOR);
  } else {
    return document.querySelectorAll(SELECTOR);
  }
};

var AppStarter = {
  start: function(routes) {
    if (window !== undefined && document !== undefined) {
      handleNativeEvents(routes);
    }
  }
}

module.exports = AppStarter;
