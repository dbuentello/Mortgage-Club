var _ = require('lodash');
var React = require('react/addons');
var Property = require('./FormProperty');
var Borrower = require('./FormBorrower');
var Income = require('./FormIncome');
var AssetsAndLiabilities = require('./FormAssetsAndLiabilities');
var RealEstates = require('./FormRealEstates');
var Declarations = require('./FormDeclarations');

var LoanInterface = React.createClass({
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
      active: 'Property',
      loan: this.props.bootstrapData.currentLoan
    };
  },

  render: function() {
    var activeItem = _.findWhere(this.state.menu, {name: this.state.active});
    var content = <activeItem.Content bootstrapData={this.props.bootstrapData} loan={this.state.loan} saveLoan={this.save}/>;
    return (
      <div>
        <nav className='sideMenu sticky backgroundLowlight pbm'>
          {_.map(this.state.menu, function (item, i) {
            return (
              <div key={i} className={'row pam bbs man ' + (item.name === activeItem.name ? 'backgroundBlue typeReversed' : 'clickable')} onClick={_.bind(this.goToItem, this, item)}>
                <div className='col-xs-9 pan'><i className={item.icon + ' mrxs'}/><span className='h5 typeDeemphasize'>{item.name}</span></div>
                {item.complete ?
                  <div className='col-xs-3 pan'><i className='iconCheck'/></div>
                : null}
              </div>
            );
          }, this)}
        </nav>
        {content}
      </div>
    );
  },

  goToItem: function(item) {
    this.setState({
      active: item.name
    });
  },

  save: function(loan) {
    $.ajax({
      url: '/loans/' + this.state.loan.id,
      method: 'PATCH',
      context: this,
      dataType: 'json',
      data: {loan: loan},
      success: function(response) {
        this.setState({loan: response.loan});
      },
      error: function(response, status, error) {

      }
    });
  }
});

module.exports = LoanInterface;
