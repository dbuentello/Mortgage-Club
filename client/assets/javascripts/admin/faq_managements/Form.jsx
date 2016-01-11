var _ = require('lodash');
var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');
var TextField = require('components/form/TextField');
var ModalLink = require('components/ModalLink');
var TextEditor = require('components/TextEditor');

var Form = React.createClass({
  mixins: [FlashHandler],

  propTypes: {
    method: React.PropTypes.string,
    url: React.PropTypes.string,
    onReloadTable: React.PropTypes.func,
  },

  getDefaultProps: function() {
    return {
      method: 'POST',
      url: '',
      onReloadTable: null
    };
  },

  getInitialState: function() {
    if(this.props.Faq) {
      return {
        question: this.props.Faq.question,
        answer: this.props.Faq.answer,
      };
    }else {
      return {
        answer: "",
        question: ""
      };
    }
  },

  onChange: function(event) {
    this.setState(event)
  },

  onContentChange: function(content){
    this.setState({answer: content});
  },

  onClick: function(event) {
    this.setState({saving: true});
    event.preventDefault();
    var formData = new FormData($('.form-loan-faq')[0]);

    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      enctype: 'multipart/form-data',
      data: formData,
      success: function(response) {
        this.setState(
          {
            question: response.faq.question,
            answer: response.faq.answer,
            saving: false
          }
        );
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        if(response.faqs){
          this.props.onReloadTable(response.faqs);
        }
        this.setState({saving: false});
      }.bind(this),
      cache: false,
      contentType: false,
      processData: false,
      async: true,
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.message };
        this.showFlashes(flash);
        this.setState({saving: false});
      }.bind(this)
    });
  },

  onRemove: function(event) {
    if(this.props.Faq) {
      this.setState({removing: true});

      $.ajax({
        url: this.props.Url,
        method: 'DELETE',
        success: function(response) {
          var flash = { "alert-success": response.message };
          this.showFlashes(flash);
          location.href = '/loan_faq_managements';
        }.bind(this),
        error: function(response, status, error) {
          var flash = { "alert-danger": response.responseJSON.message };
          this.showFlashes(flash);
        }.bind(this)
      });
    }
  },

  render: function() {
    return (
      <div>
        <form className="form-horizontal form-loan-faq">
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Question"
                keyName="question"
                name="faq[question]"
                value={this.state.question}
                editable={true}
                onChange={this.onChange}/>

              <TextField
                label="Answer"
                keyName="answer"
                name="faq[answer]"
                value={this.state.answer}
                hidden={true}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-12">
              <TextEditor
                label="Answer"
                onChange={this.onContentChange}
                content={this.state.answer}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-10">
              <button className="btn btn-primary" onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
              &nbsp;
              { this.props.Faq ?
                <a className="btn btn-danger" data-toggle="modal" data-target="#removeFaq" disabled={this.state.removing}>{ this.state.removing ? 'Removing' : 'Remove' }</a>
              : null
              }
            </div>
          </div>
        </form>
        <ModalLink
          id="removeFaq"
          title="Confirmation"
          body="Are you sure to remove this faq?"
          yesCallback={this.onRemove}
        />
      </div>
    )
  }
});

module.exports = Form;
