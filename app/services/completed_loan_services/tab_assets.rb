module CompletedLoanServices
  class TabAssets
    attr_accessor :assets, :rental_properties,
                  :primary_property, :subject_property,
                  :own_investment_property, :loan_refinance

    def initialize(args)
      @assets = args[:assets]
      @subject_property = args[:subject_property]
      @rental_properties = args[:rental_properties]
      @primary_property = args[:primary_property]
      @own_investment_property = args[:own_investment_property]
      @loan_refinance = args[:loan_refinance]
    end

    def call
      return false unless subject_property
      return false unless assets_completed?
      return false unless rental_properties_completed?
      return property_completed?(subject_property, is_refinance: loan_refinance) && property_completed?(primary_property) if available_primary_property?

      property_completed?(subject_property)
    end

    def assets_completed?
      return false if assets.empty?

      assets.each do |asset|
        return false unless asset_completed?(asset)
      end

      true
    end

    def rental_properties_completed?
      if own_investment_property
        rental_properties.each do |property|
          return false unless property_completed?(property, true)
        end
      end

      true
    end

    def available_primary_property?
      primary_property && primary_property != subject_property
    end

    def asset_completed?(asset)
      return false unless asset
      return false unless asset.institution_name.present?
      return false unless asset.asset_type
      return false unless asset.current_balance.present?

      true
    end

    def property_completed?(property, is_rental = false, is_refinance = false)
      return false unless property
      return false unless property.property_type.present?
      return false unless property.address.present?
      return false unless address_completed?(property.address)
      return false unless property.usage.present?
      return false unless property.market_price.present?
      return false if is_refinance && property.mortgage_includes_escrows.nil?
      return false unless property.estimated_property_tax.present?
      return false unless property.estimated_hazard_insurance.present?
      return false if is_rental && property.gross_rental_income.nil?

      true
    end

    def address_completed?(address)
      return false if address.street_address.blank? && address.city.blank? && address.state.blank? && address.street_address2.blank?

      address.full_text.present?
    end
  end
end
