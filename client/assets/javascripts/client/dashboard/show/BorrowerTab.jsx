var _ = require('lodash');
var React = require('react/addons');

var BorrowerTab = React.createClass({
  render: function() {
    var ulStyle = {
      listStyleType: 'none'
    };
    return (
      <div role="tabpanel" className="tab-pane active" id="borrower">
        <div className="box boxBasic backgroundBasic">
          <div className='boxHead bbs'>
            <h3 className='typeBold plxl'>List Documents</h3>
          </div>
          <div className="boxBody ptm">
            <ul style={ulStyle}>
              {
                _.map(this.props.docList, function(doc) {
                  return (
                    <li key={doc.id}>
                      <div className='col-xs-1 ptl'>
                        <img src={doc.file_icon_url} width="40px" height="30px"/>
                      </div>
                      <div className='col-xs-11 ptl'>
                        <p><a href={doc.url}>{doc.name}</a></p>
                      </div>
                    </li>
                  )
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