require "rails_helper"

describe Docusign::BuildSignatureForEnvelopeService do
  let(:user) { FactoryGirl.create(:user) }
  let(:loan) { FactoryGirl.create(:loan_with_all_associations) }
  let(:template) { FactoryGirl.create(:template, name: "Loan Estimate") }
  let(:borrower) { FactoryGirl.create(:borrower) }

  before(:each) do
    allow_any_instance_of(Docusign::Helper).to receive(:get_tabs_from_template).and_return({
      sign_here_tabs: [{}],
      date_signed_tabs: [{}]
    })

    @envelope_hash = {
      user: {name: user.to_s, email: user.email},
      values: {},
      embedded: true,
      loan_id: loan.id,
      template_name: template.name,
      template_id: template.docusign_id,
    }
    @signature = Docusign::BuildSignatureForEnvelopeService.new(loan, template, @envelope_hash).call
  end

  it "returns an array" do
    expect(@signature).to be_a(Array)
  end

  context "only one borrower" do
    before(:each) do
      loan.secondary_borrower = nil
    end

    it "builds an array containing required keys" do
      expect(@signature.first).to include(:embedded, :name, :email, :role_name)
    end

    it "returns a valid signer" do
      expect(@signature.first).to include({
        name: user.to_s,
        email: user.email,
        role_name: 'Normal',
        embedded: true
      })
    end

    describe '.envelope_requires_cosignature?' do
      it "returns false" do
        service = Docusign::BuildSignatureForEnvelopeService.new(loan, template, @envelope_hash)
        expect(service.send(:envelope_requires_cosignature?)).to eq(false)
      end
    end
  end

  context "coborrower" do
    before(:each) do
      loan.secondary_borrower = borrower
    end

    it "creates two signer in sign_here_tabs" do
      expect(@signature.first[:sign_here_tabs].size).to eq(2)
    end

    describe '.envelope_requires_cosignature?' do
      it "returns true" do
        service = Docusign::BuildSignatureForEnvelopeService.new(loan, template, @envelope_hash)
        expect(service.send(:envelope_requires_cosignature?)).to eq(true)
      end
    end
  end
end
