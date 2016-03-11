module Docusign
  module Templates
    class GenericExplanation
      attr_accessor :loan, :borrower, :params

      def initialize(loan)
        @loan = loan
        @borrower = loan.borrower
        @params = {}
      end

      def build
        @params[:borrower_name] = "#{borrower.first_name} #{borrower.last_name}".titleize
        @params[:borrower_address] = borrower.display_current_address
        @params[:date_signed] = Time.zone.now.strftime("%m/%d/%Y")
        @params
      end
    end
  end
end
