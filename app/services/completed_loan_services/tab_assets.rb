module CompletedLoanServices
  class TabAssets
    attr_accessor :assets, :rental_properties,
                  :primary_property, :subject_property,
                  :own_investment_property

    def initialize(args)
      @assets = args[:assets]
      @subject_property = args[:subject_property]
      @rental_properties = args[:rental_properties]
      @primary_property = args[:primary_property]
      @own_investment_property = args[:own_investment_property]
    end

    def call
      return false unless subject_property

      assets.each do |asset|
        return false unless asset_completed?(asset)
      end

      if own_investment_property
        rental_properties.each do |property|
          return false unless property_completed?(property)
        end
      end

      if primary_property && primary_property != subject_property
        return property_completed?(subject_property) && property_completed?(primary_property)
      end

      property_completed?(subject_property)
    end

    def asset_completed?(asset)
      return false unless asset.institution_name.present?
      return false unless asset.asset_type
      return false unless asset.current_balance.present?

      true
    end

    def property_completed?(property)
      false
      # CompletedLoanServices::TabProperty.subject_property_completed?(property)
    end
  end
end
