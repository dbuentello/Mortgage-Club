require "rails_helper"

describe MortgageData do
  describe ".search" do
    context "Keyword matchs records" do
      let!(:mortgage_data) { FactoryGirl.create(:mortgage_data, property_address: "2309 Wilshire Boulevard, Santa Monica, CA") }
      let!(:mortgage_data_with_owner_name) { FactoryGirl.create(:mortgage_data, owner_name_1: "Taylor Swiff") }
      let!(:mortgage_data_with_another_owner_name) { FactoryGirl.create(:mortgage_data, owner_name_2: "Chris Hemsworth") }
      let!(:mortgage_data_array) { FactoryGirl.create_list(:mortgage_data, 3) }

      it "lists the array of records that have property_address containing keyword" do
        expect(described_class.search("2309 Wilshire Boulevard, Santa Monica")).to include(mortgage_data)
        expect(described_class.search("Taylor")).to include(mortgage_data_with_owner_name)
        expect(described_class.search("Hemsworth")).to include(mortgage_data_with_another_owner_name)
      end
    end

    context "Keyword does not match any record" do
      let!(:mortgage_data) { FactoryGirl.create(:mortgage_data, property_address: "2309 Wilshire Boulevard, Santa Monica, CA", owner_name_1: "Jennifer Lawrence", owner_name_2: "Emma Lawrence") }
      let!(:mortgage_data_with_owner_name) { FactoryGirl.create(:mortgage_data, property_address: "N. La Jolla Ave. Hollywood", owner_name_1: "Robert Downey Jr.", owner_name_2: "Liam Hemsworth") }
      let!(:mortgage_data_with_another_owner_name) { FactoryGirl.create(:mortgage_data, property_address: "Ozeta Terrace Hollywood", owner_name_1: "Lucia Ronnie", owner_name_2: "Chris Hemsworth") }

      it "returns an empty array" do
        expect(described_class.search("Tang Nguye")).to be_empty
      end
    end
  end
end
