# rubocop:disable ClassLength
# rubocop:disable LineLength
# rubocop:disable MethodLength

module CreditReportServices
  #
  # Class GetReport provides getting report from Equifax
  #
  class GetReport
    attr_accessor :borrower, :co_borrower, :borrower_address, :co_borrower_address

    URL = "https://emsws.equifax.com/emsws/services/post/MergeCreditWWW"
    TEST_URL = "https://emscert.equifax.com/emsws/services/post/MergeCreditWWW"

    def initialize(borrower, co_borrower = nil)
      @borrower = borrower
      @borrower_address = borrower.current_address.address

      if co_borrower
        @co_borrower = co_borrower
        @co_borrower_address = co_borrower.current_address.address
      end
    end

    #
    # Map borrower's values to single_xml_string
    # Map values of borrower and co-borrower to joint_xml_string
    #
    #
    def call
      if borrower.user.first_name == "Mortgage" && borrower.user.last_name == "Club" && borrower.ssn == "111-11-1111"
        return response_xml_sample
      end

      uri = get_uri
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

    def get_uri
      Rails.env.test? ? URI.parse(TEST_URL) : URI.parse(URL)
    end

    def success?(response)
      return false if response.code != "200"

      doc = Nokogiri::XML(response.body)
      doc.css("RESPONSE RESPONSE_DATA CREDIT_RESPONSE").first.attributes["CreditReportType"].value != "Error"
    end

    def joint_xml_string
      account = Rails.env.test? ? "999AUTO1" : "187FM00207"
      password = Rails.env.test? ? "xp9?47%Sww" : "00y2.ZGXh.u3g"

      "<?xml version='1.0' encoding='utf-8'?>
      <REQUEST_GROUP MISMOVersionID='2.3.1' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'><SUBMITTING_PARTY _Name='1183' _SequenceIdentifier='WFFE1' />
        <REQUEST LoginAccountPassword='#{password}'
        LoginAccountIdentifier='#{account}' InternalAccountIdentifier='#{account}'
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
      account = Rails.env.test? ? "999AUTO1" : "187FM00207"
      password = Rails.env.test? ? "xp9?47%Sww" : "00y2.ZGXh.u3g"

      "<?xml version='1.0' encoding='utf-8'?>
      <REQUEST_GROUP MISMOVersionID='2.3.1' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'><SUBMITTING_PARTY _Name='1183' _SequenceIdentifier='WFFE1' />
        <REQUEST LoginAccountPassword='#{password}'
        LoginAccountIdentifier='#{account}' InternalAccountIdentifier='#{account}'
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

    def response_xml_sample
      '<?xml version="1.0" encoding="UTF-8"?><RESPONSE_GROUP MISMOVersionID="2.3.1">
          <RESPONDING_PARTY _City="ALPHARETTA" _Name="EQUIFAX MORTGAGE SOLUTIONS" _PostalCode="30005" _State="GA" _StreetAddress="1505 WINDWARD CONCOURSE">
            <CONTACT_DETAIL>
              <CONTACT_POINT _Type="Phone" _Value="770-740-6613"/>
            </CONTACT_DETAIL>
            <CONTACT_DETAIL>
              <CONTACT_POINT _Type="Fax" _Value="770-740-6125"/>
            </CONTACT_DETAIL>
          </RESPONDING_PARTY>
          <RESPOND_TO_PARTY _City="ALPHARETTA" _Name="EMS TEST 2X PURE XML TEST ACCOUNT" _PostalCode="30005" _State="GA" _StreetAddress="1525 WINDWARD CONCOURSE">
            <CONTACT_DETAIL _Name="req by QTP"/>
          </RESPOND_TO_PARTY>
          <RESPONSE InternalAccountIdentifier="999AUTO1" ResponseDateTime="2016-06-19">
            <KEY _Name="CreditScoreRankPercent_CRV7FF12_CRScr0000" _Value="4"/>
            <KEY _Name="EquifaxBeacon5.0_MinimumValue" _Value="334"/>
            <KEY _Name="EquifaxBeacon5.0_MaximumValue" _Value="818"/>
            <KEY _Name="CreditScoreRankPercent_CRV7FF12_CRScr0001" _Value="52"/>
            <KEY _Name="ExperianFairIsaac_MinimumValue" _Value="320"/>
            <KEY _Name="ExperianFairIsaac_MaximumValue" _Value="844"/>
            <KEY _Name="CreditScoreRankPercent_CRV7FF12_CRScr0002" _Value="92"/>
            <KEY _Name="FICORiskScoreClassic04_MinimumValue" _Value="309"/>
            <KEY _Name="FICORiskScoreClassic04_MaximumValue" _Value="839"/>
            <KEY _Name="TestCaseDescription" _Value="good generates report 1 borrower"/>
            <KEY _Name="Cost_Center" _Value="1183"/>
            <KEY _Name="HTMLFile" _Value="false"/>
            <KEY _Name="EDI" _Value="true"/>
            <KEY _Name="BranchId" _Value="QTP Branch"/>
            <KEY _Name="BRANCHID" _Value="QTP RPBranchId"/>
            <RESPONSE_DATA>
              <CREDIT_RESPONSE CreditRatingCodeType="Experian" CreditReportFirstIssuedDate="2016-06-19" CreditReportIdentifier="V7FF12" CreditReportLastUpdatedDate="2016-06-19" CreditReportMergeType="Blend" CreditReportType="Merge" CreditResponseID="CRV7FF12" MISMOVersionID="2.3.1">
                <_DATA_INFORMATION>
                  <DATA_VERSION _Name="Equifax" _Number="5"/>
                  <DATA_VERSION _Name="Experian" _Number="7"/>
                  <DATA_VERSION _Name="Trans Union" _Number="4"/>
                </_DATA_INFORMATION>
                <CREDIT_BUREAU _City="ALPHARETTA" _DisclaimerText="The reporting bureau certifies that; (a) public   records have been checked for tax liens, judgments, foreclosures,   garnishments, bankruptcies, and other legal actions involving the   subject(s) with the results indicated above; or (b) equivalent   information has been obtained through the use of a qualified   public records reporting service with the results indicated   above.  The records of real estate transfers which do not   involve foreclosures may be excluded.     Equifax Credit Services certifies that the information provided   in this report meets the requirements of the U.S. Dept. of HUD,   FHA, VA, USDA, RECD &amp; FSA, Fannie Mae and FHLMC.     The information is confidential and not to be divulged except   as required by PUBLIC LAW 91-508, 93-579, 94-239." _Name="EQUIFAX MORTGAGE SOLUTIONS" _PostalCode="30005" _State="GA" _StreetAddress="1505 WINDWARD CONCOURSE">
                  <CONTACT_DETAIL>
                    <CONTACT_POINT _Type="Phone" _Value="770-740-6613"/>
                  </CONTACT_DETAIL>
                  <CONTACT_DETAIL>
                    <CONTACT_POINT _Type="Fax" _Value="770-740-6125"/>
                  </CONTACT_DETAIL>
                </CREDIT_BUREAU>
                <CREDIT_REPORT_PRICE _Amount="4.33" _Type="Total"/>
                <CREDIT_REPOSITORY_INCLUDED _EquifaxIndicator="Y" _ExperianIndicator="Y" _TransUnionIndicator="Y"/>
                <REQUESTING_PARTY InternalAccountIdentifier="999AUTO1" LenderCaseIdentifier="LOANNUMBER4" _City="ALPHARETTA" _Name="EMS TEST 2X PURE XML TEST ACCOUNT" _PostalCode="30005" _RequestedByName="req by QTP" _State="GA" _StreetAddress="1525 WINDWARD CONCOURSE">
                  <CONTACT_DETAIL _Name="req by QTP"/>
                </REQUESTING_PARTY>
                <CREDIT_REQUEST_DATA BorrowerID="1" CreditReportIdentifier="V7FF12" CreditReportRequestActionType="Submit" CreditReportType="Merge" CreditRepositoriesSelectedCount="3" CreditRequestDateTime="2016-06-19" CreditRequestID="CreditRequest1" CreditRequestType="Individual">
                  <CREDIT_REPOSITORY_INCLUDED _EquifaxIndicator="Y" _ExperianIndicator="Y" _TransUnionIndicator="Y"/>
                </CREDIT_REQUEST_DATA>
                <BORROWER BorrowerID="1" MaritalStatusType="Unknown" _FirstName="MORTGAGE" _LastName="CLUB" _MaritalStatus="UNKNOWN" _PrintPositionType="Borrower" _SSN="111-11-1111">
                  <_RESIDENCE BorrowerResidencyType="Current" _City="SAN FRANCISCO" _PostalCode="94105" _State="CA" _StreetAddress="156 2ND STREET"/>
                </BORROWER>

                <CREDIT_LIABILITY BorrowerID="1" CreditBusinessType="Finance" CreditFileID="B-EFX-01" CreditLiabilityID="TRD0000" CreditLoanType="RealEstateSpecificTypeUnknown" CreditTradeReferenceID="CTR0000" _AccountIdentifier="1234561421105" _AccountOpenedDate="2000-08" _AccountOwnershipType="Individual" _AccountReportedDate="2016-04" _AccountStatusDate="2016-04" _AccountStatusType="Open" _AccountType="Mortgage" _ConsumerDisputeIndicator="N" _DerogatoryDataIndicator="N" _HighBalanceAmount="417000" _HighCreditAmount="134000" _LastActivityDate="2016-04" _MonthlyPaymentAmount="2032" _MonthsReviewedCount="84" _TermsDescription="MONTHLY" _TermsSourceType="Provided" _UnpaidBalanceAmount="400000">
                  <_CREDITOR _City="PLANO" _Name="GREENP MTG" _PostalCode="75024" _State="TX" _StreetAddress="7933 PRESTON RD MAIL CODE 310630110">
                    <CONTACT_DETAIL>
                      <CONTACT_POINT _Type="Phone" _Value="7066496700"/>
                    </CONTACT_DETAIL>
                  </_CREDITOR>
                  <_CURRENT_RATING _Code="1" _Type="AsAgreed"/>
                  <_LATE_COUNT _30Days="0" _60Days="0" _90Days="0"/>
                  <CREDIT_COMMENT _SourceType="CreditBureau" _Type="BureauRemarks">
                    <_Text>CONVENTIONAL MORTGAGE</_Text>
                  </CREDIT_COMMENT>
                  <CREDIT_COMMENT _SourceType="CreditBureau" _Type="BureauRemarks">
                    <_Text>REAL ESTATE MORTGAGE</_Text>
                  </CREDIT_COMMENT>
                  <CREDIT_REPOSITORY _SourceType="Equifax" _SubscriberCode="822FM00288"/>
                </CREDIT_LIABILITY>

                <CREDIT_LIABILITY BorrowerID="1" CreditBusinessType="DepartmentAndMailOrder" CreditFileID="B-TU-01" CreditLiabilityID="TRD0002" CreditLoanType="ChargeAccount" CreditTradeReferenceID="CTR0002" _AccountIdentifier="2665544304" _AccountOpenedDate="2001-06" _AccountOwnershipType="Individual" _AccountReportedDate="2016-04" _AccountStatusDate="2016-04" _AccountStatusType="Open" _AccountType="Revolving" _ConsumerDisputeIndicator="N" _CreditLimitAmount="1500" _DerogatoryDataIndicator="N" _HighBalanceAmount="1500" _HighCreditAmount="1500" _LastActivityDate="2013-04" _MonthlyPaymentAmount="50" _MonthsReviewedCount="9" _PastDueAmount="0" _TermsDescription="MIN" _TermsSourceType="Provided" _UnpaidBalanceAmount="1410">
                  <_CREDITOR _City="MASON" _Name="BURDIN/FDSB" _PostalCode="45040" _State="OH" _StreetAddress="9111 DUKE BLVD">
                    <CONTACT_DETAIL>
                      <CONTACT_POINT _Type="Phone" _Value="8002847049"/>
                    </CONTACT_DETAIL>
                  </_CREDITOR>
                  <_CURRENT_RATING _Code="1" _Type="AsAgreed"/>
                  <_LATE_COUNT _30Days="0" _60Days="0" _90Days="0"/>
                  <_PAYMENT_PATTERN _Data="CCXXXXCCC" _StartDate="2013-04"/>
                  <CREDIT_REPOSITORY _SourceType="TransUnion" _SubscriberCode="D 0635D001"/>
                </CREDIT_LIABILITY>

                <CREDIT_LIABILITY BorrowerID="1" CreditBusinessType="Banking" CreditFileID="B-TU-01" CreditLiabilityID="TRD0003" CreditLoanType="CreditCard" CreditTradeReferenceID="CTR0003" _AccountIdentifier="6783XXXX3041" _AccountOpenedDate="1993-11" _AccountOwnershipType="Individual" _AccountReportedDate="2016-04" _AccountStatusDate="2016-04" _AccountStatusType="Open" _AccountType="Revolving" _ConsumerDisputeIndicator="N" _CreditLimitAmount="5400" _DerogatoryDataIndicator="N" _HighBalanceAmount="5400" _HighCreditAmount="5400" _LastActivityDate="2013-04" _MonthsReviewedCount="48" _PastDueAmount="0" _TermsDescription="MONTHLY" _UnpaidBalanceAmount="0">
                  <_CREDITOR _City="SIOUX FALLS" _Name="CITI" _PostalCode="57117" _State="SD" _StreetAddress="POB 6241">
                    <CONTACT_DETAIL>
                      <CONTACT_POINT _Type="Phone" _Value="8008430777"/>
                    </CONTACT_DETAIL>
                  </_CREDITOR>
                  <_CURRENT_RATING _Code="1" _Type="AsAgreed"/>
                  <_LATE_COUNT _30Days="0" _60Days="0" _90Days="0"/>
                  <_PAYMENT_PATTERN _Data="CCCCCCCCCCCCCCCCCCCCXCCCCCCCCCCCCCCCCCCXCCCC" _StartDate="2013-04"/>
                  <CREDIT_REPOSITORY _SourceType="TransUnion" _SubscriberCode="B 064DB002"/>
                </CREDIT_LIABILITY>

                <CREDIT_LIABILITY BorrowerID="1" CreditBusinessType="DepartmentAndMailOrder" CreditFileID="B-TU-01" CreditLiabilityID="TRD0006" CreditLoanType="ChargeAccount" CreditTradeReferenceID="CTR0006" _AccountIdentifier="153211234567" _AccountOpenedDate="2009-03" _AccountOwnershipType="Individual" _AccountReportedDate="2016-04" _AccountStatusDate="2016-04" _AccountStatusType="Open" _AccountType="Revolving" _ConsumerDisputeIndicator="N" _CreditLimitAmount="500" _DerogatoryDataIndicator="N" _HighBalanceAmount="500" _HighCreditAmount="500" _LastActivityDate="2013-04" _MonthsReviewedCount="3" _PastDueAmount="0" _TermsDescription="MONTHLY" _UnpaidBalanceAmount="0">
                  <_CREDITOR _City="MASON" _Name="MACYS/GECCCC" _PostalCode="45040" _State="OH" _StreetAddress="9111 DUKE BLVD">
                    <CONTACT_DETAIL>
                      <CONTACT_POINT _Type="Phone" _Value="8002847049"/>
                    </CONTACT_DETAIL>
                  </_CREDITOR>
                  <_CURRENT_RATING _Code="1" _Type="AsAgreed"/>
                  <_LATE_COUNT _30Days="0" _60Days="0" _90Days="0"/>
                  <CREDIT_COMMENT _SourceType="CreditBureau" _Type="BureauRemarks">
                    <_Text>COLLATERAL: BRCL3C DL1532</_Text>
                  </CREDIT_COMMENT>
                  <CREDIT_REPOSITORY _SourceType="TransUnion" _SubscriberCode="D 0729D015"/>
                </CREDIT_LIABILITY>

                <CREDIT_LIABILITY BorrowerID="1" CreditBusinessType="Banking" CreditFileID="B-EFX-01" CreditLiabilityID="TRD0008" CreditLoanType="CreditCard" CreditTradeReferenceID="CTR0008" _AccountIdentifier="7012510104884453" _AccountOpenedDate="2009-04" _AccountOwnershipType="Individual" _AccountReportedDate="2016-04" _AccountStatusDate="2016-04" _AccountStatusType="Open" _AccountType="Revolving" _ConsumerDisputeIndicator="N" _CreditLimitAmount="6700" _DerogatoryDataIndicator="N" _HighBalanceAmount="6700" _LastActivityDate="2016-04" _MonthsReviewedCount="2" _TermsDescription="MONTHLY" _UnpaidBalanceAmount="0">
                  <_CREDITOR _City="THE LAKES" _Name="SEARS" _PostalCode="89163" _State="NV" _StreetAddress="8725 W. SAHARA AVE MC 02 02 03"/>
                  <_CURRENT_RATING _Code="1" _Type="AsAgreed"/>
                  <_LATE_COUNT _30Days="0" _60Days="0" _90Days="0"/>
                  <CREDIT_COMMENT _SourceType="CreditBureau" _Type="BureauRemarks">
                    <_Text>CREDIT CARD</_Text>
                  </CREDIT_COMMENT>
                  <CREDIT_COMMENT _SourceType="CreditBureau" _Type="BureauRemarks">
                    <_Text>AMT IN HIGH CREDIT IS CREDIT LIMIT</_Text>
                  </CREDIT_COMMENT>
                  <CREDIT_REPOSITORY _SourceType="Equifax" _SubscriberCode="906BB05577"/>
                </CREDIT_LIABILITY>

                <CREDIT_FILE BorrowerID="1" CreditFileID="B-EFX-01" CreditRepositorySourceType="Equifax" CreditScoreID="CRScr0000">
                  <_ALERT_MESSAGE _CategoryType="FACTAAddressDiscrepancy" _Code=" " _Type="Other" _TypeOtherDescription="FACTA">
                    <_Text>FACTA: Address Discrepancy - ADDRESS ELEMENTS WERE UNAVAILABLE OR NOT UTILIZED.</_Text>
                  </_ALERT_MESSAGE>
                  <_BORROWER _FirstName="MORTGAGE" _LastName="CLUB" _SSN="111111111" _UnparsedName="MORTGAGE CLUB">
                    <_ALIAS _FirstName="MORTGAGE" _LastName="CLUB" _UnparsedName="MORTGAGE CLUB"/>
                    <EMPLOYER EmploymentPositionDescription="MGR" _Name="MORRELL GROUP"/>
                    <_UnparsedEmployment>MORTGAGECLUB CORPORATION</_UnparsedEmployment>
                  </_BORROWER>
                  <_VARIATION _Type="DifferentName"/>
                  <_VARIATION _Type="DifferentAddress"/>
                </CREDIT_FILE>

                <CREDIT_FILE BorrowerID="1" CreditFileID="B-XPN-01" CreditRepositorySourceType="Experian" CreditScoreID="CRScr0001">
                  <_ALERT_MESSAGE _CategoryType="FACTAAddressDiscrepancy" _Code="1" _Type="Other" _TypeOtherDescription="FACTA">
                    <_Text>FACTA: Address Discrepancy - RPTD VIA A/R TAPE, BUT DIFFERENT FROM INQUIRY.</_Text>
                  </_ALERT_MESSAGE>
                  <_BORROWER _FirstName="MORTGAGE" _LastName="CLUB" _MiddleName="R" _SSN="111111111" _UnparsedName="MORTGAGE CLUB">
                    <_ALIAS _LastName="ICE" _MiddleName="L " _NameSuffix="JR" _UnparsedName="ROBERT L ICE JR"/>
                    <_ALIAS _LastName="ICE" _NameSuffix="JR" _UnparsedName="ROBERT ICE JR"/>
                    <EMPLOYER CurrentEmploymentStartDate="2001-08-01" EmploymentPositionDescription="NO TITLE FROM REPOSITORY" PreviousEmploymentEndDate="2001-08-01" _Name="NASA"/>
                    <EMPLOYER CurrentEmploymentStartDate="2000-06-01" EmploymentPositionDescription="NO TITLE FROM REPOSITORY" PreviousEmploymentEndDate="2000-06-01" _Name="WORK"/>
                    <_UnparsedEmployment>NASA, 08/01/2001-08/01/2001</_UnparsedEmployment>
                    <_UnparsedEmployment>WORK, 06/01/2000-06/01/2000</_UnparsedEmployment>
                  </_BORROWER>
                  <_VARIATION _Type="DifferentName"/>
                  <_VARIATION _Type="DifferentAddress"/>
                </CREDIT_FILE>
                <CREDIT_FILE BorrowerID="1" CreditFileID="B-TU-01" CreditRepositorySourceType="TransUnion" CreditScoreID="CRScr0002">
                  <_ALERT_MESSAGE _Type="TransUnionHAWKAlert">
                    <_Text>AVAILABLE AND CLEAR</_Text>
                  </_ALERT_MESSAGE>
                  <_BORROWER _BirthDate="1959-08-01" _FirstName="ROBERT" _LastName="ICE" _MiddleName="V" _SSN="301423221" _UnparsedName="ROBERT V ICE">
                    <EMPLOYER CurrentEmploymentStartDate="1988-05-01" EmploymentPositionDescription="DISTRIBUTOR" EmploymentReportedDate="1988-05-01" _City="DOWNINGS" _Name="PEPPERIDGE FARM INC" _State="NY">
                      <VERIFICATION _ByName="ICE, ROBERT V" _Date="1988-05-01" _StatusType="Verified"/>
                    </EMPLOYER>
                    <_UnparsedEmployment>PEPPERIDGE FARM INC, UNK</_UnparsedEmployment>
                  </_BORROWER>
                  <_VARIATION _Type="DifferentName"/>
                  <_VARIATION _Type="DifferentAddress"/>
                  <_VARIATION _Type="DifferentBirthDate"/>
                </CREDIT_FILE>
                <CREDIT_SCORE BorrowerID="1" CreditFileID="B-EFX-01" CreditReportIdentifier="V7FF12" CreditRepositorySourceType="Equifax" CreditScoreID="CRScr0000" _Date="2009-06-01" _ModelNameType="EquifaxBeacon5.0" _Value="00740">
                  <_FACTOR _Code="00014" _Text="LENGTH OF TIME ACCOUNTS HAVE BEEN ESTABLISHED"/>
                  <_FACTOR _Code="00004" _Text="TOO MANY BANK OR NATIONAL REVOLVING ACCOUNTS"/>
                  <_FACTOR _Code="00005" _Text="TOO MANY ACCOUNTS WITH BALANCES"/>
                  <_FACTOR _Code="00032" _Text="LACK OF RECENT INSTALLMENT LOAN INFORMATION"/>
                </CREDIT_SCORE>
                <CREDIT_SCORE BorrowerID="1" CreditFileID="B-XPN-01" CreditReportIdentifier="V7FF12" CreditRepositorySourceType="Experian" CreditScoreID="CRScr0001" _Date="2001-09-12" _ModelNameType="ExperianFairIsaac" _Value="0750">
                  <_FACTOR _Code="08" _Text="TOO MANY INQUIRIES LAST 12 MONTHS "/>
                  <_FACTOR _Code="14" _Text="LENGTH OF TIME ACCOUNTS HAVE BEEN ESTABLISHED "/>
                  <_FACTOR _Code="30" _Text="TIME SINCE MOST RECENT ACCOUNT OPENING IS TOO SHORT "/>
                  <_FACTOR _Code="06" _Text="TOO MANY CONSUMER FINANCE COMPANY ACCOUNTS "/>
                </CREDIT_SCORE>
                <CREDIT_SCORE BorrowerID="1" CreditFileID="B-TU-01" CreditReportIdentifier="V7FF12" CreditRepositorySourceType="TransUnion" CreditScoreID="CRScr0002" _Date="2002-04-11" _ModelNameType="FICORiskScoreClassic04" _Value="00809">
                  <_FACTOR _Code="012" _Text="LENGTH OF TIME REVOLVING ACCOUNTS HAVE BEEN ESTABLISHED"/>
                  <_FACTOR _Code="029" _Text="NO RECENT BANKCARD BALANCES"/>
                  <_FACTOR _Code="005" _Text="TOO MANY ACCOUNTS WITH BALANCES"/>
                </CREDIT_SCORE>
                <CREDIT_TRADE_REFERENCE CreditTradeReferenceID="CTR0000" _City="PLANO" _Name="GREENP MTG" _PostalCode="75024" _State="TX" _StreetAddress="7933 PRESTON RD MAIL CODE 310630110">
                  <CONTACT_DETAIL>
                    <CONTACT_POINT _Type="Phone" _Value="7066496700"/>
                  </CONTACT_DETAIL>
                  <CREDIT_REPOSITORY _SourceType="Equifax" _SubscriberCode="822FM00288"/>
                </CREDIT_TRADE_REFERENCE>
                <CREDIT_TRADE_REFERENCE CreditTradeReferenceID="CTR0001" _City="ATLANTA" _Name="BANKAMERIC" _PostalCode="30302" _State="GA" _StreetAddress="PO BOX 50368">
                  <CREDIT_REPOSITORY _SourceType="Equifax" _SubscriberCode="401BB02330"/>
                </CREDIT_TRADE_REFERENCE>
                <CREDIT_TRADE_REFERENCE CreditTradeReferenceID="CTR0002" _City="MASON" _Name="BURDIN/FDSB" _PostalCode="45040" _State="OH" _StreetAddress="9111 DUKE BLVD">
                  <CONTACT_DETAIL>
                    <CONTACT_POINT _Type="Phone" _Value="8002847049"/>
                  </CONTACT_DETAIL>
                  <CREDIT_REPOSITORY _SourceType="TransUnion" _SubscriberCode="D 0635D001"/>
                </CREDIT_TRADE_REFERENCE>
                <CREDIT_TRADE_REFERENCE CreditTradeReferenceID="CTR0003" _City="SIOUX FALLS" _Name="CITI" _PostalCode="57117" _State="SD" _StreetAddress="POB 6241">
                  <CONTACT_DETAIL>
                    <CONTACT_POINT _Type="Phone" _Value="8008430777"/>
                  </CONTACT_DETAIL>
                  <CREDIT_REPOSITORY _SourceType="TransUnion" _SubscriberCode="B 064DB002"/>
                </CREDIT_TRADE_REFERENCE>
                <CREDIT_TRADE_REFERENCE CreditTradeReferenceID="CTR0004" _City="GAITHERSBURG" _Name="CITICORP" _PostalCode="20898" _State="MD" _StreetAddress="PO BOX 9438 DEPT 0251">
                  <CONTACT_DETAIL>
                    <CONTACT_POINT _Type="Phone" _Value="8002837918"/>
                  </CONTACT_DETAIL>
                  <CREDIT_REPOSITORY _SourceType="Equifax" _SubscriberCode="906FM06418"/>
                </CREDIT_TRADE_REFERENCE>
                <CREDIT_TRADE_REFERENCE CreditTradeReferenceID="CTR0005" _City="NEWARK" _Name="CITIFINANCIAL RETAIL" _PostalCode="19714" _State="DE" _StreetAddress="PO BOX 6080">
                  <CONTACT_DETAIL>
                    <CONTACT_POINT _Type="Phone" _Value="3024545616"/>
                  </CONTACT_DETAIL>
                  <CREDIT_REPOSITORY _SourceType="Experian" _SubscriberCode="1138180"/>
                </CREDIT_TRADE_REFERENCE>
                <CREDIT_TRADE_REFERENCE CreditTradeReferenceID="CTR0006" _City="MASON" _Name="MACYS/GECCCC" _PostalCode="45040" _State="OH" _StreetAddress="9111 DUKE BLVD">
                  <CONTACT_DETAIL>
                    <CONTACT_POINT _Type="Phone" _Value="8002847049"/>
                  </CONTACT_DETAIL>
                  <CREDIT_REPOSITORY _SourceType="TransUnion" _SubscriberCode="D 0729D015"/>
                </CREDIT_TRADE_REFERENCE>
                <CREDIT_TRADE_REFERENCE CreditTradeReferenceID="CTR0007" _City="OKLAHOMA CITY" _Name="MIDLAND MG" _PostalCode="73126" _State="OK" _StreetAddress="PO BOX 268959 F  MIDFIRST BANK">
                  <CONTACT_DETAIL>
                    <CONTACT_POINT _Type="Phone" _Value="8006544566"/>
                  </CONTACT_DETAIL>
                  <CREDIT_REPOSITORY _SourceType="Equifax" _SubscriberCode="158FM00079"/>
                </CREDIT_TRADE_REFERENCE>
                <CREDIT_TRADE_REFERENCE CreditTradeReferenceID="CTR0008" _City="THE LAKES" _Name="SEARS" _PostalCode="89163" _State="NV" _StreetAddress="8725 W. SAHARA AVE MC 02 02 03">
                  <CREDIT_REPOSITORY _SourceType="Equifax" _SubscriberCode="906BB05577"/>
                </CREDIT_TRADE_REFERENCE>
                <CREDIT_COMMENT _SourceType="Equifax" _Type="BureauRemarks">
                  <_Text>ADDRESS DISCREPANCY:( ) ADDRESS ELEMENTS WERE UNAVAILABLE OR NOT UTILIZED</_Text>
                </CREDIT_COMMENT>
                <CREDIT_COMMENT _SourceType="Equifax" _Type="BureauRemarks">
                  <_Text>CREDIT REPORT SSN: 301423221</_Text>
                </CREDIT_COMMENT>
                <CREDIT_COMMENT _SourceType="Equifax" _Type="BureauRemarks">
                  <_Text>CREDIT REPORT SSN CONFIRMED: Y</_Text>
                </CREDIT_COMMENT>
                <CREDIT_COMMENT _SourceType="Experian" _Type="BureauRemarks">
                  <_Text>DISPLAYED SSN IS THE SAME AS INQUIRY SSN</_Text>
                </CREDIT_COMMENT>
                <CREDIT_COMMENT _SourceType="Experian" _Type="BureauRemarks">
                  <_Text>XPN: FOUND ADDITIONAL SSN 231183812 FOR APPLICANT</_Text>
                </CREDIT_COMMENT>
                <CREDIT_COMMENT _SourceType="Experian" _Type="BureauRemarks">
                  <_Text>DISPLAYED SSN IS DIFFERENT THAN THE INQUIRY SSN</_Text>
                </CREDIT_COMMENT>
                <CREDIT_COMMENT _SourceType="Experian" _Type="BureauRemarks">
                  <_Text>ADDRESS DISCREPANCY:(1) RPTD VIA A/R TAPE, BUT DIFFERENT FROM INQUIRY</_Text>
                </CREDIT_COMMENT>
                <CREDIT_COMMENT _SourceType="TransUnion" _Type="BureauRemarks">
                  <_Text>05 - Exact match between SSN on input and SSN on file</_Text>
                </CREDIT_COMMENT>
                <CREDIT_COMMENT _SourceType="Equifax" _Type="BureauRemarks">
                  <_Text>AKA: ICE ROBERT</_Text>
                </CREDIT_COMMENT>
                <CREDIT_COMMENT _SourceType="Experian" _Type="BureauRemarks">
                  <_Text>SIMILAR NAME: ROBERT L ICE JR</_Text>
                </CREDIT_COMMENT>
                <CREDIT_COMMENT _SourceType="Experian" _Type="BureauRemarks">
                  <_Text>NAME: ROBERT ICE JR</_Text>
                </CREDIT_COMMENT>
                <CREDIT_SUMMARY _Name="Generic Summary">
                  <_DATA_SET _Name="TotalMortAccounts" _Value="4"/>
                  <_DATA_SET _Name="TotalMortAccountsWithBal" _Value="2"/>
                  <_DATA_SET _Name="TotalMortBalance" _Value="   199975"/>
                  <_DATA_SET _Name="TotalMortPayments" _Value="     2266"/>
                  <_DATA_SET _Name="TotalMort30" _Value="0"/>
                  <_DATA_SET _Name="TotalMort60" _Value="0"/>
                  <_DATA_SET _Name="TotalMort90" _Value="0"/>
                  <_DATA_SET _Name="MortLateDate" _Value=""/>
                  <_DATA_SET _Name="TotalInstAccounts" _Value="0"/>
                  <_DATA_SET _Name="TotalInstAccountsWithBal" _Value="0"/>
                  <_DATA_SET _Name="TotalInstBalance" _Value="        0"/>
                  <_DATA_SET _Name="TotalInstPayments" _Value="        0"/>
                  <_DATA_SET _Name="TotalInst30" _Value="0"/>
                  <_DATA_SET _Name="TotalInst60" _Value="0"/>
                  <_DATA_SET _Name="TotalInst90" _Value="0"/>
                  <_DATA_SET _Name="InstLateDate" _Value=""/>
                  <_DATA_SET _Name="TotalRevolveAccounts" _Value="5"/>
                  <_DATA_SET _Name="TotalRevolveAccountsWithBal" _Value="1"/>
                  <_DATA_SET _Name="TotalRevolveBalance" _Value="      141"/>
                  <_DATA_SET _Name="TotalRevolvePayments" _Value="        5"/>
                  <_DATA_SET _Name="TotalRevolve30" _Value="0"/>
                  <_DATA_SET _Name="TotalRevolve60" _Value="0"/>
                  <_DATA_SET _Name="TotalRevolve90" _Value="0"/>
                  <_DATA_SET _Name="RevolveLateDate" _Value=""/>
                  <_DATA_SET _Name="TotalCollAccounts" _Value="0"/>
                  <_DATA_SET _Name="TotalCollAccountsWithBal" _Value="0"/>
                  <_DATA_SET _Name="TotalCollBalance" _Value="        0"/>
                  <_DATA_SET _Name="TotalCollPayments" _Value="        0"/>
                  <_DATA_SET _Name="TotalColl30" _Value="0"/>
                  <_DATA_SET _Name="TotalColl60" _Value="0"/>
                  <_DATA_SET _Name="TotalColl90" _Value="0"/>
                  <_DATA_SET _Name="CollLateDate" _Value=""/>
                  <_DATA_SET _Name="TotalOtherAccounts" _Value="0"/>
                  <_DATA_SET _Name="TotalOtherAccountsWithBal" _Value="0"/>
                  <_DATA_SET _Name="TotalOtherBalance" _Value="        0"/>
                  <_DATA_SET _Name="TotalOtherPayments" _Value="        0"/>
                  <_DATA_SET _Name="TotalOther30" _Value="0"/>
                  <_DATA_SET _Name="TotalOther60" _Value="0"/>
                  <_DATA_SET _Name="TotalOther90" _Value="0"/>
                  <_DATA_SET _Name="OtherLateDate" _Value=""/>
                  <_DATA_SET _Name="TotalAccounts" _Value="9"/>
                  <_DATA_SET _Name="TotalAccountsWithBal" _Value="3"/>
                  <_DATA_SET _Name="TotalBalance" _Value="   200116"/>
                  <_DATA_SET _Name="TotalPayments" _Value="     2271"/>
                  <_DATA_SET _Name="Total30" _Value="0"/>
                  <_DATA_SET _Name="Total60" _Value="0"/>
                  <_DATA_SET _Name="Total90" _Value="0"/>
                  <_DATA_SET _Name="LateDate" _Value=""/>
                  <_DATA_SET _Name="TotalLiens" _Value="0"/>
                  <_DATA_SET _Name="TotalJudgements" _Value="0"/>
                  <_DATA_SET _Name="TotalForeclosure" _Value="0"/>
                  <_DATA_SET _Name="TotalBankruptcy" _Value="0"/>
                  <_DATA_SET _Name="TotalOtherPr" _Value="0"/>
                  <_DATA_SET _Name="TotalPr" _Value="0"/>
                  <_DATA_SET _Name="TotalPastDue" _Value="0"/>
                  <_DATA_SET _Name="TotalInqs" _Value="0"/>
                </CREDIT_SUMMARY>
              </CREDIT_RESPONSE>
            </RESPONSE_DATA>
          </RESPONSE>
        </RESPONSE_GROUP>'
    end
  end
end
# rubocop:enable ClassLength
# rubocop:enable LineLength
# rubocop:enable MethodLength
