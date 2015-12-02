require "rails_helper"

describe Checklist do
  it "has a valid factory" do
    expect(FactoryGirl.build(:checklist, checklist_type: 'explain')).to be_valid
  end

  context "invalid document type" do
    it "raises an error" do
      checklist = FactoryGirl.build(:checklist)
      checklist.document_type = 'fake-document-type'
      checklist.valid?
      expect(checklist.errors[:document_type]).to include("must belong to a proper document")
    end
  end

  describe "#subject_id" do
    let!(:loan) { FactoryGirl.create(:loan) }
    let!(:property) { FactoryGirl.create(:subject_property, loan: loan)}
    let!(:closing) { FactoryGirl.create(:closing, loan: loan)}
    let(:checklist) { FactoryGirl.create(:checklist, loan: loan) }

    context "borrower" do
      it "returns right id of subject" do
        checklist.subject_name = "Borrower"
        expect(checklist.subject_id).to eq(loan.borrower.id)
      end
    end

    context "property" do
      it "returns right id of subject" do
        checklist.subject_name = "Property"
        expect(checklist.subject_id).to eq(loan.subject_property.id)
      end
    end

    context "closing" do
      it "returns right id of subject" do
        checklist.subject_name = "Closing"
        expect(checklist.subject_id).to eq(loan.closing.id)
      end
    end

    context "loan" do
      it "returns right id of subject" do
        checklist.subject_name = "Loan"
        expect(checklist.subject_id).to eq(loan.id)
      end
    end
  end
end
