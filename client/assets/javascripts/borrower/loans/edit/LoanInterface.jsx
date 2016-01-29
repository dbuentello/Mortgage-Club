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
      borrower_type: borrower_type,
      completedLoan: this.loanIsCompleted(loan),
    };
  },

  render: function() {
    var activeItem = this.state.active;

    var content = <activeItem.Content bootstrapData={this.props.bootstrapData} loan={this.state.loan} borrower_type={this.state.borrower_type} saveLoan={this.save} setupMenu={this.setupMenu} goToAllDonePage={this.goToAllDonePage} updateDocuments={this.updateDocuments}/>;

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
      {name: "Property", complete: TabProperty.propertyCompleted(loan), iconSrc: "/icons/property.png", step: 0, Content: Property},
      {name: "Borrower", complete: TabBorrower.completed(loan), iconSrc: "/icons/borrower.png", step: 1, Content: Borrower},
      {name: "Documents", complete: TabDocuments.documentsCompleted(loan), iconSrc: "/icons/description.png", step: 2, Content: Documents},
      {name: "Income", complete: TabIncome.incomeCompleted(loan), iconSrc: "/icons/income.png", step: 3, Content: Income},
      {name: "Credit Check", complete: true, iconSrc: "/icons/creditcheck.png", step: 4, Content: CreditCheck},
      {name: "Assets and Liabilities", complete: TabAsset.assetCompleted(loan), iconSrc: "/icons/assets.png", step: 5, Content: AssetsAndLiabilities},
      {name: "Declarations", complete: TabDeclaration.declarationCompleted(loan), iconSrc: "/icons/declarations.png", step: 6, Content: Declarations},
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
