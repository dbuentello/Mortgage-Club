var React = require('react/addons');
var TextField = require('components/form/TextField');
var SelectField = require('components/form/SelectField');

var TextFormatMixin = require('mixins/TextFormatMixin');

var assetTypes = [
  {value: 'checkings', name: 'Checkings'},
  {value: 'savings', name: 'Savings'},
  {value: 'investment', name: 'Investment'},
  {value: 'retirement', name: 'Retirement'},
  {value: 'other', name: 'Other'}
];

var Asset = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function () {
    return {
      institution_name: this.props.asset.institution_name,
      asset_type: this.props.asset.asset_type,
      current_balance: this.props.asset.current_balance
    };
  },

  onChange: function (change) {
    this.setState(change, function(){
      this.props.onUpdate(this.props.index, this.state);
    });
  },

  handleRemove: function(){
    this.props.onRemove(this.props.index);
  },

  render: function () {
    return (
      <div className='box mtn mbm pam bas roundedCorners'>
        <div className='row'>
          <div className='col-xs-6'>
            <TextField
              label='Institution Name'
              keyName={'institution_name'}
              editable={true}
              onChange={this.onChange}
              value={this.state.institution_name}/>
          </div>
        </div>
        <div className='row'>
          <div className='col-xs-6'>
            <SelectField
              label='Asset Type'
              keyName={'asset_type'}
              options={assetTypes}
              editable={true}
              onChange={this.onChange}
              allowBlank={true}
              value={this.state.asset_type}/>
          </div>
        </div>
        <div className='row'>
          <div className='col-xs-6'>
            <TextField
              label='Current Balance'
              keyName={'current_balance'}
              format={this.formatCurrency}
              liveFormat={true}
              editable={true}
              onChange={this.onChange}
              value={this.state.current_balance}/>
          </div>
        </div>
        <div className='box text-right col-xs-6'>
          <a className="remove clickable" onClick={this.handleRemove}>
            Remove
          </a>
        </div>
      </div>
    );
  }
});

module.exports = Asset;