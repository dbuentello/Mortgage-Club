module CreditReportServices
  class GetReport
    attr_reader :borrower_id, :first_name, :last_name, :ssn,
                :street_address, :city, :state, :zipcode

    URL = "https://emscert.equifax.com/emsws/services/post/MergeCreditWWW"

    def initialize(args)
      @borrower_id = args[:borrower_id]
      @first_name = args[:first_name]
      @last_name = args[:last_name]
      @ssn = args[:ssn]
      @street_address = args[:street_address]
      @city = args[:city]
      @state = args[:state]
      @zipcode = args[:zipcode]
    end

    def call
      uri = URI.parse(URL)
      request = Net::HTTP::Post.new(uri.path)
      request.body = xml_string
      request.content_type = "text/xml"
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      response = http.request(request)
      response.body if success?(response)
    end

    private

    def success?(response)
      return false if response.code != "200"

      doc = Nokogiri::XML(response.body)
      doc.css("RESPONSE RESPONSE_DATA CREDIT_RESPONSE").first.attributes["CreditReportType"].value != "Error"
    end

    def xml_string
      "<?xml version='1.0' encoding='utf-8'?>
      <REQUEST_GROUP MISMOVersionID='2.3.1' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'><SUBMITTING_PARTY _Name='1183' _SequenceIdentifier='WFFE1' />
        <REQUEST LoginAccountPassword='00wh/DCHwg0Cs'
        LoginAccountIdentifier='999MC60216' InternalAccountIdentifier='999MC60216'
        RequestingPartyBranchIdentifier='QTP RPBranchId'><KEY _Name='TestCaseDescription' _Value='good generates report 1 borrower' />
          <KEY _Name='Cost_Center' _Value='1183' /><KEY _Name='HTMLFile' _Value='false' /><KEY _Name='EDI' _Value='true' /><KEY _Name='BranchId' _Value='QTP Branch' /><REQUEST_DATA><CREDIT_REQUEST LenderCaseIdentifier='LOANNUMBER4'
            RequestingPartyRequestedByName='req by QTP'><CREDIT_REQUEST_DATA CreditReportType='Merge'
              CreditRequestType='Individual'
              CreditRequestID='CreditRequest1'
              CreditReportRequestActionType='Submit'
              BorrowerID='#{borrower_id}'><CREDIT_REPOSITORY_INCLUDED
                _EquifaxIndicator='Y' _ExperianIndicator='Y' _TransUnionIndicator='Y' /></CREDIT_REQUEST_DATA><LOAN_APPLICATION><BORROWER BorrowerID='#{borrower_id}' _FirstName='#{first_name}' _LastName='#{last_name}'
                _PrintPositionType='Borrower' _SSN='#{ssn}'><_RESIDENCE _StreetAddress='#{street_address}' _City='#{city}'
                  _State='#{state}' _PostalCode='#{zipcode}' BorrowerResidencyType='Current' /></BORROWER></LOAN_APPLICATION></CREDIT_REQUEST></REQUEST_DATA>
          </REQUEST>
      </REQUEST_GROUP>"
    end
  end
end
