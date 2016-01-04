var React = require('react/addons');

var SettingsTab = React.createClass({
  render: function() {
    return (
      <div>
        <div className="col-md-4 col-md-offset-4">
          <form className="form-horizontal text-center" role="form">
            <h3 className="text-capitalize text-left">account settings</h3>
            <div className="form-group">
              <div className="col-xs-6"><div className="avatar"></div></div>
              <div className="col-xs-6"><a href="#" className="btn upload-btn">Upload photo</a></div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <h5 className="text-capitalize text-left">email address</h5>
                <input type="email" className="form-control" name="username" id="email" />
                <img src="/icons/pen.png" alt="title"/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <h5 className="text-capitalize text-left">password</h5>
                <input type="password" className="form-control" name="password" id="password"/>
                <img src="/icons/pen.png" alt="title"/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12 text-left">
                <a href="#" className="btn update-btn">Update</a>
              </div>
            </div>
          </form>
        </div>
      </div>
    );
  }
});

module.exports = SettingsTab;