/** @jsx React.DOM */

var React = require('react');
var ReactScriptLoader = require('react-script-loader');
var ReactScriptLoaderMixin = ReactScriptLoader.ReactScriptLoaderMixin;

var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;

var StripeCheckbox = React.createClass({
  mixins: [ReactScriptLoaderMixin],
  getInitialState: function() {
    return {
      agree: this.props.agree
    };
  },

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
    this.setState({agree: !this.state.agree});
    if (this.state.agree == false) {
      if (StripeButton.scriptDidError) {
        console.log('failed to load script');
      } else if (StripeButton.stripeHandler) {
        this.showStripeDialog();
      } else {
        this.showLoadingDialog();
        this.hasPendingClick = true;
      }
    }
    this.props.save(!this.state.agree);
  },

  render: function() {
    return (
      <div>
        <input type="checkbox" value="" checked={this.state.agree} onChange={this.onClick}/>
        <label className="customCheckbox blueCheckBox" for="creditcheck">
          I agree to the E-Sign Consent, Information Certification and Authorization Agreement, State Disclosure, Privacy Policy, and Terms of Use.
        </label>
      </div>
    );
  }
});

module.exports = StripeCheckbox;