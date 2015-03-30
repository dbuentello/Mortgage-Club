var _ = require('lodash');
var React = require('react/addons');
var AddressField = require('components/form/AddressField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');

var Router = require('react-router');
var { Route, RouteHandler, Link } = Router;

var FormDeclarations = React.createClass({
  render: function() {
    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mtn'>

            </div>
            <div className='box text-right'>
              <Link to='rates' className='btn btnSml btnPrimary'>Next</Link>
            </div>
          </div>
        </div>
        <div className='helpSection sticky pull-right overlayRight overlayTop'>
        </div>
      </div>
    );
  }
});

module.exports = FormDeclarations;
