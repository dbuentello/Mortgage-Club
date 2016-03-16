require "rails_helper"

describe BorrowerServices::AssignSecondaryBorrowerToLoan do
  let(:secondary_params) do
    {
      borrower: {
        first_name: "John",
        last_name: "Smith",
        middle_name: "Manh",
        suffix: "Mr",
        email: "linh@mortgageclub.co",
        password: "this-is-password",
        password_confirmation: "this-is-password"
      }
    }
  end

  before(:each) {
    allow_any_instance_of(Digest::MD5).to receive(:hexdigest).and_return "8820245fb6"
  }

  describe "#call" do
    let!(:loan) { FactoryGirl.create(:loan_with_all_associations) }

    context "when valid params" do
      it "calls CoBorrowerMailer with proper params" do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(CoBorrowerMailer).to receive(:notify_being_added).with(loan.id, is_new_user: false, default_password: nil).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)
        described_class.new(loan, secondary_params, nil).call
      end

      it "calls save method and returns true" do
        expect_any_instance_of(Loan).to receive(:save).and_return true
        described_class.new(loan, secondary_params, nil).call
      end
    end

    context "when invalid params" do
      it "returns nil with user params" do
        secondary_params[:borrower].delete(:first_name)
        described_class.new(loan, secondary_params, loan.secondary_borrower).call
      end
    end
  end
end
