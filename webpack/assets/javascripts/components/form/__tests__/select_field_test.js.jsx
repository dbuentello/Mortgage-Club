/**
 * @jsx React.DOM
 */
jest.dontMock('../select_field');
jest.dontMock('../../../mixins/text_format_mixin');
jest.dontMock('../../../mixins/static_field_mixin');
jest.dontMock('../../../mixins/update_change_mixin');
jest.dontMock('../../../mixins/text_focus_mixin');

// we will always need these to build our components.
// global in node is like window in the browser.
global.React = require('react/addons');
global._ = require('lodash');

describe('Select Field Component', function() {
  var SelectField = require('../select_field');
  var TestUtils = React.addons.TestUtils;

  var selectOptions = [
    {name: 'One', value: '1'},
    {name: 'Two', value: '2'},
    {name: 'Three', value: '3'}
  ];

  it('renders into DOM as editable by default', function() {
    var editable = true;

    var selectField = TestUtils.renderIntoDocument(
      <SelectField label='Select Field' editable={editable} options={selectOptions} />
    );

    // Verify that it's editable by default
    var select = TestUtils.findRenderedDOMComponentWithTag(selectField, 'select');
    expect(hasClass(select.getDOMNode(), 'hidden')).toBe(!editable);
  });

  it('emits the correct change to the onChange callback', function() {
    var data = {number : '1'};
    var updateData = function(change) {
      data.number = change.number;
    };

    var selectField = TestUtils.renderIntoDocument(
      <SelectField label='Select Field' keyName='number' value={data.number} editable={true}
        options={selectOptions} onChange={updateData} />
    );

    var select = TestUtils.findRenderedDOMComponentWithTag(selectField, 'select');
    TestUtils.Simulate.change(select, {target: {value: '2'}});
    expect(data.number).toBe('2');
  });

  function hasClass(element, cls) {
    return (' ' + element.className + ' ').indexOf(' ' + cls + ' ') > -1;
  }

});
