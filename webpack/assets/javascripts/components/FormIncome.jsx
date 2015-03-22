var _ = require('lodash');
var React = require('react/addons');
var AddressField = require('components/form/AddressField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');

var FormIncome = React.createClass({
  render: function() {
    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mtn'>

            </div>
            <div className='box text-right'>
              <a className='btn btnSml btnPrimary'>Next</a>
            </div>
          </div>
        </div>
        <div className='helpSection sticky pull-right overlayRight overlayTop'>
        </div>
      </div>
    );
  }
});

module.exports = FormIncome;
