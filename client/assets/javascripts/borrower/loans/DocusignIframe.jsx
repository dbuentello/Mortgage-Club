var _ = require('lodash');
var React = require('react/addons');
var clock;

var DocusignIframe = React.createClass({
  propTypes: {
    docusignLoaded: React.PropTypes.bool
  },

  getInitialState: function() {
    return {
      docusignLoaded: false,
      percentage: 0,
    }
  },

  componentDidMount: function() {
    clock = window.setInterval(this.incrementPercentage, 60);
    $.ajax({
      url: "/electronic_signature",
      method: 'POST',
      data: {
        id: this.props.bootstrapData.loan.id,
        fees: this.props.bootstrapData.rate.fees,
        lender: {
          lender_name: this.props.bootstrapData.rate.lender_name,
          lender_nmls_id: this.props.bootstrapData.rate.nmls,
          interest_rate: this.props.bootstrapData.rate.interest_rate,
          period:  this.props.bootstrapData.rate.period,
          amortization_type: this.props.bootstrapData.rate.product,
          monthly_payment: this.props.bootstrapData.rate.monthly_payment,
          apr: this.props.bootstrapData.rate.apr,
          loan_type: this.props.bootstrapData.rate.loan_type,
          total_closing_cost: this.props.bootstrapData.rate.total_closing_cost
        }
      },
      dataType: 'json',
      success: function(response) {
        window.clearInterval(clock);
        var height = $("body").height() - $(".navbar").height() - $(".footer").height();
        this.setState({docusignLoaded: true});

        if(height > 600){
          $(this.refs.iframe.getDOMNode()).height(height + "px");
        }

        $(this.refs.iframe.getDOMNode()).attr("src", response.message.url);
        $(this.refs.iframe.getDOMNode()).css("display", "block");

      }.bind(this),
      error: function(response, status, error) {
        this.setState({docusignLoaded: true});
      }
    });
  },

  incrementPercentage: function() {
    var counter = this.state.percentage + 1;
    this.setState({
      percentage: counter
    });
    document.getElementById('percent').innerHTML = counter + '%';
    if(counter == 100) {
      window.clearInterval(clock);
    }
  },

  render: function() {
    return (
      <div className='content container iframeContentFull' id='docusign'>
        {
          this.state.docusignLoaded
          ?
            null
          :
            <div className='row'>
              <div className='col-xs-4'>
                <div id='percent'>0%</div>
              </div>
              <div className='col-xs-8'>
                <div id='status'>{"Hang tight, we're generating disclosure forms for you to sign!"}</div>
              </div>
            </div>
        }
        <div>
          <iframe ref='iframe' height='600px' width='100%' style={{display: 'none'}}></iframe>
        </div>
      </div>
    )
  }
});

module.exports = DocusignIframe;