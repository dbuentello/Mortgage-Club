var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var BorrowerTab = React.createClass({
  mixins: [TextFormatMixin],
  getDownloadUrl: function(id, type) {
    return '/document_uploader/' + id + '/download?type=' + type
  },
  render: function() {
    return (
      <div className="box boxBasic backgroundBasic">
        <div className="boxBody ptm">
          <table className="table table-striped">
            <thead>
              <tr>
                <th>Name</th>
                <th>Owner</th>
                <th>Description</th>
                <th>Date modified</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
            {
              _.map(this.props.borrowerList.borrower_documents, function(document) {
                return (
                  <tr key={document.id}>
                    <td>
                      <span><img src={document.file_icon_url} width="40px" height="30px"/></span>
                      &nbsp;&nbsp;&nbsp;
                      <span>{document.attachment_file_name}</span>
                    </td>
                    <td>{document.owner_name}</td>
                    <td>{document.description}</td>
                    <td>{this.isoToUsDate(document.attachment_updated_at)}</td>
                    <td>
                      <a href={this.getDownloadUrl(document.id, document.class_name)} download><i className="iconDownload"></i></a>
                    </td>
                  </tr>
                )
              }, this)
            }
            </tbody>
          </table>
        </div>
      </div>
    )
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