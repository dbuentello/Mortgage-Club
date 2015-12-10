module LenderDocumentServices
  class UploadFile
    attr_accessor :args, :lender_document

    def initialize(args)
      @args = args
    end

    def call
      if args[:template][:is_other]
        @lender_document = LenderDocument.new(loan: args[:loan], lender_template: args[:template])
      else
        @lender_document = LenderDocument.find_or_initialize_by(loan: args[:loan], lender_template: args[:template])
      end

      @lender_document.attachment = args[:file]
      @lender_document.description = args[:description]
      @lender_document.user = args[:user]
      @lender_document.save
    end
  end
end
