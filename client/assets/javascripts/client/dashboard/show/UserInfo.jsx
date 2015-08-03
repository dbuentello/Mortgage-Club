var React = require('react/addons');
var UserInfo = React.createClass({
  render: function() {
    var info = this.props.info;
    return (
      <div className='ptl'>
        <h5 className='bbs'>Your Relationship Manager</h5>
        <p className='typeEmphasize'>{info.firstName} {info.lastName}</p>
        <p><a href='mailto:{info.email}'>{info.email}</a></p>
      </div>
    )
  }
});

module.exports = UserInfo;