var _ = require('lodash');
var React = require('react/addons');
//var Form = require('./Form');

var Managements = React.createClass({
  getInitialState: function() {
    return {
      enableOcr: this.props.bootstrapData.enable_ocr,
      settings: this.props.bootstrapData.settings
    }
  },

  componentDidMount: function(){
    $("#ocr").bootstrapSwitch();
    $('#ocr').on('switchChange.bootstrapSwitch', function(event, state) {
      this.state.enableOcr.ocr = !this.state.enableOcr.ocr;
      this.setState({
        enableOcr: this.state.enableOcr
      });
    }.bind(this));
  },

  componentDidUpdate: function(prevState, nextState){
    $.ajax({
      url: "settings/"+this.state.enableOcr.id,
      method: "PUT",
      data: this.state.enableOcr,
      success: function(response) {
      }.bind(this),
      error: function(response, status, error) {
      }.bind(this)
    });
  },

  render: function() {
    var url = '/setting/';
    return (
      <div>
          {/* Page header */ }
        <div className="page-header">
          <div className="page-header-content">
            <div className="page-setting">
              <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Setting</span> - Management</h4>
            </div>
          </div>
        </div>
        {/* /page header */ }

        {/* Page container */ }
        <div className="page-container">

          {/* Page content */ }
          <div className="page-content">

            {/* Main content */ }
            <div className="content-wrapper">

              {/* Table */ }
              <div className="panel panel-flat">
                <div className="panel-heading">
                  <h5 className="panel-setting">Settings</h5>
                  <div className="heading-elements">
                  </div>
                </div>
                <div className="table-responsive">
                  <table className="table table-striped table-hover">
                    <thead>
                      <tr>
                        <th width="30%">Name</th>
                        <th width="50%">Value</th>
                        <th>Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr key={this.state.enableOcr.id}>
                        <td>
                          Enable OCR
                        </td>
                        <td>
                          <label>
                            <input type="checkbox" id="ocr" data-on-color="success" data-off-color="default" data-on-text="Enable" data-off-text="Disable" className="switch" defaultChecked={this.state.enableOcr.ocr} />
                          </label>
                        </td>
                        <td></td>
                      </tr>
                      {
                        _.map(this.state.settings, function(setting) {
                          return (
                            <tr key={setting.id}>
                              <td>{setting.name}</td>
                              <td>
                                <label>{setting.value}</label>
                              </td>
                              <td>
                                <span>
                                  <a className='linkTypeReversed btn btn-primary' href={'settings/' + setting.id + '/edit'} data-method='get'>Edit</a>
                                </span>
                              </td>
                            </tr>
                          )
                        }, this)
                      }
                    </tbody>
                  </table>
                </div>
              </div>
              {/* /table */ }
            </div>
            {/* /main content */ }
          </div>
          {/* /page content */ }
        </div>
        {/* /page container */ }
      </div>
    )
  }
});

module.exports = Managements;
