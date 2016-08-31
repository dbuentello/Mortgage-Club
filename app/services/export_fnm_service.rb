# rubocop:disable ClassLength
# rubocop:disable MethodLength
class ExportFnmService
  attr_accessor :loan, :borrower, :subject_property, :credit_report, :loan_member, :assets, :co_borrower, :loan_values, :subject_property_fnm

  def initialize()
    loan = Loan.find('70a6e6bd-7622-4b3e-acdd-da3c824ee878')
    @loan = loan
    @subject_property = loan.subject_property
    @primary_property = loan.primary_property
    @borrower = loan.borrower
    @credit_report = borrower.credit_report
    @loan_values = loan.fnm_values
    byebug
    @subject_property_fnm = loan.subject_property.subject_property_fnm
    byebug
  end

  def call
    export_fnm = ExportFnmService.new(nil)
    array = export_fnm.methods.select { |a| a.to_s.match(/data_/) }

    out_file = File.new("1003.fnm", "w")
    array.each do |method|
      line = build_data(export_fnm.send(method.to_s)).strip
      out_file.puts(line)
    end
    #
    out_file.close
  end

  def build_data(input)
    line = StringIO.new

    input.each do |data|
      line << format(data[:format], data[:value])
    end

    line.string
  end

  def data_eh
    [
      {
        id: "EH-010",
        format: "%-3s",
        value: "EH" # FIXED
      },
      {
        id: "EH-020",
        format: "%-6s",
        value: "" # TODO
      },
      {
        id: "EH-030",
        format: "%-25s",
        value: "" # TODO
      },
      {
        id: "EH-040",
        format: "%-11s",
        value: "20160808" # TODO
      },
      {
        id: "EH-050",
        format: "%-9s",
        value: "ENV1" # TODO
      }
    ]
  end

  def data_th
    [
      {
        id: "TH-010",
        format: "%-3s",
        value: "TH" # FIXED
      },
      {
        id: "TH-020",
        format: "%-11s",
        value: "T100099-002" # FIXED
      },
      {
        id: "TH-030",
        format: "%-9s",
        value: "TRAN1" # TODO
      }
    ]
  end

  def data_tpi
    [
      {
        id: "TPI-010",
        format: "%-3s",
        value: "TPI" # FIXED
      },
      {
        id: "TPI-020",
        format: "%-5s",
        value: "1.00" # FIXED
      },
      {
        id: "TPI-030",
        format: "%-2s",
        value: "01" # FIXED
      },
      {
        id: "TPI-040",
        format: "%-30s",
        value: "" # TODO
      },
      {
        id: "TPI-050",
        format: "%-1s",
        value: "N" # TODO
      }
    ]
  end

  def data_000_file
    [
      {
        id: "000-010",
        format: "%-3s",
        value: "000" # FIXED
      },
      {
        id: "000-020",
        format: "%-3s",
        value: "1" # FIXED
      },
      {
        id: "000-030",
        format: "%-5s",
        value: "3.20" # FIXED
      },
      {
        id: "000-040",
        format: "%-1s",
        value: "W" # FIXED
      }
    ]
  end

  def data_00a
    [
      {
        id: "00A-010",
        format: "%-3s",
        value: "00A" # FIXED
      },
      {
        id: "00A-020",
        format: "%-1s",
        value: "N" # TODO
      },
      {
        id: "00A-030",
        format: "%-1s",
        value: "Y" # TODO
      }
    ]
  end

  def data_01a
    [
      {
        id: "01A-010",
        format: "%-3s",
        value: "01A" # FIXED
      },
      {
        id: "01A-020",
        format: "%-2s",
        value: loan_values[:loan_type] # MAPPED
      },
      {
        id: "01A-030",
        format: "%-80s",
        value: "" # TODO
      },
      {
        id: "01A-040",
        format: "%-30s",
        value: "" # TODO
      },
      {
        id: "01A-050",
        format: "%-15s",
        value: "" # TODO
      },
      {
        id: "01A-060",
        format: "%15.2f",
        value: loan_values[:amount] # MAPPED
      },
      {
        id: "01A-070",
        format: "%7.3f",
        value: loan_values[:interest_rate] # MAPPED
      },
      {
        id: "01A-080",
        format: "%3s",
        value: loan_values[:num_of_months] # MAPPED
      },
      {
        id: "01A-090",
        format: "%-2s",
        value: loan_values[:amortization_type_fnm] # MAPPED
      },
      {
        id: "01A-100",
        format: "%-80s",
        value: "" # TODO
      },
      {
        id: "01A-110",
        format: "%-80s",
        value: "" # TODO
      }
    ]
  end

  def data_02a
    [
      {
        id: "02A-010",
        format: "%-3s",
        value: "02A"
      },
      {
        id: "02A-020",
        format: "%-50s",
        value: subject_property_fnm[:street_address] # MAPPED
      },
      {
        id: "02A-030",
        format: "%-35s",
        value: subject_property_fnm[:city]# MAPPED
      },
      {
        id: "02A-040",
        format: "%-2s",
        value: subject_property_fnm[:state] # MAPPED
      },
      {
        id: "02A-050",
        format: "%5s",
        value: subject_property_fnm[:zip].to_s # MAPPED
      },
      {
        id: "02A-060",
        format: "%4s",
        value: "" # TODO
      },
      {
        id: "02A-070",
        format: "%3s",
        value: "1" # TODO
      },
      {
        id: "02A-080",
        format: "%-2s",
        value: "F1" # TODO
      },
      {
        id: "02A-090",
        format: "%-80s",
        value: "SEE PRELIMINARY TITLE" # TODO
      },
      {
        id: "02A-100",
        format: "%-4s",
        value: subject_property.year_built # MAPPED
      }
    ]
  end

  # def data_pai
  #   [
  #     {
  #       id: "PAI-010",
  #       format: "%-3s",
  #       value: "PAI" # FIXED
  #     },
  #     {
  #       id: "PAI-020",
  #       format: "%-11s",
  #       value: "" # TODO
  #     },
  #     {
  #       id: "PAI-030",
  #       format: "%-40s",
  #       value: "" # TODO
  #     },
  #     {
  #       id: "PAI-040",
  #       format: "%-11s",
  #       value: "" # TODO
  #     }
  #   ]
  # end

  def data_02b
    [
      {
        id: "02B-010",
        format: "%-3s",
        value: "02B" # FIXED
      },
      {
        id: "02B-020",
        format: "%-2s",
        value: "" # TODO
      },
      {
        id: "02B-030",
        format: "%-2s",
        value: loan_values[:purpose] # MAPPED
      },
      {
        id: "02B-040",
        format: "%-80s",
        value: "" # TODO
      },
      {
        id: "02B-050",
        format: "%-1s",
        value: subject_property.usage_fnm # MAPPED
      },
      {
        id: "02B-060",
        format: "%-60s",
        value: "To be decided in escrow" # TODO
      },
      {
        id: "02B-070",
        format: "%-1s",
        value: "1" # TODO
      },
      {
        id: "02B-080",
        format: "%-8s",
        value: "" # TODO
      }
    ]
  end

  def data_02c
    [
      {
        id: "02C-010",
        format: "%-3s",
        value: "02C"
      },
      {
        id: "02C-020",
        format: "%-60s",
        value: "Thang B Dinh"
      }
    ]
  end

  def data_02d
    [
      {
        id: "02D-010",
        format: "%-3s",
        value: "02D"
      },
      {
        id: "02D-020",
        format: "%-4s",
        value: "2015"
      },
      {
        id: "02D-030",
        format: "%15.2f",
        value: 530000.00 # l.subject_property_original_purchase_price
      },
      {
        id: "02D-040",
        format: "%15.2f",
        value: 415000.00
      },
      {
        id: "02D-050",
        format: "%15.2f",
        value: 0.00
      },
      {
        id: "02D-060",
        format: "%15.2f",
        value: 0.00
      },
      {
        id: "02D-070",
        format: "%-2s",
        value: "F1"
      },
      {
        id: "02D-080",
        format: "%-80s",
        value: ""
      },
      {
        id: "02D-090",
        format: "%-1s",
        value: ""
      },
      {
        id: "02D-100",
        format: "%15.2f",
        value: 0.00
      }
    ]
  end

  # def data_02e
  #   [
  #     {
  #       id: "02E-010",
  #       format: "%-3s",
  #       value: "02E"
  #     },
  #     {
  #       id: "02E-020",
  #       format: "%-2s",
  #       value: "H3"
  #     },
  #     {
  #       id: "02E-030",
  #       format: "%15.2f",
  #       value: 0.00
  #     },
  #     {
  #       id: "02E-040",
  #       format: "%-80s",
  #       value: ""
  #     }
  #   ]
  # end

  def data_03a
    [
      {
        id: "03A-010",
        format: "%-3s",
        value: "03A"
      },
      {
        id: "03A-020",
        format: "%-2s",
        value: "BW" # BW if loan doesn't have Applicant or QZ
      },
      {
        id: "03A-030",
        format: "%-9s",
        value: "605593636" # l.borrower.ssn
      },
      {
        id: "03A-040",
        format: "%-35s",
        value: "Thang" # l.borrower.first_name
      },
      {
        id: "03A-050",
        format: "%-35s",
        value: "B" # l.borrower.middle_name
      },
      {
        id: "03A-060",
        format: "%-35s",
        value: "Dinh" # l.borrower.last_name
      },
      {
        id: "03A-070",
        format: "%-4s",
        value: "" # l.borrower.suffix
      },
      {
        id: "03A-080",
        format: "%-10s",
        value: "" # l.borrower.phone
      },
      {
        id: "03A-090",
        format: "%3s",
        value: "" # l.borrower.dob
      },
      {
        id: "03A-100",
        format: "%2s",
        value: "" # l.borrower.years_in_school
      },
      {
        id: "03A-110",
        format: "%-1s",
        value: "M" # l.borrower.martial_status
      },
      {
        id: "03A-120",
        format: "%2s",
        value: 0
      },
      {
        id: "03A-130",
        format: "%-1s",
        value: "N"
      },
      {
        id: "03A-140",
        format: "%9s",
        value: ""
      },
      {
        id: "03A-150",
        format: "%-8s",
        value: ""
      },
      {
        id: "03A-160",
        format: "%-80s",
        value: "bathang@gmail.com"
      }
    ]
  end

  # 1 age 1 row
  # def data_03b
  #   [
  #     {
  #       id: "03B-010",
  #       format: "%-3s",
  #       value: "03B"
  #     },
  #     {
  #       id: "03B-020",
  #       format: "%9s",
  #       value: "605593636"
  #     },
  #     {
  #       id: "03B-030",
  #       format: "%3s",
  #       value: "3"
  #     }
  #   ]
  # end

  def data_03c
    [
      {
        id: "03C-010",
        format: "%-3s",
        value: "03C"
      },
      {
        id: "03C-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "03C-030",
        format: "%-2s",
        value: "ZG"
      },
      {
        id: "03C-040",
        format: "%-50s",
        value: "2320 Meadowmont Dr" # l.primary_property.address.street_address
      },
      {
        id: "03C-050",
        format: "%-35s",
        value: "San Jose" # l.primary_property.address.city
      },
      {
        id: "03C-060",
        format: "%-2s",
        value: "CA" # l.primary_property.address.state
      },
      {
        id: "03C-070",
        format: "%5s",
        value: "95133" # l.primary_property.address.zip
      },
      {
        id: "03C-080",
        format: "%4s",
        value: ""
      },
      {
        id: "03C-010",
        format: "%-1s",
        value: "O"
      },
      {
        id: "03C-010",
        format: "%2s",
        value: 2
      },
      {
        id: "03C-010",
        format: "%2s",
        value: ""
      },
      {
        id: "03C-010",
        format: "%-50s",
        value: ""
      }
    ]
  end

  def data_04a
    [
      {
        id: "04A-010",
        format: "%-3s",
        value: "04A"
      },
      {
        id: "04A-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "04A-030",
        format: "%-35s",
        value: "Addepar" # l.borrower.current_employment.employer_name
      },
      {
        id: "04A-040",
        format: "%-35s",
        value: "1215 Terra Bella Ave" # l.borrower.current_employment.address.street_address
      },
      {
        id: "04A-050",
        format: "%-35s",
        value: "Mountain View" # l.borrower.current_employment.address.city
      },
      {
        id: "04A-060",
        format: "%-2s",
        value: "CA" # l.borrower.current_employment.address.state
      },
      {
        id: "04A-070",
        format: "%5s",
        value: "94043" # l.borrower.current_employment.address.zip
      },
      {
        id: "04A-080",
        format: "%4s",
        value: ""
      },
      {
        id: "04A-090",
        format: "%-1s",
        value: "N" # l.borrower.self_employed
      },
      {
        id: "04A-100",
        format: "%2s",
        value: "2" # l.borrower.current_employment.duration
      },
      {
        id: "04A-110",
        format: "%2s",
        value: ""
      },
      {
        id: "04A-120",
        format: "%2s",
        value: "10"
      },
      {
        id: "04A-130",
        format: "%-25s",
        value: "Software Engineer" # l.borrower.current_employment.job_title
      },
      {
        id: "04A-140",
        format: "%10s",
        value: "8554646268"
      }
    ]
  end

  # def data_04b
  #   [
  #     {
  #       id: "04B-010",
  #       format: "%-3s",
  #       value: "04B"
  #     },
  #     {
  #       id: "04B-020",
  #       format: "%9s",
  #       value: "605593636"
  #     },
  #     {
  #       id: "04B-030",
  #       format: "%-35s",
  #       value: "Addepar" # l.borrower.previous_employment.employer_name
  #     },
  #     {
  #       id: "04B-040",
  #       format: "%-35s",
  #       value: "1215 Terra Bella Ave" # l.borrower.previous_employment.address.street_address
  #     },
  #     {
  #       id: "04B-050",
  #       format: "%-35s",
  #       value: "Mountain View"  # l.borrower.previous_employment.address.city
  #     },
  #     {
  #       id: "04B-060",
  #       format: "%-2s",
  #       value: "CA" # l.borrower.previous_employment.address.state
  #     },
  #     {
  #       id: "04B-070",
  #       format: "%5s",
  #       value: "94043" # l.borrower.previous_employment.address.zip
  #     },
  #     {
  #       id: "04B-080",
  #       format: "%4s",
  #       value: ""
  #     },
  #     {
  #       id: "04B-090",
  #       format: "%-1s",
  #       value: "N" # l.borrower.self_employed
  #     },
  #     {
  #       id: "04B-100",
  #       format: "%-1s",
  #       value: "N"
  #     },
  #     {
  #       id: "04B-110",
  #       format: "%-8s",
  #       value: "20131231"
  #     },
  #     {
  #       id: "04B-120",
  #       format: "%-8s",
  #       value: "20151231"
  #     },
  #     {
  #       id: "04B-130",
  #       format: "%15.2f",
  #       value: 12100.3123
  #     },
  #     {
  #       id: "04B-140",
  #       format: "%-25s",
  #       value: "Software Engineer" # l.borrower.previous_employment.job_title
  #     },
  #     {
  #       id: "04B-150",
  #       format: "%10s",
  #       value: "8554646268"
  #     }
  #   ]
  # end

  def data_05h
    [
      {
        id: "05H-010",
        format: "%-3s",
        value: "05H"
      },
      {
        id: "05H-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "05H-030",
        format: "%-1s",
        value: "1"
      },
      {
        id: "05H-040",
        format: "%-2s",
        value: "14"
      },
      {
        id: "05H-050",
        format: "%15.2f",
        value: 312.0
      }
    ]
  end

  def data_05i
    [
      {
        id: "05I-010",
        format: "%-3s",
        value: "05I"
      },
      {
        id: "05I-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "05I-030",
        format: "%-2s",
        value: "20"
      },
      {
        id: "05I-040",
        format: "%15.2f",
        value: 12500.00
      }
    ]
  end

  # def data_06a
  #   [
  #     {
  #       id: "06A-010",
  #       format: "%-3s",
  #       value: "06A"
  #     },
  #     {
  #       id: "06A-020",
  #       format: "%9s",
  #       value: "605593636"
  #     },
  #     {
  #       id: "06A-030",
  #       format: "%-35s",
  #       value: ""
  #     },
  #     {
  #       id: "06A-040",
  #       format: "%15.2f",
  #       value: 3123.231
  #     }
  #   ]
  # end

  # def data_06b
  #   [
  #     {
  #       id: "06B-010",
  #       format: "%-3s",
  #       value: "06B"
  #     },
  #     {
  #       id: "06B-020",
  #       format: "%9s",
  #       value: "605593636"
  #     },
  #     {
  #       id: "06B-030",
  #       format: "%-30s",
  #       value: ""
  #     },
  #     {
  #       id: "06B-040",
  #       format: "%15.2f",
  #       value: 3123.231
  #     },
  #     {
  #       id: "06B-050",
  #       format: "%15.2f",
  #       value: 3123.231
  #     }
  #   ]
  # end

  def data_06c
    [
      {
        id: "06C-010",
        format: "%-3s",
        value: "06C"
      },
      {
        id: "06C-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "06C-030",
        format: "%-3s",
        value: "03" # l.borrower.assets asset_type
      },
      {
        id: "06C-040",
        format: "%-35s",
        value: "Bank of America"
      },
      {
        id: "06C-050",
        format: "%-35s",
        value: ""
      },
      {
        id: "06C-060",
        format: "%-35s",
        value: ""
      },
      {
        id: "06C-070",
        format: "%-2s",
        value: ""
      },
      {
        id: "06C-080",
        format: "%5s",
        value: ""
      },
      {
        id: "06C-090",
        format: "%4s",
        value: ""
      },
      {
        id: "06C-100",
        format: "%-30s",
        value: "000335523814"
      },
      {
        id: "06C-110",
        format: "%15.2f",
        value: 43099.00
      },
      {
        id: "06C-120",
        format: "%7s",
        value: ""
      },
      {
        id: "06C-130",
        format: "%-80s",
        value: ""
      },
      {
        id: "06C-140",
        format: "%-1s",
        value: ""
      },
      {
        id: "06C-150",
        format: "%-2s",
        value: ""
      }
    ]
  end

  # def data_06d
  #   [
  #     {
  #       id: "06D-010",
  #       format: "%-3s",
  #       value: "06D"
  #     },
  #     {
  #       id: "06D-020",
  #       format: "%9s",
  #       value: "605593636"
  #     },
  #     {
  #       id: "06D-030",
  #       format: "%-30s",
  #       value: "3123"
  #     },
  #     {
  #       id: "06D-040",
  #       format: "%-4s",
  #       value: "2015"
  #     },
  #     {
  #       id: "06D-050",
  #       format: "%15.2f",
  #       value: 1231.123
  #     }
  #   ]
  # end

  # def data_06f
  #   [
  #     {
  #       id: "06F-010",
  #       format: "%-3s",
  #       value: "06F"
  #     },
  #     {
  #       id: "06F-020",
  #       format: "%9s",
  #       value: "605593636"
  #     },
  #     {
  #       id: "06F-030",
  #       format: "%-3s",
  #       value: "DR"
  #     },
  #     {
  #       id: "06F-040",
  #       format: "%15.2f",
  #       value: 13123.12312
  #     },
  #     {
  #       id: "06F-050",
  #       format: "%3s",
  #       value: 360
  #     },
  #     {
  #       id: "06F-060",
  #       format: "%-60s",
  #       value: "sadad"
  #     },
  #   ]
  # end

  def data_06g
    [
      {
        id: "06G-010",
        format: "%-3s",
        value: "06G"
      },
      {
        id: "06G-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "06G-030",
        format: "%-35s",
        value: "2320 Meadowmont Dr"
      },
      {
        id: "06G-040",
        format: "%-35s",
        value: "San Jose"
      },
      {
        id: "06G-050",
        format: "%-2s",
        value: "CA"
      },
      {
        id: "06G-060",
        format: "%5s",
        value: "95133"
      },
      {
        id: "06G-070",
        format: "%4s",
        value: ""
      },
      {
        id: "06G-080",
        format: "%-1s",
        value: "H"
      },
      {
        id: "06G-090",
        format: "%-2s",
        value: "14"
      },
      {
        id: "06G-100",
        format: "%15.2f",
        value: 625000.00
      },
      {
        id: "06G-110",
        format: "%15.2f",
        value: 414972.00
      },
      {
        id: "06G-120",
        format: "%15.2f",
        value: 0.00
      },
      {
        id: "06G-130",
        format: "%15.2f",
        value: 1903.00
      },
      {
        id: "06G-140",
        format: "%15.2f",
        value: 617.00
      },
      {
        id: "06G-150",
        format: "%15.2f",
        value: 0.00
      },
      {
        id: "06G-160",
        format: "%-1s",
        value: "Y"
      },
      {
        id: "06G-170",
        format: "%-1s",
        value: "Y"
      },
      {
        id: "06G-180",
        format: "%-2s",
        value: "1"
      },
      {
        id: "06G-190",
        format: "%-15s",
        value: ""
      }
    ]
  end

  # def data_06h
  #   [
  #     {
  #       id: "06H-010",
  #       format: "%-3s",
  #       value: "06H"
  #     },
  #     {
  #       id: "06H-020",
  #       format: "%9s",
  #       value: "605593636"
  #     },
  #     {
  #       id: "06H-030",
  #       format: "%-35s",
  #       value: "213"
  #     },
  #     {
  #       id: "06H-040",
  #       format: "%-35s",
  #       value: "123"
  #     },
  #     {
  #       id: "06H-050",
  #       format: "%-35s",
  #       value: "123"
  #     },
  #     {
  #       id: "06H-060",
  #       format: "%-15s",
  #       value: "123"
  #     },
  #     {
  #       id: "06H-070",
  #       format: "%-15s",
  #       value: "123"
  #     }
  #   ]
  # end

  def data_06l
    [
      {
        id: "06L-010",
        format: "%-3s",
        value: "06L"
      },
      {
        id: "06L-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "06L-030",
        format: "%-2s",
        value: "M"
      },
      {
        id: "06L-040",
        format: "%-35s",
        value: "WFHM"
      },
      {
        id: "06L-050",
        format: "%-35s",
        value: "PO BOX 10335"
      },
      {
        id: "06L-060",
        format: "%-35s",
        value: "DES MOINES"
      },
      {
        id: "06L-070",
        format: "%-2s",
        value: "IA"
      },
      {
        id: "06L-080",
        format: "%5s",
        value: "50306"
      },
      {
        id: "06L-090",
        format: "%4s",
        value: ""
      },
      {
        id: "06L-100",
        format: "%-30s",
        value: "9360500931597"
      },
      {
        id: "06L-110",
        format: "%15.2f",
        value: 1903.0
      },
      {
        id: "06L-120",
        format: "%3s",
        value: 0
      },
      {
        id: "06L-130",
        format: "%15.2f",
        value: 414972
      },
      {
        id: "06L-140",
        format: "%-1s",
        value: "Y"
      },
      {
        id: "06L-150",
        format: "%-2s",
        value: "1"
      },
      {
        id: "06L-160",
        format: "%-1s",
        value: "N"
      },
      {
        id: "06L-170",
        format: "%-1s",
        value: "N"
      },
      {
        id: "06L-180",
        format: "%-1s",
        value: "Y"
      },
      {
        id: "06L-190",
        format: "%-1s",
        value: "N"
      }
    ]
  end

  # def data_06s
  #   [
  #     {
  #       id: "06S-010",
  #       format: "%-3s",
  #       value: "06S"
  #     },
  #     {
  #       id: "06S-020",
  #       format: "%9s",
  #       value: "605593636"
  #     },
  #     {
  #       id: "06S-030",
  #       format: "%-3s",
  #       value: "HMB"
  #     },
  #     {
  #       id: "06S-040",
  #       format: "%15.2f",
  #       value: 231.01231
  #     }
  #   ]
  # end

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
        value: 0.0
      },
      {
        id: "07A-030",
        format: "%15.2f",
        value: 0.0
      },
      {
        id: "07A-040",
        format: "%15.2f",
        value: 0.0
      },
      {
        id: "07A-050",
        format: "%15.2f",
        value: 414972.0
      },
      {
        id: "07A-060",
        format: "%15.2f",
        value: 699.0
      },
      {
        id: "07A-070",
        format: "%15.2f",
        value: 1957.0
      },
      {
        id: "07A-080",
        format: "%15.2f",
        value: 0.0
      },
      {
        id: "07A-090",
        format: "%15.2f",
        value: 0.0
      },
      {
        id: "07A-100",
        format: "%15.2f",
        value: 0.0
      },
      {
        id: "07A-110",
        format: "%15.2f",
        value: 0.0
      },
      {
        id: "07A-120",
        format: "%15.2f",
        value: 0.0
      }
    ]
  end

  # def data_07b
  #   [
  #     {
  #       id: "07B-010",
  #       format: "%-3s",
  #       value: "07B"
  #     },
  #     {
  #         id: "07B-020",
  #         format: "%-2s",
  #         value: "01"
  #     },
  #     {
  #         id: "07B-030",
  #         format: "%15.2f",
  #         value: "150000"
  #     }
  #   ]
  # end

  def data_08a
    [{
      id: "08A-010",
      format: "%-3s",
      value: "08A"
    },
     {
       id: "08A-020",
       format: "%-9s",
       value: "605593636" # borrower ssn
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
end

# rubocop:enable ClassLength
# rubocop:enable MethodLength
