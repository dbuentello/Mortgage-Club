module CompletedLoanServices
  class TabAssets
    attr_accessor :assets, :rental_properties,
                  :primary_property, :subject_property,
                  :own_investment_property, :loan_refinance,
                  :borrower

    def initialize(args)
      @assets = args[:assets]
      @subject_property = args[:subject_property]
      @rental_properties = args[:rental_properties]
      @primary_property = args[:primary_property]
      @own_investment_property = args[:own_investment_property]
      @loan_refinance = args[:loan_refinance]
      @borrower = args[:borrower]
    end

    def call
      return false unless borrower
      return false unless borrower.current_address

      return false unless subject_property
      return false unless assets_completed?
      return false unless rental_properties_completed?
      return property_completed?(subject_property) && property_completed?(primary_property) if available_primary_property?

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
      primary_property && primary_property.id != subject_property.id && subject_property.is_primary == false
    end

    def asset_completed?(asset)
      return false unless asset
      return false unless asset.institution_name.present?
      return false unless asset.asset_type
      return false unless asset.current_balance.present?

      true
    end

    def property_completed?(property, is_rental = false)
      return false unless property
      return false unless property.property_type.present?

      if property.is_primary && property.is_subject == false
        return false unless address_completed?(false, borrower.current_address.address)
      else
        return false unless address_completed?(is_rental, property.address)
      end

      return false unless property.usage.present?
      return false unless property.market_price.present?
      return false if loan_refinance && property.mortgage_includes_escrows.nil?
      return false unless property.estimated_property_tax.present?
      return false unless property.estimated_hazard_insurance.present?

      if is_rental
        return false if property.mortgage_includes_escrows.nil?
        return false if property.gross_rental_income.nil?
      end

      true
    end

    def address_completed?(is_rental, address)
      return false unless address.present?

      if is_rental
        return false if address.street_address.blank? && address.city.blank? && address.state.blank? && address.zip.blank? && address.street_address2.blank?
      else
        return false if address.street_address.blank? || address.city.blank? || address.state.blank? || address.zip.blank?
      end

      address.full_text.present?
    end
  end
end
