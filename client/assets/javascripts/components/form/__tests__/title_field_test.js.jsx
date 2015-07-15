/**
 * @jsx React.DOM
 */

jest.dontMock('../title_field');
jest.dontMock('../../../mixins/text_format_mixin');
jest.dontMock('../../../mixins/static_field_mixin');
jest.dontMock('../../../mixins/update_change_mixin');
jest.dontMock('../../../mixins/text_focus_mixin');

// we will always need these to build our components.
// global in node is like window in the browser.
global.React = require('react/addons');
global._ = require('lodash');

describe('Title Field Component', function() {
  var Field = require('../title_field');
  var TestUtils = React.addons.TestUtils;

  it('renders into DOM as editable by default', function() {
    var editable = true;

    var field = TestUtils.renderIntoDocument(
      <Field editable={editable} />
    );

    // Verify that it's editable by default
    var input = TestUtils.findRenderedDOMComponentWithTag(field, 'input');
    expect(hasClass(input.getDOMNode(), 'hidden')).toBe(!editable);
  });

  it('emits the correct change to the onChange callback', function() {
    var data = {textValue : 'old'};
    var updateData = function(change) {
      data.textValue = change.textValue;
    };

    var field = TestUtils.renderIntoDocument(
      <Field label='Title Field' keyName='textValue' value={data.textValue} editable={true} onChange={updateData} />
    );

    var input = TestUtils.findRenderedDOMComponentWithTag(field, 'input');
    TestUtils.Simulate.change(input, {target: {value: 'new'}});
    expect(data.textValue).toEqual('new');
  });

  function hasClass(element, cls) {
    return (' ' + element.className + ' ').indexOf(' ' + cls + ' ') > -1;
  }

});
