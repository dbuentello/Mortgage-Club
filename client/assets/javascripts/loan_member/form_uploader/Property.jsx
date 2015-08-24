var _ = require('lodash');
var React = require('react/addons');

var Dropzone = require('components/form/Dropzone');

var fields = {
  appraisal_report: {label: 'Appraised property value', name: 'appraisal_report', placeholder: 'drap file here or browse', type: 'AppraisalReport'},
  flood_zone_certification: {label: 'Flood zone certification', name: 'flood_zone_certification', placeholder: 'drap file here or browse', type: 'FloodZoneCertification'},
  homeowners_insurance: {label: "Homeowner's insurance", name: 'homeowners_insurance', placeholder: 'drap file here or browse', type: 'HomeownersInsurance'},
  inspection_report: {label: 'Home inspection report', name: 'inspection_report', placeholder: 'drap file here or browse', type: 'InspectionReport'},
  lease_agreement: {label: 'Lease agreement', name: 'lease_agreement', placeholder: 'drap file here or browse', type: 'LeaseAgreement'},
  mortgage_statement: {label: 'Latest mortgage statement of subject property', name: 'mortgage_statement', placeholder: 'drap file here or browse', type: 'MortgageStatement'},
  purchase_agreement: {label: 'Executed purchase agreement', name: 'purchase_agreement', placeholder: 'drap file here or browse', type: 'PurchaseAgreement'},
  risk_report: {label: "Home seller's disclosure report", name: 'risk_report', placeholder: 'drap file here or browse', type: 'RiskReport'},
  termite_report: {label: 'Termite report', name: 'termite_report', placeholder: 'drap file here or browse', type: 'TermiteReport'},
  title_report: {label: 'Preliminary title report', name: 'title_report', placeholder: 'drap file here or browse', type: 'TitleReport'},
  other_property_report: {label: 'Other', name: 'other_property_report', placeholder: 'drap file here or browse', type: 'OtherPropertyReport', customDescription: true}
};

var Property = React.createClass({
  getInitialState: function() {
    return this.buildStateFromProperty(this.props.property);
  },

  render: function() {
    var uploadUrl = '/property_document_uploader/upload';

    return (
      <div className='pal'>
        <div className='box mtn'>
          <div className='row'>
            {
              _.map(Object.keys(fields), function(key) {
                var customParams = [
                  {type: fields[key].type},
                  {property_id: this.props.property.id}
                ];

                return(
                  <div className="drop_zone" key={key}>
                    <Dropzone field={fields[key]}
                      uploadUrl={uploadUrl}
                      downloadUrl={this.state[fields[key].name + '_downloadUrl']}
                      removeUrl={this.state[fields[key].name + '_removedUrl']}
                      tip={this.state[fields[key].name]}
                      maxSize={10000000}
                      customParams={customParams}
                      supportOtherDescription={fields[key].customDescription}
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

      if (this.props.property[key]) { // has a document
        state[fields[key].name] = this.props.property[key].attachment_file_name;
        state[fields[key].id] = this.props.property[key].id;
        state[fields[key].name + '_downloadUrl'] = '/property_document_uploader/' + this.props.property[key].id +
                                         '/download?type=' + fields[key].type;
        state[fields[key].name + '_removedUrl'] = '/property_document_uploader/' + this.props.property[key].id +
                                          '/remove?type=' + fields[key].type;
      }else {
        state[fields[key].name] = fields[key].placeholder;
        state[fields[key].name + '_downloadUrl'] = 'javascript:void(0)';
        state[fields[key].name + '_removedUrl'] = 'javascript:void(0)';
      }
    }, this);
    return state;
  },
});

module.exports = Property;
