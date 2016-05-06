var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");

var AddressField = require("components/Form/NewAddressField");



var Form = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {

    var loan = this.props.loan;
    var property = this.props.property;
    var addressId = this.props.address ? this.props.address.id : null;
    var address = this.props.address;
    var fieldLength = this.props.loanWritableAttributes.length;
    var loanFieldState = new Array(fieldLength);
    loanFieldState.fill(false, 0, fieldLength);
    var state = loan;
    var property_state = property;
    var property_id = property_state.id;

    delete property_state["id"];

    state = _.extend(state, property_state);
    var address_state = address;
    var address_id = address_state.id;
    delete address_state["id"];
    state = _.extend(state, address_state)
    state = _.extend(state, { editMode: false, loanFieldState: loanFieldState,
          address_id: address_id,
          property_id: property_id
        });
    return state;
  },


  onChange: function(change) {
    this.setState(change);
  },

  onPropertyChange: function(change) {
    // var property = this.state.property
    this.setState({property: change})
  },


  handleShowFields: function(event) {
    event.preventDefault();
    var selectedIndex = event.target.selectedIndex
    var loanFieldState = this.state.loanFieldState;
    loanFieldState[selectedIndex] = true;
    this.setState({loanFieldState: loanFieldState});
  },


  handleSubmitForm: function(event) {
    event.preventDefault();
    var loanData = $('.loan_term_form').serialize();
    debugger
    $.ajax({
      url: "/loan_members/loans/"+this.props.loan.id+"/update_loan_terms",
      method: "PUT",
      dataType: "json",
      data: loanData,
      success: function(data) {
        this.setState({editMode: false, loan: data.loan, property: data.property, address: data.address})
      }.bind(this),
      error: function(errorCode){
        console.log(errorCode);
      }
    });


  },
  onAddressChange: function(change) {
    var address = change.address;
    if(address) {
      this.setState({zip: address.zip, state: address.state, city: address.city, street_address: address.street_address, street_address2: address.street_address2})
    }
  },

  render: function() {
    var property = this.props.property;
    var restLoanFields  = this.props.loanWritableAttributes;
    var MakeItem = function(X, index) {
        return <option value={X}>{X}</option>;
    };
     var restLoanFields  = this.props.loanWritableAttributes;
    var MakeItem = function(X, index) {
        return <option value={X}>{X}</option>;
    };

    var RenderLoanField = function(X) {
      return (
        <div className='form-group'>
          <label> {X} </label>
          <input name={X} value={this.state[X]}/>
        </div>
      );
    }.bind(this);

    return (
        <div className="panel panel-flat terms-view">
          <div>



            <div>
              <form className="form-horizontal loan_term_form">
                <div className='form-group'>
                  <input type="hidden" name="property[id]" value={this.props.property_id}/>

                  <div className="col-sm-8">
                    <label className="col-xs-12 pan">


                      <AddressField label="address"
                        address={this.state.address}
                        keyName="address"
                        editable={true}
                        onChange={this.onChange}/>


                    </label>

                    <input type="hidden" name="address[id]" value={this.props.address.id}/>
                    <input type="hidden" name="address[zip]" value={this.state.zip}/>
                    <input type="hidden" name="address[city]" value={this.state.city}/>
                    <input type="hidden" name="address[street_address]" value={this.state.street_address}/>
                    <input type="hidden" name="address[street_address2]" value={this.state.street_address2}/>
                    <input type="hidden" name="address[state]" value={this.state.state}/>
                  </div>
                </div>

                <div className='form-group'>
                  <div className='col-sm-4'>
                    <label> Loan Type </label>
                    <input name="loan[amortization_type]" />
                  </div>
                </div>

                <div className='form-group'>
                  <div className='col-sm-4'>
                    <label> Property Value </label>
                    <input name="property[market_price]" />
                  </div>
                </div>

                <div className='form-group'>
                  <div className='col-sm-4'>
                    <label>Interest Rate</label>
                    <input name="loan[interest_rate]" onChange={this.onChange} />
                  </div>
                </div>

                <div className='form-group'>
                  <div className='col-sm-4'>
                    <label> Lender Credits </label>
                    <input name="loan[lender_credits]" value={this.state.lender_credits} onChange={this.onChange}/>
                  </div>
                </div>

                <div className='form-group'>
                  <div className='col-sm-4'>
                    <label>Loan Costs</label>
                    <input name="loan[costs]" value={this.state.costs} onChange={this.onChange} />
                  </div>
                </div>

                <div className='form-group'>
                  <div className='col-sm-4'>
                    <label> Third Party Fees </label>
                    <input name="loan[third_party_fees] value={this.state.third_party_fees}" onChange={this.onChange}/>

                  </div>
                </div>




                <div className="row">
                  <h4 className="terms-4-loan-members"> Housing Expense</h4>
                </div>

                <div className='form-group'>
                  <div className='col-sm-4'>
                    <label>Principal and Interest</label>
                    <input name="loan[monthly_payment]"/>
                  </div>
                </div>

                <div className='form-group'>
                  <div className='col-sm-4'>
                    <label> Homeowners Insurance </label>
                    <input name="property[estimated_hazard_insurance]" />
                  </div>
                </div>

                <div className='form-group'>
                  <div className='col-sm-4'>
                    <label> Property Tax </label>
                    <input name="property[estimated_property_tax]" />

                  </div>
                </div>

                <div className='form-group'>
                  <div className='col-sm-4'>
                    <label> Mortgage Insurance </label>
                    <input name="property[estimated_mortgage_insurance]" />
                  </div>
                </div>

                <div className='form-group'>
                  <div className='col-sm-4'>
                    <label> Hoa DUE</label>
                    <input name="property[hoa_due]"/>
                  </div>
                </div>
                {
                  _.map(restLoanFields, function(X, index) {
                    if(this.state.loanFieldState[index] === true){
                      return RenderLoanField(X)
                    }
                  }.bind(this))
                }
                <div className="row">
                  <div className='col-sm-4'>
                    <select onChange={this.handleShowFields}>{restLoanFields.map(MakeItem)}</select>
                  </div>

                </div>
                <div className="row">
                  <div className="col-md-12">
                    <button className="btn btn-primary pull-right" id="submit_form" onClick={this.handleSubmitForm}>Save</button>
                  </div>
                </div>
                </form>
            </div>

          </div>
        </div>
      );
  }
});

module.exports = Form;