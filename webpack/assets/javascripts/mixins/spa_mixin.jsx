/**
 * Reusable methods for setting up single page apps.
 * This mixin would make use of the following objects defined as member variables in your component:
 * `_Routes`  (required): for the app component to instantiate a backbone router
 * `_Header`  (optional): to render the common header component
 * `_SideNav` (optional): to render the common side navigation (on mobile)
 * `_Footer`  (optional): to render the common footer component
 *
 * This is also designed to work with the mobile nav in our style guide, but it will also work without it.
 * @see http://flexport.github.io/oocss/docs/mobile.html#sideNav
 *
 * ###Example:
 * ```
 * // pages should be populated by the associated page components of your app to each route.
 * var pages = {...};
 * window.MyApp = React.createClass({
 *   mixins: [SPAMixin],
 *   render: function() {
 *     var Page = pages[this.state.route];
 *     return this.renderApp(<Page/>);
 *   },
 *
 *   // read-only
 *   _Routes:  require('my_app/constants/RouteConstants),
 *   _Header:  require('my_app/components/nav/Header'),
 *   _SideNav: require('my_app/components/nav/SideNav'),
 *   _Footer:  require('my_app/components/nav/Footer'),
 * });
 * ```
 *
 * @type {React.Mixin}
 */
var SPAMixin = {

  initRouter: function() {
    // To maintain your components as a single page app, we will need to define new routes in route.rb
    // as well as in the RouteConstants file associated to your SPA.
    var routes = {};
    _.each(this._Routes, function (route) {
      routes[Routes[route + '_path']({id: ':id'}).replace(/^\/+/, '')] = route;
    });

    var Router = Backbone.Router.extend({ routes: routes });

    this.router = new Router();
    this.router.on('route', this.onRouteChange);

    // Backbone requires jQuery. So to avoid including jquery twice on the page,
    // resolve the dependency here with jQuery object from the global scope.
    Backbone.$ = $;
    Backbone.history.start({
      pushState: true,
      silent: true
    });
  },

  getInitialState: function() {
    return {
      route: this.props.route,
      hideNav: true,
      navOn: false
    };
  },

  renderApp: function(page) {
    var Header = this._Header;
    var SideNav = this._SideNav;
    var Footer = this._Footer;

    return (
      <div className={'mNavBody' + (this.state.navOn ? ' navOn' : '')}>
        {!SideNav ? null :
          <SideNav ref='sideNav' hideNav={this.state.hideNav}/>
        }

        <div className='mPageContainer animate animateFast'>
          {!Header ? null :
            <Header data={this.props} navOn={this.state.navOn} toggleNav={this.toggleNav} route={this.state.route}/>
          }

          {page}

          <div className="mPageCover overlay overlayFull zIndexPageOverlay" onTouchStart={this.toggleNav}></div>

          {!Footer ? null :
            <Footer data={this.props} route={this.state.route}/>
          }
        </div>
      </div>
    );
  },

  componentWillMount: function() {
    React.initializeTouchEvents(true);
  },

  interceptAnchorClick: function() {
    var touchable = 'ontouchstart' in document.documentElement;
    var clickEvent = touchable ? 'touchend' : 'click';
    var self = this;
    var dragging = false;

    if (touchable) {
      // detect dragging on touch devices
      $('body')
        .on('touchmove', function() { dragging = true; })
        .on('touchstart', function() { dragging = false; });
    }

    $(this.getDOMNode()).on(clickEvent, 'a', function (event) {
      var href = $(this).attr('href'),
          action;

      if (dragging) {
        // on touch devices, when user is dragging we don't want to do anything
        // with this touch target.
        event.preventDefault();
        return;
      }

      if (typeof href == 'undefined' || href === null) {
        return;
      }

      // Only intercept left-clicks
      if (event.which === 2 || event.which === 3 || event.shiftKey || event.altKey || event.metaKey || event.ctrlKey) {
        return;
      }

      // clean leading/trailing slashes
      href = href.replace(/^\/+/, '').replace(/\/+$/, '');

      // clean hashes
      action =  href.replace(/#(.*)$/, '');

      // only handle click if href contains backbone history root
      _.each(_.pluck(Backbone.history.handlers, 'route'), function (route) {
        if (route.test(action)) {
          if (self.state.navOn){
            self.toggleNav();
          }

          // triggering this namespaced event in case we need to watch for universal
          // page changing/closing/refreshing somewhere in the app.
          $(window).triggerHandler('beforeunload.' + self.state.route);

          event.preventDefault();
          Backbone.history.navigate(href, {trigger: true});
          window.scrollTo(0, 0);
          event.target.blur();
        }
      });

    });
  },

  toggleNav: function() {
    var transitionendEvent = 'webkitTransitionEnd transitionend msTransitionEnd oTransitionEnd',
        self = this;

    if (!this.$chatBtn || this.$chatBtn.length < 1) {
      this.$chatBtn = $('.-snapengage-tab');
    }

    // make sure to show the nav first before any transition
    this.setState({ hideNav: false });

    setTimeout(function() {
      self.$chatBtn.toggleClass('hideFully', !self.state.navOn);
      self.setState({ navOn: !self.state.navOn });
    }, 100);

    if (this.$nav) {
      this.$nav.one(transitionendEvent, function() {
        self.$nav.off(transitionendEvent);
        self.setState({ hideNav: !self.state.navOn });
      });
    }
  },

  componentWillUnmount: function() {
    this.router.off('route', this.onRouteChange);
  },

  componentDidMount: function() {
    // cache the jQuery object for better performance
    if (this.refs.sideNav) {
      this.$nav = $(this.refs.sideNav.getDOMNode());
    }

    this.interceptAnchorClick();
    this.initRouter();
  },

  onRouteChange: function(route) {
    this.setState({route: route}, function() {
      if (typeof this.track == 'function') {
        this.track();
      }
    });
  }
};

module.exports = SPAMixin;
