module Docusign
  class AlignTabsForServicingDisclosureService
    attr_accessor :tabs

    def initialize(tabs)
      @tabs = tabs
    end

    def call
      @tabs[:text_tabs].each do |field|
        case field[:name]
        when "date"
          field[:x_position] = 460
          field[:y_position] = 90
        when *%w(assign_servicing_loan_before_first_payment loan_will_be_serviced assign_servicing_loan_outstanding)
          field[:x_position] = 69
          field[:y_position] = 349
        when *%w(lender_name lender_address)
          field[:x_position] = 107
          field[:y_position] = 90
        end
      end
      @tabs
    end
  end
end
