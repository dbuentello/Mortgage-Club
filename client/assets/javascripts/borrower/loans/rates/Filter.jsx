var _ = require('lodash');
var React = require('react/addons');
var LoanProgramFilterMixin = require('mixins/LoanProgramFilterMixin');

var Filter = React.createClass({
  mixins: [LoanProgramFilterMixin],

  getDefaultProps: function() {
    return {
      productCriteria: [],
      lenderCriteria: []
    };
  },

  onChangeCriteria: function(option, type) {
    var criteria = type == "product" ? this.props.productCriteria : this.props.lenderCriteria;
    // user has already selected this option
    if(criteria.indexOf(option) != -1) {
      criteria.splice(option, 1);
    }
    else {
      criteria.push(option);
    }
    var filteredPrograms = this.filterPrograms(this.props.programs, this.props.productCriteria, this.props.lenderCriteria);
    this.props.onFilterProgram(filteredPrograms);
  },

  render: function() {
    return (
      <div>
        <div id="sidebar">
          <h5>Programs</h5>
          <input type="checkbox" name="30years" id="30years" onChange={_.bind(this.onChangeCriteria, null, "30 year fixed", "product")}/>
          <label className="customCheckbox blueCheckBox2" htmlFor="30years">30 year fixed</label>
          <br/>
          <input type="checkbox" name="15years" id="15years" onChange={_.bind(this.onChangeCriteria, null, "15 year fixed", "product")}/>
          <label className="customCheckbox blueCheckBox2" htmlFor="15years">15 year fixed</label>
          <br/>
          <input type="checkbox" name="71arm" id="71arm" onChange={_.bind(this.onChangeCriteria, null, "7/1 ARM", "product")}/>
          <label className="customCheckbox blueCheckBox2" htmlFor="71arm">7/1 ARM</label>
          <br/>
          <input type="checkbox" name="51arm" id="51arm" onChange={_.bind(this.onChangeCriteria, null, "5/1 ARM", "product")}/>
          <label className="customCheckbox blueCheckBox2" htmlFor="51arm">5/1 ARM</label>
          <br/>
          <input type="checkbox" name="fha" id="fha" onChange={_.bind(this.onChangeCriteria, null, "FHA", "product")}/>
          <label className="customCheckbox blueCheckBox2" htmlFor="fha">FHA</label>
          <h5>Lenders</h5>
          {
            _.map(this.getFeaturedLenders(), function(lender) {
              return(
                <div>
                  <input type="checkbox" name="citibank" id={lender} onChange={_.bind(this.onChangeCriteria, null, lender, "lender")}/>
                  <label className="customCheckbox blueCheckBox2" htmlFor={lender}>{lender}</label>
                </div>
              )
            }, this)
          }
          <h5>
            <a role="button" data-toggle="collapse" href="#helpme-sidebar-collapse" aria-expanded="false" aria-controls="helpme-sidebar-collapse">
              Show all providers<span className="glyphicon glyphicon-menu-down"></span>
            </a>
          </h5>
          <div className="collapse" id="helpme-sidebar-collapse">
            {
              _.map(this.getRemainingLenders(), function(lender) {
                return (
                  <div>
                    <input type="checkbox" name="citibank2" id={lender} onChange={_.bind(this.onChangeCriteria, null, lender, "lender")}/>
                    <label className="customCheckbox blueCheckBox2" htmlFor={lender}>{lender}</label>
                  </div>
                )
              }, this)
            }
          </div>
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
    var sortedPrograms = _.sortBy(this.props.programs, function (program) {
      return parseFloat(program.apr);
    });

    _.each(sortedPrograms, function(program) {
      if(featuredLenders.indexOf(program.lender_name) == -1) {
        featuredLenders.push(program.lender_name);
      }

      if(featuredLenders.length > 2) { return false; }
    })

    return featuredLenders;
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
      if(uniqueLenders.indexOf(lender) == -1) {
        uniqueLenders.push(lender);
      }
    })

    return uniqueLenders;
  }
})

module.exports = Filter;