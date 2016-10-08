var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var BooleanRadio = require("components/form/BooleanRadio");

var fields = {};

var RequiredDocumentTab = React.createClass({
  mixins: [TextFormatMixin],

  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function() {
    var state = {
      saving: false,
      borrower_documents: this.props.loan.borrower.documents,
      co_borrower_documents: []
    }

    if(this.props.loan.secondary_borrower){
      state.co_borrower_documents = this.props.loan.secondary_borrower.documents;
    }
    return state;
  },

  onChange: function(change) {
    var key = Object.keys(change)[0];
    var value = change[key];

  },

  onSubmit: function(event) {
    event.preventDefault();
    this.setState({saving: true});
    $.ajax({
      url: "/loan_members/loans/" + this.props.loan.id + "/update_required_documents",
      data: {

      },
      method: "POST",
      dataType: "json",
      success: function(response) {
        this.setState({saving: false});
        // var state = this.buildState(response.loan);
        this.setState(state);
      }.bind(this),
      error: function(response){
        this.setState({saving: false});
      }.bind(this)
    });
  },

  render: function() {
    return (
      <div id="loan-terms-page">
        <div className="panel panel-flat">
          <div className="panel-heading">
            <h4 className="panel-title">Required Documents</h4>
          </div>
          <form className="form-horizontal form-checklist">
            <div className="panel-heading">
              <h4 className="panel-title">Borrower Documents</h4>
            </div>
            {
              _.map(this.state.borrower_documents, function(document, index) {
                return(
                  <div className="form-group">
                    <div className="col-sm-12">
                      <BooleanRadio
                        label={document.description}
                        keyName={document.id}
                        checked={document.is_required}
                        onChange={this.onChange}
                        editable={true}
                        />
                    </div>
                  </div>
                )
              }, this)
            }
            {
              this.props.loan.secondary_borrower
              ?
                <div>
                  <div className="panel-heading">
                    <h4 className="panel-title">Secondary Borrower Documents</h4>
                  </div>
                  {
                    _.map(this.state.co_borrower_documents, function(document, index) {
                      return(
                        <div className="form-group">
                          <div className="col-sm-12">
                            <BooleanRadio
                              label={document.description}
                              keyName={document.id}
                              checked={document.is_required}
                              onChange={this.onChange}
                              editable={true}
                              />
                          </div>
                        </div>
                      )
                    }, this)
                  }
                </div>
              : null
            }
            <div className="form-group">
              <div className="col-sm-6">
                <button className="btn btn-primary" id="submit-loan-terms" onClick={this.onSubmit} disabled={this.state.saving}>{ this.state.saving ? "Submitting" : "Submit" }</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    )
  }

});

module.exports = RequiredDocumentTab;
