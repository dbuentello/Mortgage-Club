var _ = require('lodash');
var React = require('react/addons');

var Property = require('./FormProperty');
var Borrower = require('./FormBorrower');
var Income = require('./FormIncome/FormIncome');
var AssetsAndLiabilities = require('./FormAssetsAndLiabilities/FormAssetsAndLiabilities');
var Declarations = require('./FormDeclarations');
var CreditCheck = require('./FormCreditCheck');
var Documents = require('./FormDocuments');

var LoanInterface = React.createClass({
  getInitialState: function() {
    var loan = this.props.bootstrapData.currentLoan;
    var borrower_type = this.props.bootstrapData.borrower_type;
    var menu = this.buildMenu(loan);

    return {
      menu: menu,
      active: _.findWhere(menu, {complete: false}) || menu[0],
      loan: loan,
      borrower_type: borrower_type
    };
  },

  render: function() {
    var activeItem = this.state.active;

    var content = <activeItem.Content bootstrapData={this.props.bootstrapData} loan={this.state.loan} borrower_type={this.state.borrower_type} saveLoan={this.save} setupMenu={this.setupMenu}/>;

    return (
      <div>
        <nav className='sideMenu sticky backgroundLowlight pbm brs'>
          {_.map(this.state.menu, function (item, i) {
            return (
              <div key={i} id={"tab"+item.name} className={'row pam bbs man ' + (item.name === activeItem.name ? 'backgroundBlue typeReversed' : 'clickable')} onClick={_.bind(this.goToItem, this, item)}>
                <div className='col-xs-9 pan'><i className={item.icon + ' mrxs'}/><span className='h5 typeDeemphasize'>{item.name}</span></div>
                {item.complete ?
                  <div className='col-xs-3 pan text-right typeReversed'><i className='icon iconCheck paxs bas circle xsm backgroundGreen'/></div>
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
    // this.autosave(this.props.bootstrapData.currentLoan, this.state.active.step);
    this.setState({active: item});
  },

  buildMenu: function(loan) {
    var menu = [
      {name: 'Property', complete: loan.property_completed, icon: 'iconHome', step: 0, Content: Property},
      {name: 'Borrower', complete: loan.borrower_completed, icon: 'iconUser', step: 1, Content: Borrower},
      {name: 'Documents', complete: loan.documents_completed, icon: 'iconTicket', step: 2, Content: Documents},
      {name: 'Income', complete: loan.income_completed, icon: 'iconTicket', step: 3, Content: Income},
      {name: 'Credit Check', complete: loan.credit_completed, icon: 'iconCreditCard', step: 4, Content: CreditCheck},
      {name: 'Assets and Liabilities', complete: loan.assets_completed, icon: 'iconVcard', step: 5, Content: AssetsAndLiabilities},
      {name: 'Declarations', complete: loan.declarations_completed, icon: 'iconClipboard', step: 6, Content: Declarations},
    ];
    return menu;
  },

  setupMenu: function(response, step, skip_change_page) {
    var menu = this.buildMenu(response.loan);
    this.setState({
      loan: response.loan,
      menu: menu
    });

    skip_change_page = (typeof skip_change_page !== 'undefined') ? true : false;
    if (skip_change_page) {
      // TODO: identify what it does when reset active state
      this.setState({
        active: menu[step]
      });
    } else {
      this.setState({
        active: menu[step + 1] || menu[0]
      });
    }
  },

  save: function(loan, step, skip_change_page, last_step = false) {
    $.ajax({
      url: '/loans/' + this.state.loan.id,
      method: 'PATCH',
      context: this,
      dataType: 'json',
      data: {
        loan: loan,
        current_step: step
      },
      success: function(response) {
        if (last_step == false) {
          this.setupMenu(response, step, skip_change_page);
        } else {
          location.href = '/underwriting?loan_id=' + this.state.loan.id;
          // location.href = '/rates?loan_id=' + this.state.loan.id;
        }
      },
      error: function(response, status, error) {
        alert(error);
      }
    });
  },

  autosave: function(loan, step) {
    $.ajax({
      url: '/loans/' + this.state.loan.id,
      method: 'PATCH',
      context: this,
      dataType: 'json',
      data: {
        loan: loan,
        current_step: step
      },
      success: function(response) {
        // do something else
      },
      error: function(response, status, error) {
        // do something else
      }
    });
  }
});

module.exports = LoanInterface;
