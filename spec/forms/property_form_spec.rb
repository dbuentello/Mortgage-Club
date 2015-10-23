require "rails_helper"

describe PropertyForm do
  let!(:primary_property) { FactoryGirl.create(:property) }
  let!(:rental_property) { FactoryGirl.create(:property) }
  let!(:address) { FactoryGirl.create(:address) }

  before(:each) do
    @params = {
      "primary_property" => {
                                "id" => primary_property.id,
                     "property_type" => "duplex",
                             "usage" => "primary_residence",
                    "purchase_price" => 131804.0,
                      "market_price" => 12334234,
               "gross_rental_income" => 11232,
            "estimated_property_tax" => 213123,
        "estimated_hazard_insurance" => 12312,
      "estimated_mortgage_insurance" => 23123,
         "mortgage_includes_escrows" => "taxes_only",
                           "hoa_due" => 2131312,
                  "mortgage_payment" => 2,
                         "financing" => 2,
                        "is_primary" => "true",
                           "address" => {
                                "id" => address.id,
                    "street_address" => "124 Santa Monica Boulevard",
                               "zip" => "90401",
                             "state" => "CA",
                              "city" => "Santa Monica",
                         "full_text" => "124 Santa Monica Boulevard, Santa Monica, California, Hoa Kỳ"
                        },
      },
      "rental_properties" => {
          rental_property.id => {
                             "property_type" => "triplex",
                          "mortgage_payment" => 1,
                              "market_price" => 12345,
                                 "financing" => 1,
                 "mortgage_includes_escrows" => "taxes_only",
              "estimated_mortgage_insurance" => 12345
          },
          "0" => {
                             "property_type" => "triplex",
                          "mortgage_payment" => 1,
                              "market_price" => 12345,
                                 "financing" => 1,
                 "mortgage_includes_escrows" => "taxes_only",
              "estimated_mortgage_insurance" => 12345,
                        "address" => {
                    "street_address" => "227 Nguyen Van Cu",
                               "zip" => "70000",
                              "city" => "Ho Chi Minh",
                         "full_text" => "227 Nguyen Van Cu, Ho Chi Minh City, Vietnam"
                        },
          },
      }
    }

    @form = PropertyForm.new()
  end

  describe "#assign_value_to_attributes" do

    describe "#assign_attributes_for_existing_properties" do
    end

    describe "#assign_attributes_for_new_properties" do
    end
  end
end