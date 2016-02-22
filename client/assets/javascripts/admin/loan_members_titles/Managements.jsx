var _ = require('lodash');
var React = require('react/addons');

var Managements = React.createClass({


  render: function() {
    var url = '/loan_member_managements/';

    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Team Members</h2>
            <table className="table table-striped">
              <thead>
                <tr>
                  <th>id</th>
                  <th>title</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>

              </tbody>
            </table>
          </div>
          <div className='row'>
            <h2 className='mbl'>Add new member</h2>

          </div>
        </div>
      </div>
    )
  }

});

module.exports = Managements;