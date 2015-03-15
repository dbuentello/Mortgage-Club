var _ = require('lodash');
var React = require('react/addons');
var MainForm = require('./MainForm');

var sideMenuWidth = 250;
var topMenuHeight = 44;

var Container = React.createClass({
  getInitialState: function() {
    return {
      menu: [
        {name: 'Property', complete: false, icon: 'iconHome'},
        {name: 'Borrower', complete: false, icon: 'iconUser'},
        {name: 'Income', complete: false, icon: 'iconMoney'},
        {name: 'Assets and Liabilities', complete: false, icon: 'icon'},
        {name: 'Real Estate', complete: false, icon: 'icon'},
        {name: 'Declarations', complete: false, icon: 'icon'}
      ]
    };
  },

  render: function() {
    return (
      <div>
        <nav className='sticky backgroundLowlight pbm' style={{height: '100%', width: sideMenuWidth, marginTop: topMenuHeight}}>
          {_.map(this.state.menu, function (item, i) {
            return (
              <div className='row'>
                <div key={i} className='col-xs-8 pam bbs'><i className={item.icon + ' mrxs'}/>{item.name}</div>
                {item.complete ?
                  <div className='col-xs-4'><i className=''/></div>
                : null}
              </div>
            );
          }, this)}
        </nav>
        <div style={{marginLeft: sideMenuWidth, paddingTop: topMenuHeight}}>
          <div className='pal'>
            <MainForm/>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = Container;
