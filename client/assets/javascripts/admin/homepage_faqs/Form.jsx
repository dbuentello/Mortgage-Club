var _ = require('lodash');
var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');
var TextField = require('components/form/TextField');
var TextEditor = require('components/TextEditor');
var ModalLink = require('components/ModalLink');

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
    if(this.props.HomepageFaq) {
      return {
        question: this.props.HomepageFaq.question,
        answer: this.props.HomepageFaq.answer
      };
    }else{
      return {
        question: "",
        answer: ""
      }
    }
  },

  onChange: function(event) {
    this.setState(event);
  },

  onClick: function(event) {
    this.setState({saving: true});
    event.preventDefault();
    var formData = new FormData($('.form-homepage-faq')[0]);
    formData.append("homepage_faq[answer]", this.state.answer);

    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      enctype: 'multipart/form-data',
      data: formData,
      success: function(response) {
        this.setState({
          question: response.homepage_faq.question,
          answer: response.homepage_faq.answer,
          saving: false
        });
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        if(response.homepage_faqs){
          this.props.onReloadTable(response.homepage_faqs);
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
    if(this.props.HomepageFaq) {
      this.setState({removing: true});

      $.ajax({
        url: this.props.Url,
        method: 'DELETE',
        success: function(response) {
          var flash = { "alert-success": response.message };
          this.showFlashes(flash);
          location.href = '/homepage_faqs';
        }.bind(this),
        error: function(response, status, error) {
          var flash = { "alert-danger": response.responseJSON.message };
          this.showFlashes(flash);
        }.bind(this)
      });
    }
  },

  updateAnswer: function(content){
    this.setState({ answer: content})
  },

  render: function() {
    return (
      <div>
        <form className="form-horizontal form-homepage-faq">
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Question"
                keyName="question"
                name="homepage_faq[question]"
                value={this.state.question}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-12">
              <label className="col-sm-12 pan">Answer</label>
              <TextEditor onChange={this.updateAnswer} content={this.state.answer}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-10">
              <button className="btn btn-primary" onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
              &nbsp;
              { this.props.HomepageFaq ?
                <a className="btn btn-danger" data-toggle="modal" data-target="#removeQuestion" disabled={this.state.removing}>{ this.state.removing ? 'Removing' : 'Remove' }</a>
              : null
              }
            </div>
          </div>
        </form>
        <ModalLink
          id="removeQuestion"
          title="Confirmation"
          body="Are you sure to remove this question?"
          yesCallback={this.onRemove}
        />
      </div>
    )
  }
});

module.exports = Form;
