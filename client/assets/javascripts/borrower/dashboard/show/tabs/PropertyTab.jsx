var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var PropertyTab = React.createClass({
  mixins: [TextFormatMixin],
  getDownloadUrl: function(id) {
    return '/document_uploaders/base_document/' + id + '/download';
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
              _.map(this.props.propertyDocuments, function(document) {
                return (
                  <tr key={document.id}>
                    <td>
                      <span><img src={document.file_icon_url} width="40px" height="30px"/></span>
                      &nbsp;&nbsp;&nbsp;
                      <span>{document.original_filename == null ? document.attachment_file_name : document.original_filename}</span>
                    </td>
                    <td>{document.user.to_s}</td>
                    <td>{document.description}</td>
                    <td>{this.isoToUsDate(document.updated_at)}</td>
                    <td>
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

module.exports = PropertyTab;