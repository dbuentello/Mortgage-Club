var _ = require('lodash');
var React = require('react/addons');

var SelectField = require('components/form/SelectField');

var FormESigning = React.createClass({
  getInitialState: function() {
    return {
      templateName: 'Loan Estimate'
    }
  },

  onClick: function(e) {
    e.preventDefault();
    $(this.refs.btnSign.getDOMNode()).button('loading')
    $.ajax({
      url: "/electronic_signature/template/",
      method: 'POST',
      data: {
        template_name: this.state.templateName,
        id: this.props.loan.id
      },
      dataType: 'json',
      success: function(response) {
        if (response.message == "don't render iframe") {
          alert("Okay, done!");
        } else if (response.message == "template does not exist yet") {
          alert(response.details);
        } else {
          $(this.refs.iframe.getDOMNode()).attr("src", response.message.url);
          $(this.refs.iframe.getDOMNode()).css("display", "block");
        }
        $(this.refs.btnSign.getDOMNode()).button('reset');
      }.bind(this),
      error: function(response, status, error) {
        $(this.refs.btnSign.getDOMNode()).button('reset');
        alert(error);
      }
    });
  },

  onChange: function(change) {
    this.setState(change);
  },

  render: function() {
    var templateOptions = [
      {name: 'Loan Estimate', value: 'Loan Estimate'},
      {name: 'Servicing Disclosure', value: 'Servicing Disclosure'}
    ];

    return (
      <div>
        <div className='iframeContent'>
          <div className='pal'>
            <div className='row'>
              <div className='col-xs-3'>
                <SelectField
                  label='Choose an template to sign'
                  keyName={'templateName'}
                  value={this.state.templateName}
                  options={templateOptions}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
            </div>

            <br/>
            <div className='text-left'>
              <a ref='btnSign' className='btn btnSml btnPrimary' onClick={this.onClick} data-loading-text="Loading...">
                Sign
              </a>
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
