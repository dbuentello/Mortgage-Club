module CompletedLoanServices
  class TabAssets < Base
    def self.call(loan)
      @loan = loan

      return false unless @loan.subject_property

      @loan.borrower.assets.each do |asset|
        return false unless asset_completed?(asset)
      end

      if @loan.own_investment_property
        @loan.rental_properties.each do |property|
          return false unless property_completed?(property)
        end
      end

      if @loan.primary_property && @loan.primary_property != @loan.subject_property
        return property_completed?(@loan.subject_property) && property_completed?(@loan.primary_property)
      end

      property_completed?(@loan.subject_property)
    end

    def self.asset_completed?(asset)
      return false unless asset.institution_name.present?
      return false unless asset.asset_type
      return false unless asset.current_balance.present?

      true
    end

    def self.property_completed?(property)
      CompletedLoanServices::TabProperty.subject_property_completed?(property)
    end
  end
end
