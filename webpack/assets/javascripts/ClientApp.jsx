var React = require('react/addons');
var Container = require('./components/Container');
var AppStarter = require('./tools/AppStarter');
var $ = require('jquery');

window.ClientApp = React.createClass({
  render: function() {
    var user = this.props.currentUser;
    return (
      <div>
        <nav className='sticky backgroundInverse pvm zIndexNavigation overlayFullWidth'>
          <div className='plm prl'>
            <div className='row'>
              <div className='col-xs-6 typeLowlight'>
                Homieo Logo
              </div>
              <div className='col-xs-6 text-right'>
                {user
                ? <span>
                    <span className='typeLowlight mrm'>Hello {user.firstName}!</span>
                    <a className='linkTypeReversed' href='/logout'>Log out</a>
                  </span>
                : <span>
                    <a className='linkTypeReversed mrm' href='/login'>
                      Log in
                    </a>
                    <a className='linkTypeReversed mrm' href='/signup'>
                      Sign up
                    </a>
                  </span>
                }
              </div>
            </div>
          </div>
        </nav>
        <Container bootstrapData={this.props}/>
      </div>
    );
  }
});

$(function() {
  AppStarter.start();
});

