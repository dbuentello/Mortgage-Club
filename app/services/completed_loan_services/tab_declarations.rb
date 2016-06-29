module CompletedLoanServices
  class TabDeclarations
    attr_accessor :declaration

    def initialize(declaration)
      @declaration = declaration
    end

    def call
      return false unless declaration

      declaration_completed?
    end

    def declaration_completed?
      return false if declaration.us_citizen.nil?
      return false if declaration.permanent_resident_alien.nil? && declaration.us_citizen == false
      return false if declaration.ownership_interest.nil?

      if declaration.ownership_interest == true
        return false if declaration.type_of_property.nil?
        return false if declaration.title_of_property.nil?
      end

      true
    end
  end
end
