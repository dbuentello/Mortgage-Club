var React = require('react/addons');

var Lenders = React.createClass({
  getInitialState: function() {
    return {
    };
  },
  render: function() {
    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Lenders</h2>
            <a className="btn btnSml btnAction mlm" href="/lenders/new">Add Lender</a>
            <table className="table table-striped">
              <thead>
              <tr>
                <th>Name</th>
                <th>Website</th>
                <th>Rate Sheet</th>
                <th>Lock Rate Email</th>
                <th>Docs Email</th>
                <th>Contact Name</th>
                <th>Contact Email</th>
                <th>Contact Phone</th>
                <th></th>
              </tr>
              </thead>
              <tbody>
              {
                _.map(this.props.bootstrapData.lenders, function(lender){
                    return (
                      <tr key={lender.id}>
                        <td>{lender.name}</td>
                        <td>{lender.website}</td>
                        <td>{lender.rate_sheet}</td>
                        <td>{lender.lock_rate_email}</td>
                        <td>{lender.docs_email}</td>
                        <td>{lender.contact_name}</td>
                        <td>{lender.contact_email}</td>
                        <td>{lender.contact_phone}</td>
                        <th>
                          <a className="btn btn-primary btn-sm col-sm-10 mbm" href={"/lenders/" + lender.id + "/lender_templates"}>Templates</a>
                          <a className="linkTypeReversed btn btn-primary btn-sm col-sm-10" href={'/lenders/' + lender.id + '/edit'}>Edit</a>
                        </th>
                      </tr>
                    )
                  })
              }
              </tbody>
            </table>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = Lenders;