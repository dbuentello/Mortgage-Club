var React = require('react/addons');
var TextField = require('components/form/NewTextField');
var SelectField = require('components/form/NewSelectField');

var TextFormatMixin = require('mixins/TextFormatMixin');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');

var assetTypes = [
  {value: 'checkings', name: 'Checkings'},
  {value: 'savings', name: 'Savings'},
  {value: 'investment', name: 'Investment'},
  {value: 'retirement', name: 'Retirement'},
  {value: 'other', name: 'Other'}
];

var Asset = React.createClass({
  mixins: [TextFormatMixin, ObjectHelperMixin],

  getInitialState: function () {
    return {
      institution_name: this.props.asset.institution_name,
      asset_type: this.props.asset.asset_type,
      current_balance: this.formatCurrency(this.props.asset.current_balance)
    };
  },

  onChange: function (change) {
    var key = _.keys(change)[0].replace(this.props.index, '');
    var value = _.values(change)[0];
    this.setState(this.setValue(this.state, key, value), function(){
      this.props.onUpdate(this.props.index, this.state);
    });
  },

  handleRemove: function(){
    this.props.onRemove(this.props.index);
  },

  render: function () {
    return (
      <div>
        <div className='form-group'>
          <div className='col-md-6'>
            <TextField
              activateRequiredField={this.props.institutionNameError}
              label='Institution Name'
              keyName={'institution_name' + this.props.index}
              editable={true}
              onChange={this.onChange}
              maxLength={200}
              value={this.state.institution_name}/>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-md-6'>
            <SelectField
              activateRequiredField={this.props.assetTypeError}
              label='Asset Type'
              keyName={'asset_type' + this.props.index}
              options={assetTypes}
              editable={true}
              onChange={this.onChange}
              allowBlank={true}
              value={this.state.asset_type}/>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-md-6'>
            <TextField
              activateRequiredField={this.props.currentBalanceError}
              label='Current Balance'
              keyName={'current_balance' + this.props.index}
              format={this.formatCurrency}
              liveFormat={true}
              editable={true}
              validationTypes={["currency"]}
              maxLength={15}
              onChange={this.onChange}
              value={this.state.current_balance}/>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-md-1'>
            <a className="remove clickable" onClick={this.handleRemove}>
              Remove
            </a>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = Asset;