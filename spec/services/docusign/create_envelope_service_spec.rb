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

  describe "#generates_documents_by_adobe_field_names" do
    it "creates three files" do
      # File.delete(described_class::UNIFORM_OUTPUT_PATH) if File.exist?(described_class::UNIFORM_OUTPUT_PATH)
      # File.delete(described_class::FORM_4506_OUTPUT_PATH) if File.exist?(described_class::FORM_4506_OUTPUT_PATH)
      # File.delete(described_class::BORROWER_CERTIFICATION_OUTPUT_PATH) if File.exist?(described_class::BORROWER_CERTIFICATION_OUTPUT_PATH)
      allow_any_instance_of(Docusign::Templates::UniformResidentialLoanApplication).to receive(:build).and_return({})

      described_class.new.generates_documents_by_adobe_field_names(loan)

      expect(File).to exist(described_class::UNIFORM_OUTPUT_PATH)
      expect(File).to exist(described_class::FORM_4506_OUTPUT_PATH)
      expect(File).to exist(described_class::BORROWER_CERTIFICATION_OUTPUT_PATH)
    end
  end

  describe "#generate_envelope" do
    it "generates an envelope successfully" do
      VCR.use_cassette("generate envelope from Docusign") do
        allow_any_instance_of(Docusign::Templates::UniformResidentialLoanApplication).to receive(:build).and_return({})
        described_class.new.generates_documents_by_adobe_field_names(loan)
        envelope = described_class.new.generate_envelope(user, loan)

        expect(envelope["envelopeId"]).not_to be_nil
        expect(envelope["uri"]).not_to be_nil
        expect(envelope["statusDateTime"]).not_to be_nil
        expect(envelope["status"]).to eq("sent")
      end
    end
  end
end
