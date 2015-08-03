var _ = require('lodash');
var React = require('react/addons');
var PropertyTab = React.createClass({
  render: function() {
    return (
      <div role="tabpanel" className="tab-pane active" id="property">
        <div className="box boxBasic backgroundBasic">
          <div className="boxBody ptm">
            <table className="table table-striped">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Owner</th>
                  <th>Kind</th>
                  <th>Modified</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
              {
                _.map(this.props.propertyList, function(property) {
                  return (
                    <tr>
                      <td>
                        <span><img src={property.file.thumbnail} width="40px" height="30px"/></span>
                        &nbsp;&nbsp;&nbsp;
                        <span>{property.file.name}</span>
                      </td>
                      <td>{property.owner}</td>
                      <td>{property.kind}</td>
                      <td>{property.modified_at}</td>
                      <td>
                        <select className="selectpicker">
                          <option></option>
                        </select>
                      </td>
                    </tr>
                  )
                })
              }
              </tbody>
            </table>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = PropertyTab;