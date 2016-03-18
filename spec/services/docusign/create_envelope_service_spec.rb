require "rails_helper"

describe Docusign::CreateEnvelopeService do
  let(:user) { FactoryGirl.create(:user) }
  let(:loan) { FactoryGirl.create(:loan) }

  describe "#call" do
    it "calls #generates_documents_by_adobe_field_names" do
      allow_any_instance_of(described_class).to receive(:generate_envelope)
      allow_any_instance_of(described_class).to receive(:delete_temp_files)

      expect_any_instance_of(described_class).to receive(:generates_documents_by_adobe_field_names)

      described_class.new.call(user, loan)
    end

    it "calls #generate_envelope" do
      allow_any_instance_of(described_class).to receive(:generates_documents_by_adobe_field_names)
      allow_any_instance_of(described_class).to receive(:delete_temp_files)

      expect_any_instance_of(described_class).to receive(:generate_envelope)

      described_class.new.call(user, loan)
    end

    it "calls #delete_temp_files" do
      allow_any_instance_of(described_class).to receive(:generates_documents_by_adobe_field_names)
      allow_any_instance_of(described_class).to receive(:generate_envelope)

      expect_any_instance_of(described_class).to receive(:delete_temp_files)

      described_class.new.call(user, loan)
    end
  end

  # we can't test delete file because circleci doesn't support pdftk
  describe "#generates_documents_by_adobe_field_names" do
    it "calls three methods" do
      allow_any_instance_of(Docusign::Templates::UniformResidentialLoanApplication).to receive(:build).and_return({})
      expect_any_instance_of(described_class).to receive(:generate_uniform)
      expect_any_instance_of(described_class).to receive(:generate_form_4506)
      expect_any_instance_of(described_class).to receive(:generate_form_certification)

      described_class.new.generates_documents_by_adobe_field_names(loan)
    end
  end

  describe "#generate_envelope" do
    it "calls DocusignRest" do
      expect_any_instance_of(DocusignRest::Client).to receive(:create_envelope_from_document)

      described_class.new.generate_envelope(user, loan)
    end
  end
end
