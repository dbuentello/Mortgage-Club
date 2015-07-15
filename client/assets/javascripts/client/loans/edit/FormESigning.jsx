var _ = require('lodash');
var React = require('react/addons');

var SelectField = require('components/form/SelectField');

var FormESigning = React.createClass({
  getInitialState: function() {
    return {
      templateName: 'Loan Estimation'
    }
  },

  onClick: function(e) {
    e.preventDefault();

    $.ajax({
      url: "/electronic_signature/demo",
      method: 'POST',
      data: {
        template_name: this.state.templateName
      },
      dataType: 'json',
      success: function(response) {
        // console.log(response);

        if (response.message == "don't render iframe") {
          alert("Okay, done!");
        } else if (response.message == "template does not exist yet") {
          alert(response.details);
        } else {
          $(this.refs.iframe.getDOMNode()).attr("src", response.message.url);
          $(this.refs.iframe.getDOMNode()).css("display", "block");
        }
      }.bind(this),
      error: function(response, status, error) {
        alert(error);
      }
    });
  },

  onChange: function(change) {
    this.setState(change);
  },

  render: function() {
    var templateOptions = [
      {name: 'Loan Estimation', value: 'Loan Estimation'},
      {name: 'Other', value: 'Other'}
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
