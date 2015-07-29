require 'rails_helper'

describe Docusign::Helper do

  before :all do
    @base = Docusign::Base.new
    @template = @base.create_template_object_from_name('Loan Estimation')
  end

  context "when run make_sure_template_name_and_id_exist" do
    it "should return right data" do
      template_docusign_id = @base.helper.make_sure_template_name_and_id_exist(template_name: @template.name)[:template_id]
      template_name = @base.helper.make_sure_template_name_and_id_exist(template_id: @template.docusign_id)[:template_name]

      expect(template_docusign_id).to eq(@template.docusign_id)
      expect(template_name).to eq(@template.name)
    end
  end

  after :all do
    Template.destroy_all
  end
end
