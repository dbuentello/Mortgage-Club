var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var BorrowerTab = React.createClass({
  mixins: [TextFormatMixin],
  getDownloadUrl: function(id) {
    return '/document_uploaders/base_document/' + id + '/download';
  },
  render: function() {
    return (
      <div className="board">
        <div className="table-responsive">
          <table className="table table-condensed">
            <thead>
              <tr>
                <th width="7%">Name</th>
                <th width="22%"></th>
                <th width="15%">Owner</th>
                <th width="36%">Description</th>
                <th width="15%">Date modified</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
            {
              _.map(this.props.borrowerDocuments, function(document) {
                return (
                  <tr key={document.id}>
                    <td width="7%"><img className="img-responsive" src={document.file_icon_url} /></td>
                    <td width="22%">
                      <span>{document.original_filename == null ? document.attachment_file_name : document.original_filename}</span>
                    </td>
                    <td width="15%">{document.user.to_s}</td>
                    <td width="36%">{document.description}</td>
                    <td width="15%">{this.isoToUsDate(document.updated_at)}</td>
                    <td width="5%">
                      <a href={this.getDownloadUrl(document.id)} download><i className="iconDownload"></i></a>
                    </td>
                  </tr>
                )
              }, this)
            }
            {
              _.map(this.props.coBorrowerDocuments, function(document) {
                return (
                  <tr key={document.id}>
                    <td width="7%"><img className="img-responsive" src={document.file_icon_url} /></td>
                    <td width="22%">
                      <span>{document.original_filename == null ? document.attachment_file_name : document.original_filename}</span>
                    </td>
                    <td width="15%">{document.user.to_s}</td>
                    <td width="36%">{document.description}</td>
                    <td width="15%">{this.isoToUsDate(document.updated_at)}</td>
                    <td width="5%">
                      <a href={this.getDownloadUrl(document.id)} download><i className="iconDownload"></i></a>
                    </td>
                  </tr>
                )
              }, this)
            }
            {
              _.map(this.props.coBorrower.documents, function(document) {
                return (
                  <tr key={document.id}>
                    <td width="7%"><img className="img-responsive" src={document.file_icon_url} /></td>
                    <td width="22%">
                      <span>{document.original_filename == null ? document.attachment_file_name : document.original_filename}</span>
                    </td>
                    <td width="15%">{this.props.coBorrower.user.to_s}</td>
                    <td width="36%">{document.description}</td>
                    <td width="15%">{this.isoToUsDate(document.updated_at)}</td>
                    <td width="5%">
                      <a href={this.getDownloadUrl(document.id)} download><i className="iconDownload"></i></a>
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
  }
});

module.exports = BorrowerTab;
