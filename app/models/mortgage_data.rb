class MortgageData < ActiveRecord::Base
  scope :search, -> (search) {where("property_address ILIKE ? OR owner_name_1 ILIKE ? OR owner_name_2 ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")}
end
