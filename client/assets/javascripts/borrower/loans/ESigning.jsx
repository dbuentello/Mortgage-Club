var _ = require('lodash');
var React = require('react/addons');

var SelectField = require('components/form/SelectField');

var ESigning = React.createClass({
  getInitialState: function() {
    return {
      loaded: false
    }
  },

  onChange: function(change) {
    this.setState(change);
  },

  componentDidMount: function() {
    $.ajax({
      url: "/electronic_signature",
      method: 'POST',
      data: {
        id: this.props.bootstrapData.loan.id
      },
      dataType: 'json',
      success: function(response) {
        $(this.refs.iframe.getDOMNode()).attr("src", response.message.url);
        $(this.refs.iframe.getDOMNode()).css("display", "block");
        this.setState({loaded: true});
      }.bind(this),
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.message };
        this.showFlashes(flash);
        this.setState({loaded: true});
      }
    });
  },

  render: function() {
    return (
      <div>
        <div className='iframeContent'>
          <div className='pal'>
            <div className='row'>
              <div className='col-xs-3'>
                <h4 style={{display: this.state.loaded ? 'none' : null}}>Loading...please wait</h4>
              </div>
            </div>

            <br/>
            <div className='mtl text-left'>
              <iframe ref='iframe' height='600px' width='100%' style={{display: 'none'}}></iframe>
            </div>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = ESigning;
