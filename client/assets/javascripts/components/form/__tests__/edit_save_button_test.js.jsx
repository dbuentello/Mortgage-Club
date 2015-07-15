/**
 * @jsx React.DOM
 */

jest.dontMock('../edit_save_button');

// we will always need these to build our components.
// global in node is like window in the browser.
global.React = require('react/addons');
global._ = require('lodash');

describe('Save/Edit Button', function() {
  var Btn = require('../edit_save_button');
  var TestUtils = React.addons.TestUtils;

  it('update parent\'s state when clicked', function() {
    var btn, textEl;

    var onStateChange = function(editable) {
      render(editable);
    };

    var render = function(editable) {
      btn = TestUtils.renderIntoDocument(
        <Btn editable={editable} onChange={onStateChange} />
      );
    };

    render(true);

    // Verify that it's in edit mode by default
    textEl = TestUtils.findRenderedDOMComponentWithTag(btn, 'span');
    expect(textEl.getDOMNode().textContent).toEqual('Save');

    TestUtils.Simulate.click(btn.getDOMNode());

    // Verify that it's in read mode after clicked on
    textEl = TestUtils.findRenderedDOMComponentWithTag(btn, 'span');
    expect(textEl.getDOMNode().textContent).toEqual('Edit');
  });

});
