require "rails_helper"

describe CompletedLoanServices::TabBorrower do
  let!(:loan) { FactoryGirl.create(:loan_with_secondary_borrower) }

  before(:each) do
    @service = CompletedLoanServices::TabBorrower.new({
      borrower: loan.borrower,
      secondary_borrower: loan.secondary_borrower
    })
  end

  it "returns true with borrower valid, secondary_borrower nil" do
    @service.secondary_borrower = nil
    expect(@service.call).to eq(true)
  end

  it "returns true with borrower, secondary borrower valid" do
    expect(@service.call).to eq(true)
  end

  context "with secondary borrower nil" do
    before do
      @service.secondary_borrower = nil
    end

    it "returns false with self employed nil" do
      @service.borrower.self_employed = nil
      expect(@service.call).to eq(false)
    end

    it "returns false with first name nil" do
      @service.borrower.first_name = nil
      expect(@service.call).to eq(false)
    end

    it "returns false with last name nil" do
      @service.borrower.last_name = nil
      expect(@service.call).to eq(false)
    end

    it "returns false with ssn nil" do
      @service.borrower.ssn = nil
      expect(@service.call).to eq(false)
    end

    it "returns false with dob nil" do
      @service.borrower.dob = nil
      expect(@service.call).to eq(false)
    end

    it "returns false with years in school nil" do
      @service.borrower.years_in_school = nil
      expect(@service.call).to eq(false)
    end

    it "returns false with marital status nil" do
      @service.borrower.marital_status = nil
      expect(@service.call).to eq(false)
    end

    it "returns false with dependent count nil" do
      @service.borrower.dependent_count = nil
      expect(@service.call).to eq(false)
    end

    it "returns false with dependent ages nil" do
      @service.borrower.dependent_count = 1
      @service.borrower.dependent_ages = nil
      expect(@service.call).to eq(false)
    end

    it "returns false with current address not exist" do
      @service.borrower.current_address.destroy
      expect(@service.call).to eq(false)
    end

    describe "checks current address" do
      it "returns false with is rental nil" do
        loan.borrower.borrower_addresses.find_by(is_current: true).update(is_rental: nil)
        expect(@service.call).to eq(false)
      end

      it "returns false with years at address nil" do
        loan.borrower.borrower_addresses.find_by(is_current: true).update(years_at_address: nil)
        expect(@service.call).to eq(false)
      end

      it "returns false with years at address smaller 0" do
        loan.borrower.borrower_addresses.find_by(is_current: true).update(years_at_address: -1)
        expect(@service.call).to eq(false)
      end

      it "returns false with rent house and monthly rent nil" do
        loan.borrower.borrower_addresses.find_by(is_current: true).update(is_rental: true, monthly_rent: nil)
        expect(@service.call).to eq(false)
      end
    end
  end

  context "with secondary borrower without nil" do
    describe "checks borrower" do
      it "returns false with self employed nil" do
        @service.borrower.self_employed = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with first name nil" do
        @service.borrower.first_name = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with last name nil" do
        @service.borrower.last_name = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with ssn nil" do
        @service.borrower.ssn = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with dob nil" do
        @service.borrower.dob = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with years in school nil" do
        @service.borrower.years_in_school = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with marital status nil" do
        @service.borrower.marital_status = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with dependent count nil" do
        @service.borrower.dependent_count = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with dependent ages nil" do
        @service.borrower.dependent_count = 1
        @service.borrower.dependent_ages = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with current address not exist" do
        @service.borrower.current_address.destroy
        expect(@service.call).to eq(false)
      end

      describe "checks current address" do
        it "returns false with is rental nil" do
          loan.borrower.borrower_addresses.find_by(is_current: true).update(is_rental: nil)
          expect(@service.call).to eq(false)
        end

        it "returns false with years at address nil" do
          loan.borrower.borrower_addresses.find_by(is_current: true).update(years_at_address: nil)
          expect(@service.call).to eq(false)
        end

        it "returns false with years at address smaller 0" do
          loan.borrower.borrower_addresses.find_by(is_current: true).update(years_at_address: -1)
          expect(@service.call).to eq(false)
        end

        it "returns false with rent house and monthly rent nil" do
          loan.borrower.borrower_addresses.find_by(is_current: true).update(is_rental: true, monthly_rent: nil)
          expect(@service.call).to eq(false)
        end
      end
    end
    describe "checks secondary borrower" do
      it "returns false with self employed nil" do
        @service.secondary_borrower.self_employed = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with first name nil" do
        @service.secondary_borrower.first_name = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with last name nil" do
        @service.secondary_borrower.last_name = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with ssn nil" do
        @service.secondary_borrower.ssn = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with dob nil" do
        @service.secondary_borrower.dob = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with years in school nil" do
        @service.secondary_borrower.years_in_school = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with marital status nil" do
        @service.secondary_borrower.marital_status = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with dependent count nil" do
        @service.secondary_borrower.dependent_count = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with dependent ages nil" do
        @service.secondary_borrower.dependent_count = 1
        @service.secondary_borrower.dependent_ages = nil
        expect(@service.call).to eq(false)
      end

      it "returns false with current address not exist" do
        @service.secondary_borrower.current_address.destroy
        expect(@service.call).to eq(false)
      end

      describe "checks current address" do
        it "returns false with is rental nil" do
          loan.secondary_borrower.borrower_addresses.find_by(is_current: true).update(is_rental: nil)
          expect(@service.call).to eq(false)
        end

        it "returns false with years at address nil" do
          loan.secondary_borrower.borrower_addresses.find_by(is_current: true).update(years_at_address: nil)
          expect(@service.call).to eq(false)
        end

        it "returns false with years at address smaller 0" do
          loan.secondary_borrower.borrower_addresses.find_by(is_current: true).update(years_at_address: -1)
          expect(@service.call).to eq(false)
        end

        it "returns false with rent house and monthly rent nil" do
          loan.secondary_borrower.borrower_addresses.find_by(is_current: true).update(is_rental: true, monthly_rent: nil)
          expect(@service.call).to eq(false)
        end
      end
    end
  end
end
