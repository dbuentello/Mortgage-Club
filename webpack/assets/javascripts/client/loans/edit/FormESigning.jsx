var _ = require('lodash');
var React = require('react/addons');

var FormESigning = React.createClass({
  onClick: function(e) {
    e.preventDefault();

    $.ajax({
      url: "/electronic_signature/demo",
      method: 'POST',
      data: {},
      dataType: 'json',
      success: function(response) {
        console.log(response);

        $(this.refs.iframe.getDOMNode()).attr("src", response.message.url);
        $(this.refs.iframe.getDOMNode()).css("display", "block");
      }.bind(this),
      error: function(response, status, error) {
        alert(error);
      }
    });
  },

  render: function() {
    return (
      <div>
        <div className='iframeContent'>
          <div className='pal'>
            <div className='text-left'>
              <a className='btn btnSml btnPrimary' onClick={this.onClick}>Sign</a>
            </div>

            <div className='mtl text-left'>
              <iframe ref='iframe' height='600px' width='100%' style={{display: 'none'}}></iframe>
            </div>

          </div>
        </div>
      </div>
    );
  }
});

module.exports = FormESigning;
