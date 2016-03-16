require "rails_helper"

describe Loan do
  let(:loan) { FactoryGirl.create(:loan) }
  it { should have_many(:properties) }
  it { should have_many(:envelopes) }
  it { should have_many(:documents) }
  it { should have_many(:loan_activities) }
  it { should have_many(:loans_members_associations) }
  it { should have_many(:loan_members) }
  it { should have_many(:checklists) }
  it { should have_many(:lender_documents) }
  it { should belong_to(:lender) }

  it "has a valid factory" do
    expect(loan).to be_valid
  end

  it "has a valid with_loan_activites factory" do
    loan = FactoryGirl.build(:loan_with_activites)
    expect(loan).to be_valid
    expect(loan.loan_activities.size).to be >= 1
  end

  describe ".primary_property" do
    context "primary_property is nil" do
      it "returns nil" do
        expect(loan.primary_property).to be_nil
      end
    end

    context "when loan has primary property" do
      before(:each) do
        @loan = FactoryGirl.create(:loan_with_properties)
      end

      it "returns primary_property value" do
        expect(@loan.primary_property).not_to be_nil
      end
    end
  end

  describe ".rental_properties" do
    context "when rental_properties is nil" do
      it "returns nil" do
        expect(loan.rental_properties).to eq([])
      end
    end

    context "when loan has rental_properties" do
      before(:each) do
        @loan = FactoryGirl.create(:loan_with_properties)
      end

      it "returns rental_properties value" do
        expect(@loan.rental_properties).not_to be_nil
      end
    end
  end

  describe ".num_of_years" do
    context "when num_of_months is nil" do
      it "returns nil" do
        loan.num_of_months = nil
        expect(loan.num_of_years).to be_nil
      end
    end

    context "when num_of_months is a valid number" do
      it "returns number of years" do
        loan.num_of_months = 24
        expect(loan.num_of_years).to eq(2)
      end
    end
  end

  describe ".purpose_titleize" do
    context "when purpose is nil" do
      it "returns nil" do
        loan.purpose = nil
        expect(loan.purpose_titleize).to be_nil
      end
    end

    context "when purpose is valid" do
      it "returns number of years" do
        loan.purpose = 1
        expect(loan.purpose_titleize).to eq("Refinance")
      end
    end
  end

  describe ".relationship_manager" do
    let(:loan_with_loan_member) { FactoryGirl.create(:loan_with_loan_member) }

    context "when loans_members_associations are empty" do
      it "returns nil if there is not any loans members associations" do
        loan.loans_members_associations = []
        expect(loan.relationship_manager).to be_nil
      end
    end

    context "when relationship manager is not existing" do
      let!(:sale) { FactoryGirl.create(:loan_members_title, title: "sale") }
      it "returns nil" do
        loan_with_loan_member.loans_members_associations.last
        loan_with_loan_member.loans_members_associations.last.update(loan_members_title: sale)
        expect(loan_with_loan_member.relationship_manager).to be_nil
      end
    end

    context "when loan_members_title is nil" do
      it "returns nil" do
        loan_with_loan_member.loans_members_associations.last
        loan_with_loan_member.loans_members_associations.last.update(loan_members_title: nil)
        expect(loan_with_loan_member.relationship_manager).to be_nil
      end
    end

    context "when loans_members_associations are valid" do
      let!(:manager) { FactoryGirl.create(:loan_members_title, title: "manager") }
      it "returns a loan member" do
        loan_with_loan_member.loans_members_associations.last.update(loan_members_title_id: manager.id)
        expect(loan_with_loan_member.relationship_manager).to be_a(LoanMember)
      end
    end
  end

  describe "#fixed_rate_amortization?" do
    context "with fixed rate" do
      it "returns true" do
        loan.amortization_type = "30 year fixed"
        expect(loan.fixed_rate_amortization?).to be_truthy
      end
    end

    context "with other types" do
      it "returns false" do
        loan.amortization_type = "LoremIpsum"
        expect(loan.fixed_rate_amortization?).to be_falsey
      end
    end
  end

  describe "#arm_amortization?" do
    context "with ARM" do
      it "returns true" do
        loan.amortization_type = "5/1 ARM"
        expect(loan.arm_amortization?).to be_truthy
      end
    end

    context "with other types" do
      it "returns false" do
        loan.amortization_type = "LoremIpsum"
        expect(loan.arm_amortization?).to be_falsey
      end
    end
  end

  describe "#pretty_status" do
    context "when status is nil" do
      it "returns nil" do
        loan.status = nil
        expect(loan.pretty_status).to be_nil
      end
    end

    context "when status is present" do
      it "returns a pretty title" do
        loan.approved!
        expect(loan.pretty_status).to eq("Approved")
      end
    end
  end
end
