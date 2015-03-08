var React = require('react/addons');
var AddressField = require('components/form/AddressField');
var Main = React.createClass({
  getInitialState: function() {
    return {};
  },

  onChange: function(change) {
    this.setState(change);
  },

  render: function() {
    var user = this.props.bootstrapData.currentUser;
    return (
      <div>
        <nav className='backgroundDarkBlue typeReversed pvl'>
          <div className='container'>
            <div className='row'>
              <div className='col-md-6'>
                Homieo Logo
              </div>
              <div className='col-md-6 text-right'>
                {user
                ? <span>
                    <span className='mrm'>Hello {user.firstName}!</span>
                    <a href='/logout'>Log out</a>
                  </span>
                : <span>
                    <a href='/login' className='mrm'>
                      Log in
                    </a>
                    <a href='/signup' className='mrm'>
                      Sign up
                    </a>
                  </span>
                }
              </div>
            </div>
          </div>
        </nav>
        <div className='container'>
          <div>
            <AddressField label='Property' address={this.state.address} keyName='address' editable={true} onChange={this.onChange}/>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = Main;
