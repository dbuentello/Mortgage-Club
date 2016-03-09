require "rails_helper"

describe BorrowerServices::AssignSecondaryBorrowerToLoan do
  before do
    @secondary_params =  {
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

    allow_any_instance_of(Digest::MD5).to receive(:hexdigest).and_return "8820245fb6"
  end

  describe "#call" do
    context "with valid params" do
      let!(:loan) { FactoryGirl.create(:loan_with_all_associations) }
      it "calls CoBorrowerMailer with proper params" do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(CoBorrowerMailer).to receive(:notify_being_added).with(loan.id, {is_new_user: false, default_password: nil}).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)
        described_class.new(loan, @secondary_params, nil).call
      end

      it "calls save params" do
        expect_any_instance_of(Loan).to receive(:save).and_return true
        described_class.new(loan, @secondary_params, nil).call
      end
    end
  end
end
