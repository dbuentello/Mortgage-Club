var React = require("react/addons");
var TextField = require("components/form/TextField");

var RateForm = React.createClass({
   getInitialState: function() {
    var homepage_rate = this.props.bootstrapData.homepage_rate;

    return {
      id: homepage_rate.id,
      lender_name: homepage_rate.lender_name,
      rate_value: homepage_rate.rate_value,
      program: homepage_rate.program,
      saving: false
    }
  },

  onChange: function(change) {
    this.setState(change);
  },

  handleSubmit: function(event) {
    $.ajax({
        url: "/homepage_rates/" + this.state.id,
        type: "PUT",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify(this.state),
        success: function(resp) {
          location.href = "/homepage_rates";
        },
        error: function(resp) {
          var flash = { "alert-danger": resp.responseJSON.message };
          this.setState({saving: false});
        }.bind(this)
    });
    event.preventDefault();
  },

  render: function(){
    return (
      <div className="content container">
      <div className="pal">
        <div className="row">
          <h2 className="mbl">Edit Homepage Rate</h2>

          <form className="form-horizontal form-homepage-rates" onSubmit={this.handleSubmit}>

            <div className="form-group">
                <div className="col-sm-2">
                  <TextField
                    label="Lender Name"
                    keyName="lender_name"
                    value={this.state.lender_name}
                    editable={true}
                    onChange={this.onChange}/>
                </div>
                <div className="col-sm-2">
                  <TextField
                    label="Program"
                    keyName="program"
                    value={this.state.program}
                    editable={true}
                    onChange={this.onChange}/>
                </div>
                <div className="col-sm-2">
                  <TextField
                    label="Rate Value"
                    keyName="rate_value"
                    value={this.state.contact_phone}
                    editable={true}
                    onChange={this.onChange}/>
                </div>
              </div>
            <button className="btn btn-primary btn-sm">Save</button> &nbsp;
          </form>
      </div>
      </div>
      </div>
    );
  }
})
module.exports = RateForm;
