var _ = require('lodash');
var React = require('react/addons');
var Navigation = require('react-router').Navigation;

var LoaderMixin = require('mixins/LoaderMixin');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var MortgageCalculatorMixin = require('mixins/MortgageCalculatorMixin');
var List = require('./List');
var HelpMeChoose = require('./HelpMeChoose');

var MortgageRates = React.createClass({
  mixins: [LoaderMixin, ObjectHelperMixin, TextFormatMixin, Navigation, MortgageCalculatorMixin],

  getInitialState: function() {
    return {
      rates: this.props.bootstrapData.programs,
      possibleRates: null,
      bestRate: null,
      helpMeChoose: false,
      signDoc: false,
      selectedRate: null
    }
  },

  choosePossibleRates: function(periods, avgRate, taxRate) {
    var totalCost = 0;
    var result;
    var possibleRates = _.sortBy(this.state.rates, function (rate) {
      result = this.totalCost(rate, taxRate, avgRate, periods);
      rate['total_cost'] = result['totalCost'];
      rate['result'] = result;
      return rate['total_cost'];
    }.bind(this));

    possibleRates = possibleRates.slice(0, 3);

    this.setState({
      possibleRates: possibleRates,
      bestRate: possibleRates[0],
      helpMeChoose: true
    });
  },

  selectRate: function(rate) {
    this.setState({
      signDoc: true,
      selectedRate: rate
    });
    var params = {};
    params["rate"] = rate;
    params = $.param(params);
    location.href = "esigning/" + this.props.bootstrapData.currentLoan.id + "?" + params;
  },

  helpMeChoose: function() {
    this.setState({helpMeChoose: !this.state.helpMeChoose});
  },
  handleSortChange: function(event) {
    this.sortBy($("#sortRateOptions").val());
  },

  render: function() {
    // don't want to make ugly code
    var guaranteeMessage = "We're showing the best 3 loan options for you";
    var subjectProperty = this.props.bootstrapData.currentLoan.subject_property;

    return (
      <div className="content">
        <div className='content container mortgage-rates'>
          <div className="col-xs-4 subnav">
            <div id="sidebar">
              <h5>Programs</h5>
              <input type="checkbox" name="30years" id="30years" />
              <label className="customCheckbox blueCheckBox2" for="30years">30 years fixed</label>
              <p>asdfasdg</p>
              <input type="checkbox" name="15years" id="15years" />
              <label className="customCheckbox blueCheckBox2" for="15years">15 years fixed</label>
              <input type="checkbox" name="71arm" id="71arm" />
              <label className="customCheckbox blueCheckBox2" for="71arm">7/1 ARM</label>
              <input type="checkbox" name="51arm" id="51arm" />
              <label className="customCheckbox blueCheckBox2" for="51arm">5/1 ARM</label>
              <input type="checkbox" name="fha" id="fha" />
              <label className="customCheckbox blueCheckBox2" for="fha">FHA</label>

              <h5>Lenders</h5>
              <input type="checkbox" name="citibank" id="citibank"/>
              <label className="customCheckbox blueCheckBox2" for="citibank">Citibank</label>
              <input type="checkbox" name="eRates" id="eRates"/>
              <label className="customCheckbox blueCheckBox2" for="eRates">eRates Mortgage</label>
              <input type="checkbox" name="firstInternetBank" id="firstInternetBank"/>
              <label className="customCheckbox blueCheckBox2" for="firstInternetBank">First Internet Bank</label>
              <input type="checkbox" name="WellsFargo" id="WellsFargo"/>
              <label className="customCheckbox blueCheckBox2" for="WellsFargo">Wells Fargo</label>

              <h5>
                <a role="button" data-toggle="collapse" href="#helpme-sidebar-collapse" aria-expanded="false" aria-controls="helpme-sidebar-collapse">
                  Show all providers<span className="glyphicon glyphicon-menu-down"></span>
                </a>
              </h5>
              <div className="collapse" id="helpme-sidebar-collapse">
                <input type="checkbox" name="citibank2" id="citibank2"/>
                <label className="customCheckbox blueCheckBox2" for="citibank2">Citibank</label>
                <input type="checkbox" name="eRates2" id="eRates2"/>
                <label className="customCheckbox blueCheckBox2" for="eRates2">eRates Mortgage</label>
                <input type="checkbox" name="firstInternetBank2" id="firstInternetBank2"/>
                <label className="customCheckbox blueCheckBox2" for="firstInternetBank2">First Internet Bank</label>
                <input type="checkbox" name="WellsFargo2" id="WellsFargo2"/>
                <label className="customCheckbox blueCheckBox2" for="WellsFargo2">Wells Fargo</label>
              </div>
            </div>
            <div className="swipe-area">
              <a href="#" data-toggle=".subnav" id="sidebar-toggle">
                <span className="glyphicon glyphicon-arrow-right"></span>
              </a>
            </div>

          </div>

          <div className="col-xs-8 account-content">
            <p>
              We’ve found 829 mortgage options for you. You can sort, filter, and choose one on your own or click
              <span className="italic-light">Help me choose</span>
              and our proprietary selection algorithm will help you choose the best mortgage. No fees no costs option is also included in
              <span className="italic-light">Help me choose</span>.
            </p>
            <div className="row form-group" id="mortgageActions">
              <div className="col-md-6">
                <div className="row">
                  <div className="col-xs-3">
                    <label>Sort by</label>
                  </div>

                  <div className="col-xs-9 select-box">
                    <select className="form-control" id="sortRateOptions" onChange={this.handleSortChange}>
                      <option value="apr">APR</option>
                      <option value="pmt">Monthly Payment</option>
                      <option value="rate">Rate</option>
                    </select>
                    <img className="dropdownArrow" src="/icons/dropdownArrow.png" alt="arrow"/>
                  </div>
                </div>
              </div>
              <div className="col-md-6 text-right">
                <a className="btn choose-btn text-uppercase" onClick={this.helpMeChoose}>help me choose</a>
              </div>
            </div>
            <div id="mortgagePrograms">
              { this.state.helpMeChoose
                ?
                  <List rates={this.state.possibleRates} subjectProperty={subjectProperty} selectRate={this.selectRate} displayTotalCost={true}/>
                :
                  <List programs={this.state.rates} subjectProperty={subjectProperty} selectRate={this.selectRate} displayTotalCost={false}/>
              }

            </div>
          </div>

          { this.state.helpMeChoose
            ?
              <HelpMeChoose choosePossibleRates={this.choosePossibleRates} helpMeChoose={this.helpMeChoose} bestRate={this.state.bestRate} selectRate={this.selectRate}/>
            :
            null
          }
          <div className='row mtl'>
            { this.state.helpMeChoose
              ?
                <HelpMeChoose choosePossibleRates={this.choosePossibleRates} helpMeChoose={this.helpMeChoose} bestRate={this.state.bestRate} selectRate={this.selectRate}/>
              :
              null
            }
          </div>
        </div>
      </div>
    );
  },

  sortBy: function(field) {
    if (field == 'apr') {
      var sortedRates = _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.apr);
      });
    } else if (field == 'pmt') {
      var sortedRates = _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.monthly_payment);
      });
    } else if (field == 'rate') {
      var sortedRates = _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.interest_rate);
      });
    }

    // console.dir(this.state.helpMeChoose);
    this.setState({rates: sortedRates});
  }
});

module.exports = MortgageRates;
