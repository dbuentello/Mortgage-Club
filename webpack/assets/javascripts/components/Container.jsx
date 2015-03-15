var _ = require('lodash');
var React = require('react/addons');
var Property = require('./FormProperty');
var Borrower = require('./FormBorrower');
var Income = require('./FormIncome');
var AssetsAndLiabilities = require('./FormAssetsAndLiabilities');
var RealEstates = require('./FormRealEstates');
var Declarations = require('./FormDeclarations');

var sideMenuWidth = 250;
var topMenuHeight = 44;

var Container = React.createClass({
  getInitialState: function() {
    return {
      menu: [
        {name: 'Property', complete: false, icon: 'iconHome', Content: Property},
        {name: 'Borrower', complete: false, icon: 'iconUser', Content: Borrower},
        {name: 'Income', complete: false, icon: 'iconTicket', Content: Income},
        {name: 'Assets and Liabilities', complete: false, icon: 'iconVcard', Content: AssetsAndLiabilities},
        {name: 'Real Estates', complete: false, icon: 'iconHome', Content: RealEstates},
        {name: 'Declarations', complete: false, icon: 'iconClipboard', Content: Declarations}
      ],
      active: 'Property'
    };
  },

  render: function() {
    var activeItem = _.findWhere(this.state.menu, {name: this.state.active});
    var content = <activeItem.Content/>;
    return (
      <div>
        <nav className='sticky backgroundLowlight pbm' style={{height: '100%', width: sideMenuWidth, marginTop: topMenuHeight}}>
          {_.map(this.state.menu, function (item, i) {
            return (
              <div className={'row pam bbs man ' + (item.name === activeItem.name ? 'backgroundBlue typeReversed' : 'clickable')} onClick={_.bind(this.goToItem, this, item)}>
                <div key={i} className='col-xs-9 pan'><i className={item.icon + ' mrxs'}/><span className='h5 typeDeemphasize'>{item.name}</span></div>
                {item.complete ?
                  <div className='col-xs-3 pan'><i className='iconCheck'/></div>
                : null}
              </div>
            );
          }, this)}
        </nav>
        <div style={{marginLeft: sideMenuWidth, paddingTop: topMenuHeight}}>
          <div className='pal'>
            {content}
          </div>
        </div>
      </div>
    );
  },

  goToItem: function(item) {
    this.setState({
      active: item.name
    });
  }
});

module.exports = Container;
