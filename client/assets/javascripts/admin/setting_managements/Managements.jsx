var _ = require('lodash');
var React = require('react/addons');


var Managements = React.createClass({
  getInitialState: function() {
    return {
      setting: this.props.bootstrapData.setting
    }
  },
  onOCRClick: function(event) {
    this.state.setting.ocr = !this.state.setting.ocr;
    this.setState({
      setting: this.state.setting
    });
  },
  componentDidUpdate: function(){
    $.ajax({
       url: "settings/"+this.state.setting.id,
       method: "PUT",
       data: this.state.setting,
       success: function(response) {
            console.log("ok");
         }.bind(this),
         error: function(response, status, error) {
           console.log(response);
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
                  <h5 className="panel-setting">setting</h5>
                  <div className="heading-elements">

                  </div>
                </div>
                <div className="panel-body">

                </div>
                <div className="table-responsive">
                  <table className="table table-striped table-hover">
                    <thead>
                      <tr>
                        <th>setting</th>
                        <th>Actions</th>

                      </tr>
                    </thead>
                    <tbody>


                            <tr key={this.state.setting.id}>
                              <td>
                                Enable OCR
                              </td>
                              <td>
                                <input type="checkbox" className="styled" defaultChecked={this.state.setting.ocr} onChange={this.onOCRClick}/>

                                </td>
                            </tr>


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
