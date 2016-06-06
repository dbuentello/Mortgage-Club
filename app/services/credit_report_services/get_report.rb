module CreditReportServices
  class GetReport
    # attr_reader :borrower_id, :first_name, :last_name, :ssn,
    #             :street_address, :city, :state, :zipcode
    attr_accessor :borrower, :co_borrower, :borrower_address, :co_borrower_address

    URL = "https://emscert.equifax.com/emsws/services/post/MergeCreditWWW"

    def initialize(borrower, co_borrower = nil)
      @borrower = borrower
      @borrower_address = borrower.current_address.address

      if co_borrower
        @co_borrower = co_borrower
        @co_borrower_address = co_borrower.current_address.address
      end
    end

    def call
      uri = URI.parse(URL)
      request = Net::HTTP::Post.new(uri.path)
      if co_borrower
        request.body = joint_xml_string
      else
        request.body = single_xml_string
      end
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

    def joint_xml_string
      "<?xml version='1.0' encoding='utf-8'?>
      <REQUEST_GROUP MISMOVersionID='2.3.1' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'><SUBMITTING_PARTY _Name='1183' _SequenceIdentifier='WFFE1' />
        <REQUEST LoginAccountPassword='xp9?47%Sww'
        LoginAccountIdentifier='999AUTO1' InternalAccountIdentifier='999AUTO1'
        RequestingPartyBranchIdentifier='QTP RPBranchId'><KEY _Name='TestCaseDescription' _Value='good generates report 1 borrower' />
          <KEY _Name='Cost_Center' _Value='1183' /><KEY _Name='HTMLFile' _Value='false' /><KEY _Name='EDI' _Value='true' /><KEY _Name='BranchId' _Value='QTP Branch' />
          <REQUEST_DATA>
            <CREDIT_REQUEST LenderCaseIdentifier='LOANNUMBER4'
            RequestingPartyRequestedByName='req by QTP'>
              <CREDIT_REQUEST_DATA CreditReportType='Merge'
                CreditRequestType='Joint'
                CreditRequestID='CreditRequest1'
                CreditReportRequestActionType='Submit'
                BorrowerID='1 2'>
                <CREDIT_REPOSITORY_INCLUDED
                _EquifaxIndicator='Y' _ExperianIndicator='Y' _TransUnionIndicator='Y' />
              </CREDIT_REQUEST_DATA>
              <LOAN_APPLICATION>
                <BORROWER BorrowerID='1' _FirstName='#{borrower.first_name}' _LastName='#{borrower.last_name}'
                _PrintPositionType='Borrower' _SSN='#{borrower.ssn}'>
                  <_RESIDENCE _StreetAddress='#{borrower_address.street_address}' _City='#{borrower_address.city}'
                  _State='#{borrower_address.state}' _PostalCode='#{borrower_address.zip}' BorrowerResidencyType='Current' />
                </BORROWER>
                <BORROWER BorrowerID='2' _FirstName='#{co_borrower.first_name}' _LastName='#{co_borrower.last_name}'
                _PrintPositionType='Borrower' _SSN='#{co_borrower.ssn}'>
                  <_RESIDENCE _StreetAddress='#{co_borrower_address.street_address}' _City='#{co_borrower_address.city}'
                  _State='#{co_borrower_address.state}' _PostalCode='#{co_borrower_address.zip}' BorrowerResidencyType='Current' />
                </BORROWER>
              </LOAN_APPLICATION>
            </CREDIT_REQUEST>
          </REQUEST_DATA>
        </REQUEST>
      </REQUEST_GROUP>"
    end

    def single_xml_string
      "<?xml version='1.0' encoding='utf-8'?>
      <REQUEST_GROUP MISMOVersionID='2.3.1' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'><SUBMITTING_PARTY _Name='1183' _SequenceIdentifier='WFFE1' />
        <REQUEST LoginAccountPassword='xp9?47%Sww'
        LoginAccountIdentifier='999AUTO1' InternalAccountIdentifier='999AUTO1'
        RequestingPartyBranchIdentifier='QTP RPBranchId'><KEY _Name='TestCaseDescription' _Value='good generates report 1 borrower' />
          <KEY _Name='Cost_Center' _Value='1183' /><KEY _Name='HTMLFile' _Value='false' /><KEY _Name='EDI' _Value='true' /><KEY _Name='BranchId' _Value='QTP Branch' /><REQUEST_DATA><CREDIT_REQUEST LenderCaseIdentifier='LOANNUMBER4'
            RequestingPartyRequestedByName='req by QTP'><CREDIT_REQUEST_DATA CreditReportType='Merge'
              CreditRequestType='Individual'
              CreditRequestID='CreditRequest1'
              CreditReportRequestActionType='Submit'
              BorrowerID='1'><CREDIT_REPOSITORY_INCLUDED
                _EquifaxIndicator='Y' _ExperianIndicator='Y' _TransUnionIndicator='Y' /></CREDIT_REQUEST_DATA><LOAN_APPLICATION><BORROWER BorrowerID='1' _FirstName='#{borrower.first_name}' _LastName='#{borrower.last_name}'
                _PrintPositionType='Borrower' _SSN='#{borrower.ssn}'><_RESIDENCE _StreetAddress='#{borrower_address.street_address}' _City='#{borrower_address.city}'
                  _State='#{borrower_address.state}' _PostalCode='#{borrower_address.zip}' BorrowerResidencyType='Current' /></BORROWER></LOAN_APPLICATION></CREDIT_REQUEST></REQUEST_DATA>
          </REQUEST>
      </REQUEST_GROUP>"
    end
  end
end
