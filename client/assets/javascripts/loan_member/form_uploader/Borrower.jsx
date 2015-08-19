var _ = require('lodash');
var React = require('react/addons');

var Dropzone = require('components/form/Dropzone');

var fields = {
  firstW2: {label: 'W2 - Most recent tax year', name:  'first_w2', placeholder: 'drap file here or browse', helpText: 'Document uploader.', value: 'first_w2_value'},
  secondW2: {label: 'W2 - Previous tax year', name:  'second_w2', placeholder: 'drap file here or browse', helpText: 'Document uploader.', value: 'second_w2_value'},
  firstPaystub: {label: 'Paystub - Most recent month', name:  'first_paystub', placeholder: 'drap file here or browse', helpText: 'Document uploader.', value: 'first_paystub_value'},
  secondPaystub: {label: 'Paystub - Previous month', name:  'second_paystub', placeholder: 'drap file here or browse', helpText: 'Document uploader.', value: 'second_paystub_value'},
  firstBankStatement: {label: 'Bank statement - Most recent month', name:  'first_bank_statement', placeholder: 'drap file here or browse', helpText: 'Document uploader.', value: 'first_bank_statement_value'},
  secondBankStatement: {label: 'Bank statement - Previous month', name:  'second_bank_statement', placeholder: 'drap file here or browse', helpText: 'Document uploader.', value: 'second_bank_statement_value'},
  otherBorrowerReport: {label: 'Other', name: 'other_borrower_report', placeholder: 'drap file here or browse'}
};

var Borrower = React.createClass({
  getInitialState: function() {
    return this.buildStateFromBorrower();
  },

  onChange: function(change) {
    this.setState(change);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  render: function() {
    return (
      <div className='pal'>
        <div className='box mtn'>
          <div className='row'>
            <Dropzone onDrop={this.onDrop} field={fields.firstW2}
              uploadUrl={this.state.first_w2_url}
              downloadUrl={this.state.download_first_w2_url}
              removeUrl={this.state.remove_first_w2_url}
              afterRemove={this.refresh}
              tip={this.state[fields.firstW2.name]}
              maxSize={10000000}
              />

            <Dropzone onDrop={this.onDrop} field={fields.secondW2}
              uploadUrl={this.state.second_w2_url}
              downloadUrl={this.state.download_second_w2_url}
              removeUrl={this.state.remove_second_w2_url}
              afterRemove={this.refresh}
              tip={this.state[fields.secondW2.name]}
              maxSize={10000000}/>

            <Dropzone onDrop={this.onDrop} field={fields.firstPaystub}
              uploadUrl={this.state.first_paystub_url}
              downloadUrl={this.state.download_first_paystub_url}
              removeUrl={this.state.remove_first_paystub_url}
              afterRemove={this.refresh}
              tip={this.state[fields.firstPaystub.name]}
              maxSize={10000000}/>

            <Dropzone onDrop={this.onDrop} field={fields.secondPaystub}
              uploadUrl={this.state.second_paystub_url}
              downloadUrl={this.state.download_second_paystub_url}
              removeUrl={this.state.remove_second_paystub_url}
              afterRemove={this.refresh}
              tip={this.state[fields.secondPaystub.name]}
              maxSize={10000000}/>

            <Dropzone onDrop={this.onDrop} field={fields.firstBankStatement}
              uploadUrl={this.state.first_bank_statement_url}
              downloadUrl={this.state.download_first_bank_statement_url}
              removeUrl={this.state.remove_first_bank_statement_url}
              afterRemove={this.refresh}
              tip={this.state[fields.firstBankStatement.name]}
              maxSize={10000000}/>

            <Dropzone onDrop={this.onDrop} field={fields.secondBankStatement}
              uploadUrl={this.state.second_bank_statement_url}
              downloadUrl={this.state.download_second_bank_statement_url}
              removeUrl={this.state.remove_second_bank_statement_url}
              afterRemove={this.refresh}
              tip={this.state[fields.secondBankStatement.name]}
              maxSize={10000000}/>

            <Dropzone onDrop={this.onDrop} field={fields.otherBorrowerReport}
              uploadUrl={this.state.other_borrower_report_url}
              downloadUrl={this.state.download_other_borrower_report_url}
              removeUrl={this.state.remove_other_borrower_report_url}
              afterRemove={this.refresh}
              tip={this.state[fields.otherBorrowerReport.name]}
              maxSize={10000000}
              supportOtherDescription={true}/>
          </div>
        </div>
      </div>
    );
  },

  display_document: function(file_name) {
    return;
  },

  componentWillReceiveProps: function(nextProps) {
    this.setState(_.extend(this.buildStateFromBorrower(nextProps.loan), {
      saving: false
    }));
  },


  buildStateFromBorrower: function() {
    var state = {};

    state.first_w2_url = '/borrower_uploader/' + this.props.borrower.id + '/w2?order=1';
    state.second_w2_url = '/borrower_uploader/' + this.props.borrower.id + '/w2?order=2';
    state.first_paystub_url =  '/borrower_uploader/' + this.props.borrower.id + '/paystub?order=1';
    state.second_paystub_url =  '/borrower_uploader/' + this.props.borrower.id + '/paystub?order=2';
    state.first_bank_statement_url = '/borrower_uploader/' + this.props.borrower.id + '/bank_statement?order=1';
    state.second_bank_statement_url = '/borrower_uploader/' + this.props.borrower.id + '/bank_statement?order=2';
    state.other_borrower_report_url = '/borrower_uploader/' + this.props.borrower.id + '/other_borrower_report';

    if (this.props.borrower.first_w2) {
      state[fields.firstW2.name] = this.props.borrower.first_w2.attachment_file_name;
      state.remove_first_w2_url =  '/borrower_uploader/' + this.props.borrower.id + '/remove_w2?order=1';
      state.download_first_w2_url =  '/borrower_uploader/' + this.props.borrower.id + '/download_w2?order=1';
    } else {
      state[fields.firstW2.name] = fields.firstW2.placeholder;
      state.remove_first_w2_url = 'javascript:void(0)';
      state.download_first_w2_url = 'javascript:void(0)';
    }

    if (this.props.borrower.second_w2) {
      state[fields.secondW2.name] = this.props.borrower.second_w2.attachment_file_name;
      state.remove_second_w2_url =  '/borrower_uploader/' + this.props.borrower.id + '/remove_w2?order=2';
      state.download_second_w2_url =  '/borrower_uploader/' + this.props.borrower.id + '/download_w2?order=2';
    } else {
      state[fields.secondW2.name] = fields.secondW2.placeholder;
      state.remove_second_w2_url = 'javascript:void(0)';
      state.download_second_w2_url = 'javascript:void(0)';
    }

    if (this.props.borrower.first_paystub) {
      state[fields.firstPaystub.name] = this.props.borrower.first_paystub.attachment_file_name;
      state.remove_first_paystub_url = '/borrower_uploader/' + this.props.borrower.id + '/remove_paystub?order=1';
      state.download_first_paystub_url = '/borrower_uploader/' + this.props.borrower.id + '/download_paystub?order=1';
    } else {
      state[fields.firstPaystub.name] = fields.firstPaystub.placeholder;
      state.remove_first_paystub_url = 'javascript:void(0)';
      state.download_first_paystub_url = 'javascript:void(0)';
    }

    if (this.props.borrower.second_paystub) {
      state[fields.secondPaystub.name] = this.props.borrower.second_paystub.attachment_file_name;
      state.remove_second_paystub_url = '/borrower_uploader/' + this.props.borrower.id + '/remove_paystub?order=2';
      state.download_second_paystub_url = '/borrower_uploader/' + this.props.borrower.id + '/download_paystub?order=2';
    } else {
      state[fields.secondPaystub.name] = fields.secondPaystub.placeholder;
      state.remove_second_paystub_url = 'javascript:void(0)';
      state.download_second_paystub_url = 'javascript:void(0)';
    }

    if (this.props.borrower.first_bank_statement) {
      state[fields.firstBankStatement.name] = this.props.borrower.first_bank_statement.attachment_file_name;
      state.remove_first_bank_statement_url = '/borrower_uploader/' + this.props.borrower.id + '/remove_bank_statement?order=1';
      state.download_first_bank_statement_url = '/borrower_uploader/' + this.props.borrower.id + '/download_bank_statement?order=1';
    } else {
      state[fields.firstBankStatement.name] = fields.firstBankStatement.placeholder;
      state.remove_first_bank_statement_url = 'javascript:void(0)';
      state.download_first_bank_statement_url = 'javascript:void(0)';
    }

    if (this.props.borrower.second_bank_statement) {
      state[fields.secondBankStatement.name] = this.props.borrower.second_bank_statement.attachment_file_name;
      state.remove_second_bank_statement_url = '/borrower_uploader/' + this.props.borrower.id + '/remove_bank_statement?order=2';
      state.download_second_bank_statement_url = '/borrower_uploader/' + this.props.borrower.id + '/download_bank_statement?order=2';
    } else {
      state[fields.secondBankStatement.name] = fields.secondBankStatement.placeholder;
      state.remove_second_bank_statement_url = 'javascript:void(0)';
      state.download_second_bank_statement_url = 'javascript:void(0)';
    }

    if (this.props.borrower.other_borrower_report) {
      state[fields.otherBorrowerReport.name] = this.props.borrower.other_borrower_report.attachment_file_name;
      state.remove_other_borrower_report_url = '/borrower_uploader/' + this.props.borrower.id + '/remove_other_borrower_report';
      state.download_other_borrower_report_url = '/borrower_uploader/' + this.props.borrower.id + '/download_other_borrower_report';
    } else {
      state[fields.otherBorrowerReport.name] = fields.otherBorrowerReport.placeholder;
      state.remove_other_borrower_report_url = 'javascript:void(0)';
      state.download_other_borrower_report_url = 'javascript:void(0)';
    }

    return state;
  },
});

module.exports = Borrower;
