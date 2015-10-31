var _ = require('lodash');
var React = require('react/addons');

var DocusignIframe = React.createClass({
  propTypes: {
    docusignLoaded: React.PropTypes.bool
  },

  getInitialState: function() {
    return {
      docusignLoaded: false
    }
  },

  componentDidMount: function() {
    $.ajax({
      url: "/electronic_signature",
      method: 'POST',
      data: {
        id: this.props.bootstrapData.loan.id,
        fees: {
          appraisal_fee: this.props.bootstrapData.rate.fees["Appraisal fee"],
          credit_report_fee: this.props.bootstrapData.rate.fees["Credit report fee"],
          origination_fee: this.props.bootstrapData.rate.fees["Loan origination fee"],
        },
        lender: {
          name: this.props.bootstrapData.rate.lender_name,
          lender_nmls_id: this.props.bootstrapData.rate.nmls,
          interest_rate: this.props.bootstrapData.rate.interest_rate,
          period:  this.props.bootstrapData.rate.period,
          amortization_type: this.props.bootstrapData.rate.product,
          monthly_payment: this.props.bootstrapData.rate.monthly_payment,
          apr: this.props.bootstrapData.rate.apr
        }
      },
      dataType: 'json',
      success: function(response) {
        $(this.refs.iframe.getDOMNode()).attr("src", response.message.url);
        $(this.refs.iframe.getDOMNode()).css("display", "block");
        this.setState({docusignLoaded: true});
      }.bind(this),
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.message };
        this.showFlashes(flash);
        this.setState({docusignLoaded: true});
      }
    });
  },

  render: function() {
    return (
      <div className='content container iframeContentFull'>
        <div className='pal'>
          <div className='row'>
            <div className='col-xs-3'>
              <h5 style={{display: this.state.docusignLoaded ? 'none' : null}}>Loading...please wait</h5>
            </div>
          </div>
          <br/>
          <div className='mtl text-left'>
            <iframe ref='iframe' height='600px' width='100%' style={{display: 'none'}}></iframe>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = DocusignIframe;