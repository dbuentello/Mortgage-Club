require 'net/http'

xml_string = '<?xml version="1.0" encoding="utf-8"?><REQUEST_GROUP MISMOVersionID="2.3.1" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SUBMITTING_PARTY _Name="1183" _SequenceIdentifier="WFFE1" /><REQUEST LoginAccountPassword="xp9?47%Sww"
    LoginAccountIdentifier="999AUTO1" InternalAccountIdentifier="999AUTO1"
    RequestingPartyBranchIdentifier="QTP RPBranchId"><KEY _Name="TestCaseDescription" _Value="good generates report 1 borrower" /><KEY _Name="Cost_Center" _Value="1183" /><KEY _Name="HTMLFile" _Value="false" /><KEY _Name="EDI" _Value="true" /><KEY _Name="BranchId" _Value="QTP Branch" /><REQUEST_DATA><CREDIT_REQUEST LenderCaseIdentifier="LOANNUMBER4"
        RequestingPartyRequestedByName="req by QTP"><CREDIT_REQUEST_DATA CreditReportType="Merge"
          CreditRequestType="Individual"
          CreditRequestID="CreditRequest1"
          CreditReportRequestActionType="Submit"
          BorrowerID="B1"><CREDIT_REPOSITORY_INCLUDED
            _EquifaxIndicator="Y" _ExperianIndicator="Y" _TransUnionIndicator="Y" /></CREDIT_REQUEST_DATA><LOAN_APPLICATION><BORROWER BorrowerID="B1" _FirstName="Robert" _LastName="Ice"
            _PrintPositionType="Borrower" _SSN="301423221"><_RESIDENCE _StreetAddress="126 4th St" _City="Atlanta"
              _State="GA" _PostalCode="30014" BorrowerResidencyType="Current" /></BORROWER></LOAN_APPLICATION></CREDIT_REQUEST></REQUEST_DATA></REQUEST></REQUEST_GROUP>'

url_string = 'https://emscert.equifax.com/emsws/services/post/MergeCreditWWW'


uri = URI.parse url_string
request = Net::HTTP::Post.new uri.path

p request
request.body = xml_string
request.content_type = 'text/xml'
# response = Net::HTTP.new(uri.host, uri.port).start do |http|
#   http.use_ssl = true
#   http.request request
# end
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == "https")
response = http.request(request)
puts response
puts response.body

