var _ = require('lodash');
var React = require('react/addons');
var LoanProgramFilterMixin = require('mixins/LoanProgramFilterMixin');

var Filter = React.createClass({
  mixins: [LoanProgramFilterMixin],

  getDefaultProps: function() {
    return {
      productCriteria: [],
      lenderCriteria: [],
      allCriteria: []

    };
  },

  onChangeCriteria: function(option, type) {
    var criteria = type == "product" ? this.props.productCriteria : this.props.lenderCriteria;
    var indexOfOption = criteria.indexOf(option);

    // user has already selected this option
    if(indexOfOption != -1) {
      criteria.splice(indexOfOption, 1);
    }
    else {
      criteria.push(option);
    }
    var filteredPrograms = this.filterPrograms(this.props.programs, this.props.productCriteria, this.props.lenderCriteria);
    this.props.onFilterProgram(filteredPrograms);

    var allCriteria = this.props.allCriteria;
    var indexOfCriteria = allCriteria.indexOf(option);
    if(indexOfCriteria != -1) {
      allCriteria.splice(indexOfCriteria, 1);
    }
    else {
      allCriteria.push(option);
    }
    this.props.storedCriteria(allCriteria);
  },

  isCriteriaChecked: function(option) {
    return (this.props.allCriteria.indexOf(option) !== -1);
  },

  render: function() {
    return (
      <div>
        <div id="sidebar">
            <span>
                <a className="btn btn-mc" data-toggle="modal" data-target="#email_alert">Rate alert</a>


              <div className="modal fade" id="email_alert" tabIndex="-1" role="dialog" aria-labelledby="email_alert_label">
                <div className="modal-dialog modal-md" role="document">
                  <div className="modal-content">
                    <span className="glyphicon glyphicon-remove-sign closeBtn" data-dismiss="modal"></span>
                    <div className="modal-body text-center">
                      <h2>Rate alert</h2>
                      <h3 className="mc-blue-primary-text">Some text here</h3>

                      <form className="form-horizontal">
                        <div className="form-group">
                          <div className="col-md-6">
                            <button type="button" className="btn btn-default" data-dismiss="modal">Cancel</button>
                          </div>
                          <div className="col-md-6">
                            <button type="button" className="btn btn-mc">Send</button>
                          </div>
                        </div>
                      </form>
                    </div>
                  </div>
                </div>
              </div>
            </span>
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
          <input type="checkbox" name="fha" id="fha" checked={this.isCriteriaChecked("FHA")} onChange={_.bind(this.onChangeCriteria, null, "FHA", "product")}/>
          <label className="customCheckbox blueCheckBox2" htmlFor="fha">FHA</label>
          <h5>Wholesale lenders</h5>
          {
            _.map(this.getFeaturedLenders(), function(lender) {
              return(
                <div>
                  <input type="checkbox" name="citibank" id={lender} checked={this.isCriteriaChecked(lender)} onChange={_.bind(this.onChangeCriteria, null, lender, "lender")}/>
                  <label className="customCheckbox blueCheckBox2" htmlFor={lender}>{lender}</label>
                </div>
              )
            }, this)
          }
          <h5>
            <a role="button" data-toggle="collapse" href=".helpme-sidebar-collapse" aria-expanded="true" aria-controls="helpme-sidebar-collapse">
              Show all lenders<span className="glyphicon glyphicon-menu-down"></span>
            </a>
          </h5>
          <div className="collapse helpme-sidebar-collapse">
            {
              _.map(this.getRemainingLenders(), function(lender) {
                return (
                  <div>
                    <input type="checkbox" name="citibank2" id={lender} checked={this.isCriteriaChecked(lender)} onChange={_.bind(this.onChangeCriteria, null, lender, "lender")}/>
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
