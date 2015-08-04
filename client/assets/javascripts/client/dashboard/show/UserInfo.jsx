var React = require('react/addons');

var UserInfo = React.createClass({
  render: function() {
    var info = this.props.info;

    return (
      <div>
        <h5 className='ptl bbs pbm'>Your Relationship Manager</h5>
        <div className='ptm typeEmphasize clearfix'>
          <div className='manager-image pull-left mrm'>
            <img src='https://avatars0.githubusercontent.com/u/11491751?v=3&s=400' width="80px" height="80px"/>
          </div>
          <div className='manager-info pull-left'>
            <p>Billy Tran</p>
            <p>(Cell) 650-787-7799</p>
            <p><a href='javascript:void(0)'>Skype Call</a></p>
            <p><a href='mailto:billy@mortgageclub.io'>billy@mortgageclub.io</a></p>
          </div>
        </div>

        <div className='pvm bbs'>
          <h5>Helpful Q&A</h5>
        </div>

        <div className='mbl'>
          <p><a href='javascript:void(0)'>What are these files?</a></p>
          <p><a href='javascript:void(0)'>Who has access to these?</a></p>
          <p><a href='javascript:void(0)'>What are the different tabs?</a></p>
          <p><a href='javascript:void(0)'>Do I have to classify files?</a></p>
          <p><a href='javascript:void(0)'>Are my files safe?</a></p>
        </div>

      </div>
    )
  }
});

module.exports = UserInfo;