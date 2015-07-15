/**
 * ### StickyHeaderMixin
 * This provides the ground work to make an element stick on top
 * as user scrolls down the page. It also takes into account the top navigation bar.
 * Here is an example of how to use it:
 *
 *  ```
 *  render: function () {
 *    var headerClass = 'row backgroundLightYellow mhn pvs bbs';
 *    if (this.state.isSticky) { headerClass += ' sticky zIndexFloater'; }
 *    return (
 *      <div className='pan'>
 *        <div ref='stickyEl' className={headerClass}
 *             style={{top: this.navHeight, width: this.state.isSticky ? this.stickyElWidth : null}}>
 *          Your sticky header content...
 *        </div>
 *        <div className='pam' style={{marginTop: this.state.isSticky ? this.stickyElHeight : null}}>
 *          Main content
 *        </div>
 *      </div>
 *    );
 *  }
 *  ```
 */
var StickyHeaderMixin = {
  getInitialState: function() {
    return {isSticky: false};
  },

  componentDidMount: function() {
    this.$stickyEl = $(this.refs.stickyEl.getDOMNode());
    this.$container = this.$stickyEl.parent();
    this.navHeight = $('header .navbar').outerHeight();
    this.breakPoint = this.$container.offset().top - this.navHeight;
    this.stickyElWidth = this.$stickyEl.outerWidth();
    this.stickyElHeight = this.$stickyEl.outerHeight();

    this.makeItStick();
    $(window).on('scroll.stickyHeader', this.makeItStick);
  },

  componentWillUnmount: function() {
    $(window).off('scroll.stickyHeader');
  },

  makeItStick: function() {
    var isSticky = this.breakPoint <= $(window).scrollTop();

    if (isSticky !== this.state.isSticky) {
      this.setState({
        isSticky: isSticky
      });
    }
  }
};

module.exports = StickyHeaderMixin;
