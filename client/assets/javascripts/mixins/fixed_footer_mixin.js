//TODO: UNUSED CODE
var FixedBottomFooterMixin = {
  componentDidMount: function() {
    this.$header = $('header');
    this.$footer = $('footer');
    this.$window = $(window);
    this.$el = $(this.getDOMNode());
    this.minHeight = this.minHeight || this.$el.outerHeight();
    this.resize();

    this.$window.on('resize.fixedBottomFooter', this.resize);
  },

  componentWillUnmount: function() {
    this.$window.off('resize.fixedBottomFooter', this.resize);
  },

  resize: function() {
    this.$el.height(Math.max(this.minHeight, this.$window.height() - this.$header.outerHeight() - this.$footer.outerHeight() + 2));
  }
};

module.exports = FixedBottomFooterMixin;
