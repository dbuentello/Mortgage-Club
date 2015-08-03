var _ = require('lodash');
var React = require('react/addons');
var BorrowerTab = React.createClass({
  render: function() {
    return (
      <div role="tabpanel" className="tab-pane active" id="borrower">
        <div className="box boxBasic backgroundBasic">
          <div className='boxHead bbs'>
            <h3 className='typeBold plxl'>List Documents</h3>
          </div>
          <div className="boxBody ptm">
            <ul>
              {
                _.map(this.props.docList, function(doc) {
                  return <p><a href='{doc.url}'>{doc.name}</a></p>
                })
              }
            </ul>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = BorrowerTab;