var _ = require('lodash');
var React = require('react/addons');

var Dropzone = require('components/form/Dropzone');

var fields = {
  appraisal_report: {label: 'Appraised property value', name: 'appraisal_report', placeholder: 'drap file here or browse', value: 'first_w2_value'},
  flood_zone_certification: {label: 'Flood zone certification', name: 'flood_zone_certification', placeholder: 'drap file here or browse', value: 'second_w2_value'},
  homeowners_insurance: {label: "Homeowner's insurance", name: 'homeowners_insurance', placeholder: 'drap file here or browse', value: 'first_paystub_value'},
  inspection_report: {label: 'Home inspection report', name: 'inspection_report', placeholder: 'drap file here or browse', value: 'second_paystub_value'},
  lease_agreement: {label: 'Lease agreement', name: 'lease_agreement', placeholder: 'drap file here or browse', value: 'first_bank_statement_value'},
  mortgage_statement: {label: 'Latest mortgage statement of subject property', name: 'mortgage_statement', placeholder: 'drap file here or browse', value: 'second_bank_statement_value'},
  purchase_agreement: {label: 'Executed purchase agreement', name: 'purchase_agreement', placeholder: 'drap file here or browse', value: 'second_bank_statement_value'},
  risk_report: {label: "Home seller's disclosure report", name: 'risk_report', placeholder: 'drap file here or browse', value: 'second_bank_statement_value'},
  termite_report: {label: 'Termite report', name: 'termite_report', placeholder: 'drap file here or browse', value: 'second_bank_statement_value'},
  title_report: {label: 'Preliminary title report', name: 'title_report', placeholder: 'drap file here or browse', value: 'second_bank_statement_value'},
};

var Property = React.createClass({
  getInitialState: function() {
    return this.buildStateFromProperty(this.props.property);
  },

  onChange: function(change) {
    this.setState(change);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  render: function() {
    var uploadUrl = '/property_document_uploader/' + this.props.property.id + '/upload';
    var downloadUrl = '/property_document_uploader/' + this.props.property.id + '/download';
    var removeUrl = '/property_document_uploader/' + this.props.property.id + '/remove';
    var customParams = [
      {property_id: this.props.property.id},
      {type: 'AppraisalReport'}
    ]
    console.dir('2342432')
    console.dir(this.state)
    return (
      <div className='pal'>
        <div className='box mtn'>
          <div className='row'>
            {
              _.map(Object.keys(fields), function(key) {
                return(
                  <div className="drop_zone">
                    <Dropzone field={fields[key]}
                      uploadUrl={uploadUrl}
                      downloadUrl={downloadUrl}
                      removeUrl={removeUrl}
                      tip={this.state[fields[key].name]}
                      maxSize={10000000}
                      customParams={customParams}
                    />
                  </div>
                )
              }, this)
            }
          </div>
        </div>
      </div>
    )
  },

  buildStateFromProperty: function(property) {
    var state = {};
    _.map(Object.keys(fields), function(key) {
      if (this.props.property[key]) {
        state[fields[key].name] = this.props.property[key].attachment_file_name;
      }
      else {
        state[fields[key].name] = fields[key].placeholder;
      }
    }, this)
    return state;
  },
});

module.exports = Property;
