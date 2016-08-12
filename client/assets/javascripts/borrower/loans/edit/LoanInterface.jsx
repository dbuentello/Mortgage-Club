var _ = require("lodash");
var React = require("react/addons");

var Property = require("./FormProperty");
var Borrower = require("./FormBorrower/Form");
var Income = require("./FormIncome/Form");
var AssetsAndLiabilities = require("./FormAssetsAndLiabilities/FormAssetsAndLiabilities");
var Declarations = require("./FormDeclarations");
var CreditCheck = require("./FormCreditCheck");
var Documents = require("./FormDocuments");
var AllDonePage = require("./AllDonePage");
var CheckCompletedLoanMixin = require('mixins/CheckCompletedLoanMixin');

var TabProperty = require('mixins/CompletedLoanMixins/TabProperty');
var TabBorrower = require('mixins/CompletedLoanMixins/TabBorrower');
var TabDeclaration = require('mixins/CompletedLoanMixins/TabDeclaration');
var TabDocuments = require('mixins/CompletedLoanMixins/TabDocuments');
var TabIncome = require('mixins/CompletedLoanMixins/TabIncome');
var TabAsset = require('mixins/CompletedLoanMixins/TabAsset');
var TabCreditCheck = require('mixins/CompletedLoanMixins/TabCreditCheck');

var LoanInterface = React.createClass({
  mixins: [CheckCompletedLoanMixin],

  getInitialState: function() {
    var loan = this.props.bootstrapData.currentLoan;
    var borrower_type = this.props.bootstrapData.borrower_type;
    var liabilities = this.props.bootstrapData.liabilities;
    var menu = this.buildMenu(loan);
    var activeItem = _.findWhere(menu, {complete: false}) || menu[0];

    return {
      menu: menu,
      active: activeItem,
      loan: loan,
      borrower_type: borrower_type,
      liabilities: liabilities,
      completedLoan: this.loanIsCompleted(loan),
      is_edit_mode: this.props.bootstrapData.is_edit_mode
    };
  },

  render: function() {
    var activeItem = this.state.active;

    var content = <activeItem.Content bootstrapData={this.props.bootstrapData} editMode={this.state.is_edit_mode} loan={this.state.loan} liabilities={this.state.liabilities} borrower_type={this.state.borrower_type} saveLoan={this.save} next={this.next} setupMenu={this.setupMenu} goToAllDonePage={this.goToAllDonePage} updateDocuments={this.updateDocuments}/>;

    return (
      <div className="content accountPart editLoan">
        <div className="container-fluid">
          <div className="row">
            <div className="col-sm-3 hidden-xs hidden-sm subnav">
              <div id="sidebar">
                <ul>
                  {_.map(this.state.menu, function (item, i) {
                    return (
                      <li key={i} id={item.key} className={this.getKlassNameLiSidebar(item, activeItem)}>
                        <a href="javascript:void(0)" onClick={_.bind(this.goToItem, this, item)}>
                          <span><i className={item.iconClass}></i>{item.name}</span>
                          <span className="done-sign glyphicon glyphicon-ok"></span>
                        </a>
                      </li>
                    );
                  }, this)}
                </ul>
                {
                  this.state.loan.lender_name
                  ?
                  <div id={"summary"}>
                    <p>Summary</p>
                    <table>
        <tr>
          <th></th>
          <th></th>
        </tr>
        <tr>
          <td>Lender</td>
          <td>{this.state.loan.lender_name}</td>
        </tr>
        <tr>
          <td>Loan type</td>
          <td>{this.state.loan.amortization_type}</td>
        </tr>
        <tr>
          <td>Propertye value</td>
          {
            this.state.loan.purpose == "purchase"
            ?
            <td>{this.state.loan.subject_property.purchase_price}</td>
            :
            <td>{this.state.loan.subject_property.original_purchase_price}</td>

          }

        </tr>
        <tr>
          <td>Loan amount</td>
          <td>{this.state.loan.amount}</td>
        </tr>
        <tr>
          <td>Rate</td>
          <td>{this.state.loan.interest_rate}</td>
        </tr>
      </table>
    </div>
                  :
                  null
                }

              </div>

              <div className="swipe-area">
                <a href="#" data-toggle=".subnav" id="sidebar-toggle">
                  <span className="glyphicon glyphicon-arrow-right"></span>
                </a>
              </div>
            </div>
            <div className="col-sm-12 visible-xs visible-sm subnav" style={{"height": "54px"}}>
              <div id="sidebar-mobile">
                <ul>
                  {_.map(this.state.menu, function (item, i) {
                    return (
                      <li key={i} id={item.key} className={this.getKlassNameLiSidebar(item, activeItem)}>
                        <a href="javascript:void(0)" onClick={_.bind(this.goToItem, this, item)}>
                          <span className={item.iconClass}></span>
                        </a>
                      </li>
                    );
                  }, this)}
                </ul>
              </div>
            </div>
            {
              this.state.completedLoan
              ?
                <AllDonePage loan={this.state.loan}/>
              :
                {content}
            }
          </div>
        </div>
      </div>
    );
  },

  updateDocuments: function(typeBorrower, typeDocument, typeAction, taxJointly, name, id){
    var loan = this.state.loan;
    var borrower = typeBorrower === "borrower" ? loan.borrower : loan.secondary_borrower;

    //remove 'co_' of type document co-borrower
    if(typeBorrower === "coborrower")
      typeDocument = typeDocument.substring(3);

    if(borrower !== undefined){
      //get index file
      var index = $.map(borrower.documents, function(document, index) {
        if(document.document_type === typeDocument) {
            return index;
        }
      });

      if(index.length > 0)
      {
        if(typeAction === "remove"){
          borrower.documents.splice(index[0], 1);
        }else{
          borrower.documents[index[0]].original_filename = name;
          borrower.documents[index[0]].id = id;
        }

        if(typeBorrower === "borrower")
          loan.borrower = borrower;
        else
          loan.secondary_borrower = borrower;

        loan.borrower.is_file_taxes_jointly = taxJointly;
        this.setState({loan: loan});
      }else{
        if(typeAction === "upload"){
          var document = {
            document_type: typeDocument,
            original_filename: name,
            id: id
          }

          borrower.documents.push(document);

          if(typeBorrower === "borrower")
            loan.borrower = borrower;
          else
            loan.secondary_borrower = borrower;

          loan.borrower.is_file_taxes_jointly = taxJointly;
          this.setState({loan: loan});
        }
      }
    }
  },

  goToItem: function(item) {
    var menu = this.buildMenu(this.state.loan);
    // this.autosave(this.props.bootstrapData.currentLoan, this.state.active.step);
    this.setState({active: item, completedLoan: false, menu: menu});
  },

  buildMenu: function(loan) {
    var menu = [
      {name: "Property", complete: TabProperty.propertyCompleted(loan), key: "tabProperty", iconClass: "fa fa-home", step: 0, Content: Property},
      {name: "Borrower", complete: TabBorrower.completed(loan), key: "tabBorrower", iconClass: "fa fa-user", step: 1, Content: Borrower},
      {name: "Documents", complete: TabDocuments.documentsCompleted(loan), key: "TabDocuments", iconClass: "fa fa-file-text", step: 2, Content: Documents},
      {name: "Income", complete: TabIncome.incomeCompleted(loan), key: "tabIncome", iconClass: "fa fa-database", step: 3, Content: Income},
      {name: "Credit Check", complete: TabCreditCheck.creditCheckCompleted(loan), key: "tabCreditCheck", iconClass: "fa fa-credit-card-alt", step: 4, Content: CreditCheck},
      {name: "Assets and Liabilities", complete: TabAsset.assetCompleted(loan), key: "tabAssetsAndLiabilities", iconClass: "fa fa-bar-chart", step: 5, Content: AssetsAndLiabilities},
      {name: "Declarations", complete: TabDeclaration.completed(loan), key: "tabDeclarations", iconClass: "fa fa-list-alt", step: 6, Content: Declarations},
    ];
    return menu;
  },

  setupMenu: function(response, step, skip_change_page) {
    var menu = this.buildMenu(response.loan);

    this.setState({
      loan: response.loan,
      menu: menu
    });

    // get new liabilities from BorrowerController
    if (response.liabilities) {
      this.setState({
        liabilities: response.liabilities
      });
    }

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
  componentDidMount: function(){
    this.setState({completedLoan: false});
  },

  goToAllDonePage: function(loan) {
    this.setState({menu: this.buildMenu(loan), completedLoan: true, loan: loan});
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
          this.goToAllDonePage(response.loan);
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
                active: uncompleted_step,
                completedLoan: false
              });
            }
          }
        }
      }.bind(this),
      error: function(response, status, error) {
        alert(error);
      }
    });
  },
  next: function(step, last_step){
    if(last_step === true)
      location.href = "/my/dashboard/" + this.state.loan.id;

    this.setState({
      active: this.state.menu[step]
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
