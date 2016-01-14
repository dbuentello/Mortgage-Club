var _ = require("lodash");
var React = require("react/addons");

var Property = require("./FormProperty");
var Borrower = require("./FormBorrower/Form");
var Income = require("./FormIncome/Form");
var AssetsAndLiabilities = require("./FormAssetsAndLiabilities/FormAssetsAndLiabilities");
var Declarations = require("./FormDeclarations");
var CreditCheck = require("./FormCreditCheck");
var Documents = require("./FormDocuments");
var CheckCompletedLoanMixin = require('mixins/CheckCompletedLoanMixin');

var LoanInterface = React.createClass({
  mixins: [CheckCompletedLoanMixin],
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
      <div className="content accountPart editLoan">
        <div className="container">
          <div className="row">
            <div className="col-xs-3 subnav">
              <div id="sidebar">
                <ul>
                  {_.map(this.state.menu, function (item, i) {

                    return (
                      <li key={i} id={"tab"+item.name} className={this.getKlassNameLiSidebar(item, activeItem)}>
                        <a href="javascript:void(0)" onClick={_.bind(this.goToItem, this, item)}>
                          <img src={item.iconSrc} alt={item.name}>{item.name}</img>
                          <span className="done-sign glyphicon glyphicon-ok"></span>
                        </a>
                      </li>
                    );
                  }, this)}
                </ul>
              </div>
              <div className="swipe-area">
                <a href="#" data-toggle=".subnav" id="sidebar-toggle">
                  <span className="glyphicon glyphicon-arrow-right"></span>
                </a>
              </div>
            </div>
            {content}
          </div>
        </div>
      </div>
    );
  },

  goToItem: function(item) {
    // this.autosave(this.props.bootstrapData.currentLoan, this.state.active.step);
    this.setState({active: item});
  },

  buildMenu: function(loan) {
    var menu = [
      {name: "Property", complete: loan.property_completed, iconSrc: "/icons/property.png", step: 0, Content: Property},
      {name: "Borrower", complete: loan.borrower_completed, iconSrc: "/icons/borrower.png", step: 1, Content: Borrower},
      {name: "Documents", complete: loan.documents_completed, iconSrc: "/icons/description.png", step: 2, Content: Documents},
      {name: "Income", complete: loan.income_completed, iconSrc: "/icons/income.png", step: 3, Content: Income},
      {name: "Credit Check", complete: loan.credit_completed, iconSrc: "/icons/creditcheck.png", step: 4, Content: CreditCheck},
      {name: "Assets and Liabilities", complete: loan.assets_completed, iconSrc: "/icons/assets.png", step: 5, Content: AssetsAndLiabilities},
      {name: "Declarations", complete: loan.declarations_completed, iconSrc: "/icons/declarations.png", step: 6, Content: Declarations},
    ];
    return menu;
  },

  setupMenu: function(response, step, skip_change_page) {
    var menu = this.buildMenu(response.loan);
    this.setState({
      loan: response.loan,
      menu: menu
    });

    skip_change_page = (typeof skip_change_page !== "undefined") ? true : false;
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
      url: "/loans/" + this.state.loan.id,
      method: "PATCH",
      context: this,
      dataType: "json",
      data: {
        loan: loan,
        current_step: step
      },
      success: function(response) {
        if (this.loanIsCompleted(response.loan)) {
          this.goToAllDonePage();
        }
        else {
          if (last_step == false) {
            this.setupMenu(response, step, skip_change_page);
          } else {
            var menu = this.buildMenu(response.loan);
            var uncompleted_step = _.findWhere(menu, {complete: false});

            if (uncompleted_step) {
              this.setState({
                loan: response.loan,
                menu: menu,
                active: uncompleted_step
              });
            }
          }
        }
      },
      error: function(response, status, error) {
        alert(error);
      }
    });
  },

  autosave: function(loan, step) {
    $.ajax({
      url: "/loans/" + this.state.loan.id,
      method: "PATCH",
      context: this,
      dataType: "json",
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
  },

  getKlassNameLiSidebar: function(item, activeItem) {
    var klassName = item.complete ? "done" : "";
    if (item.name === activeItem.name) {
      klassName += " active";
    }
    return klassName;
  }
});

module.exports = LoanInterface;
