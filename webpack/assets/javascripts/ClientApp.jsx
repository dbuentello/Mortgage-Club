var React = require('react/addons');

import { HelloWorld } from './components/HelloWorld';

var $ = require('jquery');

var render = () => {
  var $rootNode = $('[data-react-class=HelloWorld]');
  if ($rootNode.length > 0) {
    React.render(
      <div>
        <HelloWorld/>
      </div>,
      $rootNode.get(0)
    );
  }
};

$(function() {
  render();
});
