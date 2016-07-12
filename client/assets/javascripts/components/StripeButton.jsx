/**
 * TODO: UNUSED CODE, related to StripeCheckbox
 */
var React = require('react');
var ReactScriptLoader = require('react-script-loader');
var ReactScriptLoaderMixin = ReactScriptLoader.ReactScriptLoaderMixin;

var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;

var StripeButton = React.createClass({
  mixins: [ReactScriptLoaderMixin],
  getScriptURL: function() {
    return 'https://checkout.stripe.com/checkout.js';
  },

  statics: {
    stripeHandler: null,
    scriptDidError: false,
  },

  // Indicates if the user has clicked on the button before the
  // the script has loaded.
  hasPendingClick: false,

  onScriptLoaded: function() {
    // Initialize the Stripe handler on the first onScriptLoaded call.
    // This handler is shared by all StripeButtons on the page.
    if (!StripeButton.stripeHandler) {
      StripeButton.stripeHandler = StripeCheckout.configure({
        key: 'pk_test_QTE3dyoEJ6fx7D0hBHbCswF2',
        // image: '/YOUR_LOGO_IMAGE.png',
        token: function(token) {
          // Use the token to create the charge with a server-side script.
          $.ajax({
            url: '/charges',
            method: 'POST',
            data: {
              stripeToken: token
            },
            dataType: 'json',
            success: function(response) {
              alert(response.message);
            }.bind(this),
            error: function(error) {
              alert(error);
            }
          });
        }
      });
      if (this.hasPendingClick) {
        this.showStripeDialog();
      }
    }
  },

  showLoadingDialog: function() {
    // show a loading dialog
  },

  hideLoadingDialog: function() {
    // hide the loading dialog
  },

  showStripeDialog: function() {
    this.hideLoadingDialog();
    StripeButton.stripeHandler.open({
      name: 'Demo Site',
      description: '2 widgets ($20.00)',
      amount: 2000
    });
  },

  onScriptError: function() {
    this.hideLoadingDialog();
    StripeButton.scriptDidError = true;
  },

  onClick: function() {
    if (StripeButton.scriptDidError) {
      console.log('failed to load script');
    } else if (StripeButton.stripeHandler) {
      this.showStripeDialog();
    } else {
      this.showLoadingDialog();
      this.hasPendingClick = true;
    }
  },

  render: function() {
    return (
      <div>
        <button onClick={this.onClick} className='btn btnSml btnAction'>Pay with Card</button>
      </div>
    );
  }
});

module.exports = StripeButton;
