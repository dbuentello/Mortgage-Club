var _ = require('lodash');
var React = require('react/addons');

var FaqsList = React.createClass({
  render: function() {
    var faqs = this.props.FaqsList;
    console.log(faqs);
    return (
      <div className="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
          {
            _.map(faqs, function(faq) {
              return (
                <div className="panel">
                  <div className="panel-heading" role="tab" id={"heading" + faq.id}>
                    <h4 className="panel-title">
                      <a role="button" data-toggle="collapse" data-parent="#accordion" href={"#collapse" + faq.id} aria-expanded="false" aria-controls={"collapse" + faq.id} className="collapsed">
                        {faq.question}
                      </a>
                    </h4>
                  </div>
                  <div id={"collapse" + faq.id} className="panel-collapse collapse" role="tabpanel" aria-labelledby={"heading" + faq.id} aria-expanded="false">
                    <div className="panel-body">
                      <p>{faq.answer}</p>
                    </div>
                  </div>
                </div>
              )
            })
          }
      </div>
    )
  }
});

module.exports = FaqsList;

