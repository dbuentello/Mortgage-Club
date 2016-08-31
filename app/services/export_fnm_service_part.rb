# rubocop:disable ClassLength
# rubocop:disable MethodLength
class ExportFnmServicePart
  attr_accessor :loan, :borrower, :subject_property, :credit_report, :loan_member, :assets, :co_borrower

  def initialize()
    loan = Loan.find('70a6e6bd-7622-4b3e-acdd-da3c824ee878')
    @loan = loan
    byebug
    @subject_property = loan.subject_property
    @primary_property = get_primary_property(loan)
    @borrower = loan.borrower
    @credit_report = borrower.credit_report
  end

  def call
    export_fnm = ExportFnmService.new
    array = export_fnm.methods.select { |a| a.to_s.match(/data_/) }

    out_file = File.new("1003.fnm", "w")
    array.each do |method|
      line = build_data(exportFnm.send(method.to_s)).strip
      out_file.puts(line)
    end

    out_file.close
  end

  def build_data(input)
    line = StringIO.new

    input.each do |data|
      line << format(data[:format], data[:value])
    end

    line.string
  end

  def build_test
      build_data(data_08a)
  end

  def data_07a
    [
      {
        id: "07A-010",
        format: "%-3s",
        value: "07A"
      },
      {
        id: "07A-020",
        format: "%15.2f",
        value: subject_property.purchase_price.present? ? subject_property.purchase_price :  0
      },
      {
        id: "07A-030",
        format: "%15.2f",
        value: 0.0 # TODO
      },
      {
        id: "07A-040",
        format: "%15.2f",
        value: 0.0 # TODO
      },
      {
        id: "07A-050",
        format: "%15.2f",
        value: loan.amount.present? ? loan.amount : 0.0
      },
      {
        id: "07A-060",
        format: "%15.2f",
        value: subject_property.estimated_mortgage_balance.present? ? subject_property.estimated_mortgage_balance : 0.0
      },
      {
        id: "07A-070",
        format: "%15.2f",
        value: 0.0 # TODO
      },
      {
        id: "07A-080",
        format: "%15.2f",
        value: 0.0 # TODO
      },
      {
        id: "07A-090",
        format: "%15.2f",
        value: loan.discount_pts.present? ? loan.discount_pts : 0.0  # mapped
      },
      {
        id: "07A-100",
        format: "%15.2f",
        value: 0.0 # TODO
      },
      {
        id: "07A-110",
        format: "%15.2f",
        value: 0.0 # TODO
      },
      {
        id: "07A-120",
        format: "%15.2f",
        value: 0.0 # TODO
      }
    ]
  end

  def data_07b
    [
      {
        id: "07B-010",
        format: "%-3s",
        value: "07B"
      },
      {
          id: "07B-020",
          format: "%-2s",
          value: "01" # TODO
      },
      {
          id: "07B-030",
          format: "%15.2f",
          value: "150000" # TODO
      }
    ]
  end


  def data_08a
    [{
      id: "08A-010",
      format: "%-3s",
      value: "08A"
    },
     {
       id: "08A-020",
       format: "%-9s",
       value: borrower.ssn # borrower ssn
     },
     {
       id: "08A-030",
       format: "%-1s",
       value: "N" # borrower.declaration: outstanding_judgment
     },
     {
       id: "08A-040",
       format: "%-1s",
       value: "N" # borrower.declaration: :bankrupt
     },
     {
       id: "08A-050",
       format: "%-1s",
       value: "N" # borrower.declaration: :loan_foreclosure
     },
     {
       id: "08A-060",
       format: "%-1s",
       value: "N" # borrower.declaration: :party_to_lawsuit
     },
     {
       id: "08A-070",
       format: "%-1s",
       value: "N"
     },
     {
       id: "08A-080",
       format: "%-1s",
       value: "N" # borrower.declaration: :present_delinquent_loan
     },
     {
       id: "08A-090",
       format: "%-1s",
       value: "N"
     },
     {
       id: "08A-100",
       format: "%-1s",
       value: "N" # down_payment_borrowed
     },
     {
       id: "08A-110",
       format: "%-1s",
       value: "N" # co_maker_or_endorser
     },
     {
       id: "08A-120",
       format: "%-2s",
       value: "03" # borrower.declaration: :citizen_status
     },
     {
       id: "08A-130",
       format: "%-1s",
       value: "Y"
     },
     {
       id: "08A-140",
       format: "%-1s",
       value: "Y" # ownership_interest : Y N U
     },
     {
       id: "08A-150",
       format: "%-1s",
       value: "1" # property.usage
     },
     {
       id: "08A-160",
       format: "%-2s",
       value: "25" #
     }]
  end

  # def data_08b
  #   [{
  #       id: "08B-010",
  #       format: "%-3s",
  #       value: "08B"
  #   },
  #   {
  #       id: "08B-020",
  #       format: "%-9s",
  #       value: "111111111" #borrower.ssn
  #   },
  #   {
  #       id: "08B-030",
  #       format: "%-2s",
  #       value: "91" #borrower.declaration
  #   },
  #   {
  #       id: "08B-040",
  #       format: "%-255s",
  #       value: "asdasdasdasd  ASSDASDW"
  #   }]
  # end

  # def data_09a
  #   [{
  #       id: "09A-010",
  #       format: "%-3s",
  #       value: "09A"
  #   },
  #   {
  #       id: "09A-020",
  #       format: "%-9s",
  #       value: "111111111" #borrower.ssn
  #   },
  #   {
  #       id: "09A-030",
  #       format: "%-8s",
  #       value: "CCYYMMDD" #Current date : CCYYMMDD
  #   }]
  # end

  def data_10a
    [{
      id: "10A-010",
      format: "%-3s",
      value: "10A"
    },
     {
       id: "10A-020",
       format: "%-9s",
       value: "605593636" # borrower.ssn
     },
     {
       id: "10A-030",
       format: "%-1s",
       value: "N"
     },
     {
       id: "10A-040",
       format: "%-1s",
       value: "2" # is_hispanic_or_latino
     },
     {
       id: "10A-050",
       format: "%-30s",
       value: ""
     },
     {
       id: "10A-060",
       format: "%-1s",
       value: "M" # gender_type
     }]
  end

  def data_10b
    [{
      id: "10B-010",
      format: "%-3s",
      value: "10B"
    },
     {
       id: "10B-020",
       format: "%-1s",
       value: "I"
     },
     {
       id: "10B-030",
       format: "%-60s",
       value: "Billy Tran" # l.relationship_manager.user.first_name and last_name
     },
     {
       id: "10B-040",
       format: "%-8s",
       value: "" # Interview Date
     },
     {
       id: "10B-050",
       format: "%-10s",
       value: "6507877799" # l.relationship_manager.phone_number
     },
     {
       id: "10B-060",
       format: "%-35s",
       value: "MortgageClub Corporation" # l.relationship_manager.company_name
     },
     {
       id: "10B-070",
       format: "%-35s",
       value: "156 2nd St" # l.relationship_manager.company_address
     },
     {
       id: "10B-080",
       format: "%-35s",
       value: "" # borrower.ssn
     },
     {
       id: "10B-090",
       format: "%-35s",
       value: "San Francisco" # city
     },
     {
       id: "10B-100",
       format: "%-2s",
       value: "CA" # state code
     },
     {
       id: "10B-110",
       format: "%-5s",
       value: "94105" # zip code
     },
     {
       id: "10B-120",
       format: "%-4s",
       value: "" # Loan Origination Companys Zip Code Plus Four
     }]
  end

  def data_10r
    [{
      id: "10R-010",
      format: "%-3s",
      value: "10R"
    },
     {
       id: "10R-020",
       format: "%-9s",
       value: "605593636" # borrower.ssn
     },
     {
       id: "10R-030",
       format: "%-2s",
       value: "2"
     }]
  end

  def data_000_additional_case
    [
      {
        id: "000-010",
        format: "%-3s",
        value: "000"
      },
      {
        id: "000-020",
        format: "%-3s",
        value: "70"
      },
      {
        id: "000-030",
        format: "%-5s",
        value: "3.20"
      }
    ]
  end

  def data_99b
    [{
      id: "99B-010",
      format: "%-3s",
      value: "99B"
    },
     {
       id: "99B-020",
       format: "%-1s",
       value: ""
     },
     {
       id: "99B-030",
       format: "%-2s",
       value: "F1"
     },
     {
       id: "99B-040",
       format: "%15.2f",
       value: 625000
     },
     {
       id: "99B-050",
       format: "%7s",
       value: ""
     },
     {
       id: "99B-060",
       format: "%-2s",
       value: "01"
     },
     {
       id: "99B-070",
       format: "%-3s",
       value: ""
     },
     {
       id: "99B-080",
       format: "%-60s",
       value: ""
     },
     {
       id: "99B-090",
       format: "%-35s",
       value: ""
     },
     {
       id: "99B-100",
       format: "%-15s",
       value: ""
     },
     {
       id: "99B-110",
       format: "%-2s",
       value: ""
     }]
  end

  def data_ads_1
    [{
      id: "ADS-010",
      format: "%-3s",
      value: "ADS"
    },
     {
       id: "ADS-020",
       format: "%-35s",
       value: "LoanOriginatorID"
     },
     {
       id: "ADS-030",
       format: "%-50s",
       value: "1457126"
     }]
  end

  def data_ads_2
    [{
      id: "ADS-010",
      format: "%-3s",
      value: "ADS"
    },
     {
       id: "ADS-020",
       format: "%-35s",
       value: "LoanOriginationCompanyID"
     },
     {
       id: "ADS-030",
       format: "%-50s",
       value: "1456787"
     }]
  end

  # def data_ads_3
  #   [{
  #       id: "ADS-010",
  #       format: "%-3s",
  #       value: "ADS"
  #   },
  #   {
  #       id: "ADS-020",
  #       format: "%-35s",
  #       value: "SupervisoryAppraiserLicenseNumber"
  #   },
  #   {
  #       id: "ADS-030",
  #       format: "%-50s",
  #       value: ""
  #   }]
  # end

  def data_ads_4
    [{
      id: "ADS-010",
      format: "%-3s",
      value: "ADS"
    },
     {
       id: "ADS-020",
       format: "%-35s",
       value: "AppraisalIdentifier"
     },
     {
       id: "ADS-030",
       format: "%-50s",
       value: ""
     }]
  end

  # def data_ads_5
  #   [{
  #       id: "ADS-010",
  #       format: "%-3s",
  #       value: "ADS"
  #   },
  #   {
  #       id: "ADS-020",
  #       format: "%-35s",
  #       value: "FIPSCodeIdentifier"
  #   },
  #   {
  #       id: "ADS-030",
  #       format: "%50s",
  #       value: "1457126"
  #   }]
  # end

  # def data_ads_6
  #   [{
  #       id: "ADS-010",
  #       format: "%-3s",
  #       value: "ADS"
  #   },
  #   {
  #       id: "ADS-020",
  #       format: "%-35s",
  #       value: "TotalMortgagedPropertiesCount"
  #   },
  #   {
  #       id: "ADS-030",
  #       format: "%50s",
  #       value: ""
  #   }]
  # end

  # def data_ads_7
  #   [{
  #       id: "ADS-010",
  #       format: "%-3s",
  #       value: "ADS"
  #   },
  #   {
  #       id: "ADS-020",
  #       format: "%-35s",
  #       value: ""
  #   },
  #   {
  #       id: "ADS-030",
  #       format: "%-50s",
  #       value: ""
  #   }]
  # end

  def data_000_product
    [
      {
        id: "000-010",
        format: "%-3s",
        value: "000"
      },
      {
        id: "000-020",
        format: "%-3s",
        value: "11"
      },
      {
        id: "000-030",
        format: "%-5s",
        value: "3.20"
      }
    ]
  end

  def data_lnc
    [{
      id: "LNC-010",
      format: "%-3s",
      value: "LNC"
    },
     {
       id: "LNC-020",
       format: "%-1s",
       value: "1"
     },
     {
       id: "LNC-030",
       format: "%-1s",
       value: ""
     },
     {
       id: "LNC-040",
       format: "%-2s",
       value: "03"
     },
     {
       id: "LNC-050",
       format: "%-2s",
       value: ""
     }, {
       id: "LNC-060",
       format: "%-2s",
       value: ""
     },
     {
       id: "LNC-070",
       format: "%-2s",
       value: ""
     },
     {
       id: "LNC-080",
       format: "%-2s",
       value: ""
     },
     {
       id: "LNC-090",
       format: "%-2s",
       value: ""
     },
     {
       id: "LNC-100",
       format: "%7.3f",
       value: 0.0
     },
     {
       id: "LNC-110",
       format: "%-1s",
       value: "N"
     },
     {
       id: "LNC-120",
       format: "%-1s",
       value: ""
     },
     {
       id: "LNC-130",
       format: "%-1s",
       value: ""
     },
     {
       id: "LNC-140",
       format: "%-1s",
       value: "N"
     },
     {
       id: "LNC-150",
       format: "%7.3f",
       value: 0.0
     },
     {
       id: "LNC-160",
       format: "%7.3f",
       value: 0.0
     },
     {
       id: "LNC-170",
       format: "%15.2f",
       value: 0.0
     },
     {
       id: "LNC-180",
       format: "%-1s",
       value: "N"
     },
     {
       id: "LNC-190",
       format: "%-8s",
       value: ""
     },
     {
       id: "LNC-200",
       format: "%-8s",
       value: ""
     },
     {
       id: "LNC-210",
       format: "%7.3f",
       value: 0.0
     },
     {
       id: "LNC-220",
       format: "%-3s",
       value: ""
     },
     {
       id: "LNC-230",
       format: "%5.3f",
       value: 0.0
     },
     {
       id: "LNC-240",
       format: "%-1s",
       value: ""
     },
     {
       id: "LNC-250",
       format: "%-1s",
       value: ""
     }]
  end

  def data_pid
    [{
      id: "PID-010",
      format: "%-3s",
      value: "PID"
    },
     {
       id: "PID-020",
       format: "%-30s",
       value: "15 Yr Fixed - Conventional - N"
     },
     {
       id: "PID-030",
       format: "%-15s",
       value: ""
     },
     {
       id: "PID-040",
       format: "%-5s",
       value: "" # l.amortization_type
     }]
  end

  def data_pch
    [{
      id: "PCH-010",
      format: "%-3s",
      value: "PCH"
    },
     {
       id: "PCH-020",
       format: "%3s",
       value: 360
     },
     {
       id: "PCH-030",
       format: "%-1s",
       value: "N"
     },
     {
       id: "PCH-040",
       format: "%-2s",
       value: "01"
     },
     {
       id: "PCH-050",
       format: "%-1s",
       value: "N"
     },
     {
       id: "PCH-060",
       format: "%-1s",
       value: ""
     },
     {
       id: "PCH-070",
       format: "%-2s",
       value: ""
     }]
  end

  # def data_arm
  #   [{
  #       id: "ARM-010",
  #       format: "%-3s",
  #       value: "ARM"
  #   },
  #   {
  #       id: "ARM-020",
  #       format: "%7.3f",
  #       value: "123.22"
  #   },
  #   {
  #       id: "ARM-030",
  #       format: "%-2s",
  #       value: "10"
  #   },
  #   {
  #       id: "ARM-040",
  #       format: "%7.3f",
  #       value: "22.22"
  #   },
  #   {
  #       id: "ARM-050",
  #       format: "%7.3f",
  #       value: "23.22"
  #   }]
  # end

  # def data_paj
  #   [{
  #       id: "PAJ-010",
  #       format: "%-3s",
  #       value: "PAJ"
  #   },
  #   {
  #       id: "PAJ-020",
  #       format: "%4s",
  #       value: ""
  #   },
  #   {
  #       id: "PAJ-030",
  #       format: "%3s",
  #       value: "10"
  #   },
  #   {
  #       id: "PAJ-040",
  #       format: "%3s",
  #       value: "12"
  #   },
  #   {
  #       id: "PAJ-050",
  #       format: "%-1s",
  #       value: "1"
  #   },
  #   {
  #       id: "PAJ-060",
  #       format: "%7.3f",
  #       value: "1"
  #   },
  #   {
  #       id: "PAJ-070",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "PAJ-080",
  #       format: "%7.3f",
  #       value: "1"
  #   },
  #   {
  #       id: "PAJ-090",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "PAJ-100",
  #       format: "%3s",
  #       value: ""
  #   }]
  # end

  # def data_raj
  #   [{
  #       id: "RAJ-010",
  #       format: "%-3s",
  #       value: "RAJ"
  #   },
  #   {
  #       id: "RAJ-020",
  #       format: "%4s",
  #       value: ""
  #   },
  #   {
  #       id: "RAJ-030",
  #       format: "%3s",
  #       value: "10"
  #   },
  #   {
  #       id: "RAJ-040",
  #       format: "%3s",
  #       value: "12"
  #   },
  #   {
  #       id: "RAJ-050",
  #       format: "%-1s",
  #       value: "1"
  #   },
  #   {
  #       id: "RAJ-060",
  #       format: "%7.3f",
  #       value: "1"
  #   },
  #   {
  #       id: "RAJ-070",
  #       format: "%7.3f",
  #       value: "1"
  #   },
  #   {
  #       id: "RAJ-080",
  #       format: "%3s",
  #       value: "1"
  #   }]
  # end

  # def data_bua
  #   [{
  #       id: "BUA-010",
  #       format: "%-3s",
  #       value: "BUA"
  #   },
  #   {
  #       id: "BUA-020",
  #       format: "%3s",
  #       value: ""
  #   },
  #   {
  #       id: "BUA-030",
  #       format: "%3s",
  #       value: "10"
  #   },
  #   {
  #       id: "BUA-040",
  #       format: "%7.3f",
  #       value: "12"
  #   },
  #   {
  #       id: "BUA-050",
  #       format: "%-1s",
  #       value: "Y"
  #   },
  #   {
  #       id: "BUA-060",
  #       format: "%-1s",
  #       value: "1"
  #   },
  #   {
  #       id: "BUA-070",
  #       format: "%-1s",
  #       value: "1"
  #   }]
  # end

  # def data_000_government
  #   [
  #     {
  #       id: "000-010",
  #       format: "%-3s",
  #       value: "000"
  #     },
  #     {
  #       id: "000-020",
  #       format: "%-3s",
  #       value: "20"
  #     },
  #     {
  #       id: "000-030",
  #       format: "%-5s",
  #       value: "3.20"
  #     }
  #   ]
  # end

  # def data_ida
  #   [{
  #       id: "IDA-010",
  #       format: "%-3s",
  #       value: "000"
  #   },
  #   {
  #       id: "IDA-020",
  #       format: "%-23s",
  #       value: ""
  #   }]
  # end

  # def data_lea
  #   [{
  #       id: "LEA-010",
  #       format: "%-3s",
  #       value: "LEA"
  #   },
  #   {
  #       id: "LEA-020",
  #       format: "%20s",
  #       value: ""
  #   },
  #   {
  #       id: "LEA-030",
  #       format: "%20s",
  #       value: "10"
  #   },
  #   {
  #       id: "LEA-040",
  #       format: "%10f",
  #       value: "12"
  #   },
  #   {
  #       id: "LEA-050",
  #       format: "%-13s",
  #       value: ""
  #   }]
  # end

  # def data_goa
  #   [{
  #       id: "GOA-010",
  #       format: "%-3s",
  #       value: "GOA"
  #   },
  #   {
  #       id: "GOA-020",
  #       format: "%-1s",
  #       value: "Y"
  #   },
  #   {
  #       id: "GOA-030",
  #       format: "%15.2f",
  #       value: "10"
  #   },
  #   {
  #       id: "GOA-040",
  #       format: "%15.2f",
  #       value: "12"
  #   },
  #   {
  #       id: "GOA-050",
  #       format: "%15.2f",
  #       value: "2"
  #   },
  #   {
  #       id: "GOA-060",
  #       format: "%7.3f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOA-070",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOA-080",
  #       format: "%7.3f",
  #       value: "10"
  #   },
  #   {
  #       id: "GOA-090",
  #       format: "%15.2f",
  #       value: "12"
  #   },
  #   {
  #       id: "GOA-100",
  #       format: "%7.3f",
  #       value: "2"
  #   },
  #   {
  #       id: "GOA-110",
  #       format: "%-1s",
  #       value: "1"
  #   },
  #   {
  #       id: "GOA-120",
  #       format: "%-35s",
  #       value: "2"
  #   }]
  # end

  # def data_gob
  #   [{
  #       id: "GOB-010",
  #       format: "%-3s",
  #       value: "GOB"
  #   },
  #   {
  #       id: "GOB-020",
  #       format: "%-13s",
  #       value: ""
  #   },
  #   {
  #       id: "GOB-030",
  #       format: "%-15s",
  #       value: ""
  #   },
  #   {
  #       id: "GOB-040",
  #       format: "%-7s",
  #       value: ""
  #   },
  #   {
  #       id: "GOB-050",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOB-060",
  #       format: "%-7s",
  #       value: ""
  #   },
  #   {
  #       id: "GOB-070",
  #       format: "%3s",
  #       value: ""
  #   }]
  # end

  # def data_goc
  #   [{
  #       id: "GOC-010",
  #       format: "%-3s",
  #       value: "GOC"
  #   },
  #   {
  #       id: "GOC-020",
  #       format: "%-1s",
  #       value: "Y"
  #   },
  #   {
  #       id: "GOC-030",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOC-040",
  #       format: "%7.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOC-050",
  #       format: "%7.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOC-060",
  #       format: "%-7s",
  #       value: ""
  #   }]
  # end

  # def data_god
  #   [{
  #       id: "GOD-010",
  #       format: "%-3s",
  #       value: "GOD"
  #   },
  #   {
  #       id: "GOD-020",
  #       format: "%9s",
  #       value: "111111111"
  #   },
  #   {
  #       id: "GOD-030",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOD-040",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOD-050",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOD-060",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOD-070",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOD-080",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOD-090",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "GOD-100",
  #       format: "%15.2f",
  #       value: "1"
  #   }]
  # end

  # def data_goe
  #   [{
  #       id: "GOE-010",
  #       format: "%-3s",
  #       value: "GOE"
  #   },
  #   {
  #       id: "GOE-020",
  #       format: "%9s",
  #       value: "111111111"
  #   },
  #   {
  #       id: "GOE-030",
  #       format: "%-10s",
  #       value: ""
  #   },
  #   {
  #       id: "GOE-040",
  #       format: "%-3s",
  #       value: ""
  #   },
  #   {
  #       id: "GOE-050",
  #       format: "%-3s",
  #       value: ""
  #   },
  #   {
  #       id: "GOE-060",
  #       format: "%-3s",
  #       value: ""
  #   },
  #   {
  #       id: "GOE-070",
  #       format: "%-1s",
  #       value: "A"
  #   }]
  # end

  # def data_lmd
  #   [{
  #       id: "LMD-010",
  #       format: "%-3s",
  #       value: "LMD"
  #   },
  #   {
  #       id: "LMD-020",
  #       format: "%-40s",
  #       value: ""
  #   },
  #   {
  #       id: "LMD-030",
  #       format: "%-2s",
  #       value: ""
  #   },
  #   {
  #       id: "LMD-035",
  #       format: "%-38s",
  #       value: ""
  #   },
  #   {
  #       id: "LMD-040",
  #       format: "%-1s",
  #       value: "Y"
  #   },
  #   {
  #       id: "LMD-050",
  #       format: "%-1s",
  #       value: "Y"
  #   },
  #   {
  #       id: "LMD-060",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "LMD-070",
  #       format: "%15.2f",
  #       value: "1"
  #   },
  #   {
  #       id: "LMD-080",
  #       format: "%15.2f",
  #       value: "1"
  #   }]
  # end

  def data_tt
    [{
      id: "TT-010",
      format: "%-3s",
      value: "TT"
    },
     {
       id: "TT-020",
       format: "%-9s",
       value: "TRAN1"
     }]
  end

  def data_et
    [
      {
        id: "ET-010",
        format: "%-3s",
        value: "ET"
      },
      {
        id: "ET-020",
        format: "%-9s",
        value: "ENV1"
      }
    ]
  end

  private

  def get_primary_property(loan)
    return unless loan.primary_property

    if subject_property_and_primary_property_have_same_address?(loan.primary_property)
      return loan.subject_property
    else
      return loan.primary_property
    end
  end

  def subject_property_and_primary_property_have_same_address?(primary_property)
    return false unless subject_address = subject_property.address
    return false unless primary_address = primary_property.address

    subject_address.city == primary_address.city &&
      subject_address.state == primary_address.state &&
      subject_address.street_address == primary_address.street_address &&
      subject_address.zip == primary_address.zip
  end
end

# rubocop:enable ClassLength
# rubocop:enable MethodLength
