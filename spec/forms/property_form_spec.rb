require "rails_helper"

describe PropertyForm do
  let(:loan) { FactoryGirl.create(:loan_with_properties) }
  let(:subject_property) { loan.subject_property }
  let(:address) { FactoryGirl.create(:address) }

  before(:each) do
    @params = ActionController::Parameters.new({
      loan: {
        purpose: "purchase",
        down_payment: "52300.00"
      },
      subject_property: {
        id: subject_property.id,
        usage: "primary_residence",
        purchase_price: "323232.00",
        original_purchase_price: "122323.00",
        gross_rental_income: "3123.00",
        original_purchase_year: "2016",
        is_subject: "true",
        property_type: "",
        market_price: "323232.00"
      },
      address: {
        id: address.id,
        street_address: "2332 California Street",
        zip: "94115",
        state: "CA",
        city: "San Francisco",
        full_text: "2332 California Street, San Francisco, California, Hoa Kỳ"
      },
      loan_id: "9dd9c2ff-08b6-41b8-b4aa-a9468f4d3bba"
    })
  end

  describe "#save" do
    context "with purchase loan" do
      before(:each) do
        @params[:loan][:purpose] = "purchase"
        property_form = PropertyForm.new({
          loan: loan,
          subject_property: subject_property,
          address: address,
          params: @params
        })
        property_form.save
      end

      it "saves loan with proper values" do
        expect(loan.purchase?).to be_truthy
        expect(loan.down_payment).to eq(52_300.0)
      end

      it "updates right loan's amount" do
        expect(loan.amount).to eq(CalculateLoanAmountService.call(loan))
      end

      it "saves property with proper values" do
        expect(subject_property.usage).to eq("primary_residence")
        expect(subject_property.gross_rental_income).not_to eq(3_123.00)
        expect(subject_property.is_subject).to be_truthy
        expect(subject_property.market_price.to_f).to eq(323_232.00)
        expect(subject_property.purchase_price.to_f).to eq(323_232.00)
        expect(subject_property.original_purchase_price.to_f).not_to eq(122_323.00)
        expect(subject_property.original_purchase_year).not_to eq(2016)
      end

      it "saves address with proper values" do
        expect(address.street_address).to eq("2332 California Street")
        expect(address.zip).to eq("94115")
        expect(address.state).to eq("CA")
        expect(address.city).to eq("San Francisco")
        expect(address.full_text).to eq("2332 California Street, San Francisco, California, Hoa Kỳ")
      end
    end

    context "with refinance loan" do
      before(:each) do
        @params[:loan][:purpose] = "refinance"
        property_form = PropertyForm.new({
          loan: loan,
          subject_property: subject_property,
          address: address,
          params: @params
        })
        property_form.save
      end

      it "saves loan with proper values" do
        expect(loan.refinance?).to be_truthy
        expect(loan.down_payment).not_to eq(52_300.0)
      end

      it "updates right loan's amount" do
        expect(loan.amount).to eq(CalculateLoanAmountService.call(loan))
      end

      it "saves property with proper values" do
        expect(subject_property.usage).to eq("primary_residence")
        expect(subject_property.gross_rental_income).not_to eq(3_123.00)
        expect(subject_property.original_purchase_year).to eq(2016)
        expect(subject_property.is_subject).to be_truthy
        expect(subject_property.market_price.to_f).to eq(323_232.00)
        expect(subject_property.purchase_price.to_f).not_to eq(323_232.00)
        expect(subject_property.original_purchase_price.to_f).to eq(122_323.00)
      end
    end

    context "when property's usage is primary residence" do
      before(:each) do
        property_form = PropertyForm.new({
          loan: loan,
          subject_property: subject_property,
          address: address,
          params: @params
        })
        property_form.save
      end

      it "does not update gross rental income" do
        expect(subject_property.gross_rental_income).not_to eq(3_123.00)
      end
    end

    context "when property's usage is not primary residence" do
      before(:each) do
        @params[:subject_property][:usage] = "vacation_home"
        property_form = PropertyForm.new({
          loan: loan,
          subject_property: subject_property,
          address: address,
          params: @params
        })
        property_form.save
      end

      it "updates gross rental income" do
        expect(subject_property.gross_rental_income).to eq(3_123.00)
      end
    end
  end
end
