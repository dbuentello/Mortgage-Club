var _ = require('lodash');
var React = require('react/addons');
var TextField = require("components/form/NewTextField");

var LoanProgramFilterMixin = require('mixins/LoanProgramFilterMixin');
var ValidationObject = require("mixins/FormValidationMixin");
var RateAlert = require("./RateAlert");

var pc_alert_fields = {
  firstName: {label: "First name", name: "pc_first_name", keyName: "pc_first_name", error: "pcFirstNameError",validationTypes: "empty"},
  lastName: {label: "Last name", name: "pc_last_name", keyName: "pc_last_name", error: "pcLastNameError",validationTypes: "empty"},
  email: {label: "Email", name: "pc_email", keyName: "pc_email", error: "pcEmailError", validationTypes: "email"}
};

var Filter = React.createClass({
    mixins: [LoanProgramFilterMixin, ValidationObject],
    getInitialState: function() {
      var state = {};
      state.isValid = true;
      state.saving = false;
      state.dataCookies = this.props.dataCookies;

      return state;
    },
    getDefaultProps: function() {
        return {productCriteria: [], lenderCriteria: [], cashOutCriteria: [], downPaymentCriteria: [], allCriteria: []};
    },
    onChangeCriteria: function(option, type) {
        var criteria;
        if(type == "product"){
          criteria = this.props.productCriteria;
        }
        else{
          if(type == "lender"){
            criteria = this.props.lenderCriteria;
          }else{
            if(type == "downPayment"){
              criteria = this.props.downPaymentCriteria;
            }else{
              criteria = this.props.cashOutCriteria;
            }
          }
        }

        var indexOfOption = criteria.indexOf(option);

        // user has already selected this option
        if (indexOfOption != -1) {
            criteria.splice(indexOfOption, 1);
        } else {
            criteria.push(option);
        }
        var filteredPrograms = this.filterPrograms(this.props.programs, this.props.productCriteria, this.props.lenderCriteria, this.props.cashOutCriteria, this.props.downPaymentCriteria);
        this.props.onFilterProgram(filteredPrograms);

        var allCriteria = this.props.allCriteria;
        var indexOfCriteria = allCriteria.indexOf(option);
        if (indexOfCriteria != -1) {
            allCriteria.splice(indexOfCriteria, 1);
        } else {
            allCriteria.push(option);
        }
        this.props.storedCriteria(allCriteria);
    },

    isCriteriaChecked: function(option) {
        return (this.props.allCriteria.indexOf(option) !== -1);
    },
    onChange: function (change) {
      this.setState(change);
    },
    onBlur: function(blur) {
      this.setState(blur);
    },
    render: function() {
        return (
            <div>
                <div id="sidebar" className="filter-sidebar">
                  {
                    this.props.rate_alert ?
                      <div>
                        <a data-toggle="modal" href="" data-target="#email_alert1" style={{fontSize: 17}}> Create a rate alert </a>
                        <RateAlert code_id={this.props.code_id} fields={pc_alert_fields} index={1}/>
                      </div>
                    :
                      null
                  }
                    <h5>Programs</h5>
                    <input type="checkbox" name="30years" id="30years" checked={this.isCriteriaChecked("30 year fixed")} onChange={_.bind(this.onChangeCriteria, null, "30 year fixed", "product")}/>
                    <label className="customCheckbox blueCheckBox2" htmlFor="30years">30 year fixed</label>
                    <br/>
                    <input type="checkbox" name="15years" id="15years" checked={this.isCriteriaChecked("15 year fixed")} onChange={_.bind(this.onChangeCriteria, null, "15 year fixed", "product")}/>
                    <label className="customCheckbox blueCheckBox2" htmlFor="15years">15 year fixed</label>
                    <br/>
                    <input type="checkbox" name="71arm" id="71arm" checked={this.isCriteriaChecked("7/1 ARM")} onChange={_.bind(this.onChangeCriteria, null, "7/1 ARM", "product")}/>
                    <label className="customCheckbox blueCheckBox2" htmlFor="71arm">7/1 ARM</label>
                    <br/>
                    <input type="checkbox" name="51arm" id="51arm" checked={this.isCriteriaChecked("5/1 ARM")} onChange={_.bind(this.onChangeCriteria, null, "5/1 ARM", "product")}/>
                    <label className="customCheckbox blueCheckBox2" htmlFor="51arm">5/1 ARM</label>
                    <br/>
                    {
                      this.state.dataCookies !== undefined && this.state.dataCookies.mortgage_purpose === "refinance"
                      ?
                        <div>
                          <h5>Cash out</h5>
                          {_.map(this.getFeaturedCashOuts(), function(cashout) {
                              return (
                                <div>
                                  <input type="checkbox" id={cashout.name} checked={this.isCriteriaChecked(cashout.value)} onChange={_.bind(this.onChangeCriteria, null, cashout.value, "cashout")}/>
                                  <label className="customCheckbox blueCheckBox2" htmlFor={cashout.name}>{cashout.name}</label>
                                </div>
                              )
                            }, this)
                          }
                        </div>
                      :
                        null
                    }
                    {
                      this.state.dataCookies !== undefined && this.state.dataCookies.mortgage_purpose === "purchase"
                      ?
                        <div>
                          <h5>Down payment</h5>
                          {_.map(this.getFeaturedDownPayments(), function(downPayment) {
                              return (
                                <div>
                                  <input type="checkbox" id={downPayment.name} checked={this.isCriteriaChecked(downPayment.value)} onChange={_.bind(this.onChangeCriteria, null, downPayment.value, "downPayment")}/>
                                  <label className="customCheckbox blueCheckBox2" htmlFor={downPayment.name}>{downPayment.name}</label>
                                </div>
                              )
                            }, this)
                          }
                        </div>
                      :
                        null
                    }
                    <h5>Wholesale lenders</h5>
                    {_.map(this.getFeaturedLenders(), function(lender) {
                        return (
                          <div>
                            <input type="checkbox" name="citibank" id={lender} checked={this.isCriteriaChecked(lender)} onChange={_.bind(this.onChangeCriteria, null, lender, "lender")}/>
                            <label className="customCheckbox blueCheckBox2" htmlFor={lender}>{lender}</label>
                          </div>
                        )
                      }, this)
                    }
                    <div className="collapse helpme-sidebar-collapse">
                        {_.map(this.getRemainingLenders(), function(lender) {
                            return (
                                <div>
                                    <input type="checkbox" id={lender} checked={this.isCriteriaChecked(lender)} onChange={_.bind(this.onChangeCriteria, null, lender, "lender")}/>
                                    <label className="customCheckbox blueCheckBox2" htmlFor={lender}>{lender}</label>
                                </div>
                              )
                            }, this)
                        }
                    </div>
                    {
                      this.getRemainingLenders().length > 0 ?
                      <h5>
                        <a role="button" data-toggle="collapse" href=".helpme-sidebar-collapse" aria-expanded="true" aria-controls="helpme-sidebar-collapse">
                          Show all lenders<span className="glyphicon glyphicon-menu-down"></span>
                        </a>
                      </h5>
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
        )
    },
    getFeaturedLenders: function() {
        var featuredLenders = [];
        var sortedPrograms = _.sortBy(this.props.programs, function(program) {
            return parseFloat(program.apr);
        });

        _.each(sortedPrograms, function(program) {
            if (featuredLenders.indexOf(program.lender_name) == -1) {
                featuredLenders.push(program.lender_name);
            }

            if (featuredLenders.length > 2) {
                return false;
            }
        })

        return featuredLenders;
    },

    getFeaturedCashOuts: function() {
        var featuredCashOuts = [];
        var noCashOutProgram = _.find(this.props.programs, function(program){ return program.is_cash_out == false; });
        var cashOutProgram = _.find(this.props.programs, function(program){ return program.is_cash_out == true; });

        var loanAmount = noCashOutProgram == undefined ? 0 : noCashOutProgram.loan_amount;
        var loanToValue = noCashOutProgram == undefined ? 0 : noCashOutProgram.loan_to_value;

        featuredCashOuts.push({name: "No Cash Out (" + loanToValue + "% LTV)", value: loanToValue});

        if (loanToValue < 80 && this.state.dataCookies.property_usage == "primary_residence"){
          featuredCashOuts.push({name: "$" + ((cashOutProgram.property_value * 0.8 - loanAmount) / 1000).toFixed(0) + "k (" + 80 + "% LTV)", value: 80});
        }
        if (loanToValue < 75){
          featuredCashOuts.push({name: "$" + ((cashOutProgram.property_value * 0.75 - loanAmount) / 1000).toFixed(0) + "k (" + 75 + "% LTV)", value: 75});
        }
        if (loanToValue < 70){
          featuredCashOuts.push({name: "$" + ((cashOutProgram.property_value * 0.7 - loanAmount) / 1000).toFixed(0) + "k (" + 70 + "% LTV)", value: 70});
        }
        return featuredCashOuts;
    },

    getFeaturedDownPayments: function() {
        var featuredDownPayments = [];
        var noDownPaymentProgram = _.find(this.props.programs, function(program){ return program.is_down_payment == false; });
        var loanToValue = noDownPaymentProgram.loan_to_value;
        var downPayment = 100 - loanToValue;

        featuredDownPayments.push({name: "$" + ((noDownPaymentProgram.property_value - noDownPaymentProgram.loan_amount) / 1000).toFixed(0) + "k (" + loanToValue + "% LTV)", value: loanToValue});

        if(this.state.dataCookies.property_usage == "primary_residence"){
          if (downPayment > 20){
            featuredDownPayments.push({name: "$" + (noDownPaymentProgram.property_value * 20 / 100000).toFixed(0) + "k (" + 80 + "% LTV)", value: 80});
          }
          if (downPayment > 10){
            featuredDownPayments.push({name: "$" + (noDownPaymentProgram.property_value * 10 / 100000).toFixed(0) + "k (" + 90 + "% LTV)", value: 90});
          }
          if (downPayment > 5){
            featuredDownPayments.push({name: "$" + (noDownPaymentProgram.property_value * 5 / 100000).toFixed(0) + "k (" + 95 + "% LTV)", value: 95});
          }
        }else{
          if (downPayment > 25){
            featuredDownPayments.push({name: "$" + (noDownPaymentProgram.property_value * 25 / 100000).toFixed(0) + "k (" + 75 + "% LTV)", value: 75});
          }
          if (downPayment > 20){
            featuredDownPayments.push({name: "$" + (noDownPaymentProgram.property_value * 20 / 100000).toFixed(0) + "k (" + 80 + "% LTV)", value: 80});
          }
        }

        return featuredDownPayments;
    },
    getRemainingLenders: function() {
        return _.difference(this.getAllLenders(), this.getFeaturedLenders());
    },
    getAllLenders: function() {
        var lenders = [];
        var uniqueLenders = [];

        _.each(this.props.programs, function(program) {
            lenders.push(program.lender_name);
        })

        _.each(lenders, function(lender) {
            if (uniqueLenders.indexOf(lender) == -1) {
                uniqueLenders.push(lender);
            }
        })

        return uniqueLenders;
    }
})
module.exports = Filter;
