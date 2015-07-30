require 'rails_helper'

describe Docusign::Helper do
  # NOTICE: be careful when making test here because we're using same Docusign account with produciton

  let(:base) { Docusign::Base.new }
  let(:template) { base.create_template_object_from_name('Loan Estimation') }

  context "when run make_sure_template_name_and_id_exist" do
    it "returns right data" do
      template_docusign_id = base.helper.make_sure_template_name_and_id_exist(template_name: template.name)[:template_id]
      template_name = base.helper.make_sure_template_name_and_id_exist(template_id: template.docusign_id)[:template_name]

      expect(template_docusign_id).to eq(template.docusign_id)
      expect(template_name).to eq(template.name)
    end
  end

  context "when run get_tabs_from_template" do
    it "returns a hash of arrays" do
      result = base.helper.get_tabs_from_template(template_name: template.name)

      expect(result).to be_a(Hash)
      expect(result.values.first).to be_a(Array)
      expect(result.values.last).to be_a(Array)
    end
  end

end
