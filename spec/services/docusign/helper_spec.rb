require 'rails_helper'

describe Docusign::Helper do

  before :all do
    @base = Docusign::Base.new
    @base.create_template_object_from_name('Loan Estimation')
  end

  let(:template) { Template.where(name: 'Loan Estimation').first }

  it "make_sure_template_name_and_id_exist should return right data" do
    template_id = @base.helper.make_sure_template_name_and_id_exist(template_name: template.name)[:template_id]
    template_name = @base.helper.make_sure_template_name_and_id_exist(docusign_id: template.docusign_id)[:template_name]

    expect(template_id).to eq(template.docusign_id)
    expect(template_name).to eq(template.name)
  end

  after :all do
    Template.destroy_all
  end
end
