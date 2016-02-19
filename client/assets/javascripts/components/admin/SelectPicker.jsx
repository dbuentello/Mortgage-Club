var React = require('react/addons');

var _ = require('lodash');

var StaticFieldMixin = require('mixins/StaticFieldMixin');

var SelectPicker = React.createClass({
  mixins: [StaticFieldMixin],

  componentDidMount: function () {
  	$('.bootstrap-select').selectpicker();
    $('.bootstrap-select').on('change', function(){
      console.log("testtt");
      //this.onChange();
  });
  },
  getDefaultProps: function() {
    return {
      placeholder: null,
      valid: true
    };
  },
  getInitialState: function () {
    var options = this.props.options,
      selected;
    return {
      name: selected ? selected.name : null,
      options: options
    };
  },

  onChange: function(){
  	console.log('change');
  },

  render: function() {
    var displayText = this.state.name,
        classes = this.getFieldClasses(this.props.editable, this.props.isLarge, this.props.valid);

    classes.editableFieldClasses += ' placeholder';

    return (
      <div className="selectWrapper">
        <label className="col-xs-12 pan">
          <span className='h7 typeBold'>{this.props.label}</span>

        <select ref="selectPicker" className={classes.editableFieldClasses + " bootstrap-select show-tick"}  name={this.props.name} onChange={this.onChange} value={this.props.value || ''}>
          {(this.props.placeholder) ? <option value="" disabled={true}>{this.props.placeholder}</option> : null}
          {this.state.options.map(function (option, i) {
            return (
              <option key={'select_' + (option.value || option.name) + i} value={option.value || ''}>{option.name}</option>
            );
          }, this)}
        </select>
      </label>
  	  </div>
    );
  }
});


module.exports = SelectPicker;
