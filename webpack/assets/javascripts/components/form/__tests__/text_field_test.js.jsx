/**
 * @jsx React.DOM
 */

jest.dontMock('../text_field');
jest.dontMock('../../../mixins/text_format_mixin');
jest.dontMock('../../../mixins/static_field_mixin');
jest.dontMock('../../../mixins/update_change_mixin');
jest.dontMock('../../../mixins/text_focus_mixin');

// we will always need these to build our components.
// global in node is like window in the browser.
global.React = require('react/addons');
global._ = require('lodash');

describe('Text Field Component', function() {
  var Field = require('../text_field');
  var TestUtils = React.addons.TestUtils;

  it('renders into DOM as uneditable by default', function() {
    var editable = false;

    var field = TestUtils.renderIntoDocument(
      <Field editable={editable} />
    );

    // Verify that it's editable by default
    var input = TestUtils.findRenderedDOMComponentWithTag(field, 'input');
    expect(hasClass(input.getDOMNode(), 'hidden')).toBe(!editable);
  });

  it('render the display to reflect the current input value', function() {
    var field;
    var data = {textValue : '100'};

    var render = function(data) {
      field = TestUtils.renderIntoDocument(
        <Field value={data.textValue} editable={true} keyName='textValue'
          prefix='$' suffix=' (increase)' format='number' decimals={0} onChange={updateData} />
      );
    };

    var updateData = function(change) {
      data.textValue = change.textValue;
      render(data);
    };

    render(data);

    var input = TestUtils.findRenderedDOMComponentWithTag(field, 'input');
    TestUtils.Simulate.change(input, {target: {value: '1000'}});

    var display = TestUtils.findRenderedDOMComponentWithTag(field, 'p');
    expect(display.getDOMNode().textContent).toEqual('$1,000 (increase)');

  });

  it('emits the correct change to the onChange callback', function() {
    var data = {textValue : 'old'};
    var updateData = function(change) {
      data.textValue = change.textValue;
    };

    var field = TestUtils.renderIntoDocument(
      <Field label='Text Field' keyName='textValue' value={data.textValue} editable={true} onChange={updateData} />
    );

    var input = TestUtils.findRenderedDOMComponentWithTag(field, 'input');
    TestUtils.Simulate.change(input, {target: {value: 'new'}});
    expect(data.textValue).toEqual('new');
  });

  function hasClass(element, cls) {
    return (' ' + element.className + ' ').indexOf(' ' + cls + ' ') > -1;
  }

});
