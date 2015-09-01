var _ = require('lodash');
var React = require('react/addons');

var OverviewTab = React.createClass({
  render: function() {
    return (
      <div>
        <div className="box boxBasic backgroundBasic text-center">
          <div className='boxHead bbs'>
            <h4 className='typeBold'><i className="iconAttention"></i>&nbsp;
              We are still waiting on some of your checklist items
            </h4>
          </div>
          <div className="boxBody boxGuide">
            Go ahead and click 'Get Started' on the items below to start working through your open items
          </div>
        </div>

        <div className='text-center'>
          We display additional documents that user need to submit
        </div>

        <div className="box boxBasic backgroundBasic">
          <div className='boxHead bbs'>
            <h4 className='typeBold'>Your Loan Checklist</h4>
          </div>
          <div className="boxBody">
            <table className="table table-bordered table-primary">
              <thead>
                <tr>
                  <th className="clickable plm">
                    <a>
                      Name
                      <span className="sort-actions active prn">
                        <span className="dropup"></span><span className="caret caret-bottom"></span>
                      </span>
                    </a>
                  </th>
                  <th className="clickable plm">
                    <a>
                      Origin
                      <span className="sort-actions inactive prn">
                        <span className="dropup">
                          <span className="caret caret-top"></span></span><span className="caret caret-bottom">
                        </span>
                      </span>
                    </a>
                  </th>
                  <th className="clickable plm">
                    <a>
                      Destination
                      <span className="sort-actions inactive prn">
                        <span className="dropup">
                          <span className="caret caret-top"></span></span><span className="caret caret-bottom">
                        </span>
                      </span>
                    </a>
                  </th>
                </tr>
              </thead>
              <tbody className="tam">
                <tr>
                  <td><a href="#table">Really big speakers</a></td>
                  <td>Guangzhou, China</td>
                  <td>San Francisco, CA</td>
                </tr>
                <tr>
                  <td><a href="#table">Phenolic Laminated Panel</a></td>
                  <td>Osaka, Japan</td>
                  <td>New York, NY</td>
                </tr>
                <tr>
                  <td><a href="#table">Dogs and Cats</a></td>
                  <td>Aabenraa, Denmark</td>
                  <td>Los Angeles, CA</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = OverviewTab;