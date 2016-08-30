class ExportFnmService
  attr_accessor :loan, :borrower, :subject_property, :credit_report, :loan_member, :assets, :co_borrower

  def initialize
  end

  def call
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
        value: "EH"
      },
      {
        id: "EH-020",
        format: "%-6s",
        value: ""
      },
      {
        id: "EH-030",
        format: "%-25s",
        value: ""
      },
      {
        id: "EH-040",
        format: "%-11s",
        value: "20160808"
      },
      {
        id: "EH-050",
        format: "%-9s",
        value: "ENV1"
      }
    ]
  end

  def data_th
    [
      {
        id: "TH-010",
        format: "%-3s",
        value: "TH"
      },
      {
        id: "TH-020",
        format: "%-11s",
        value: "T100099-002"
      },
      {
        id: "TH-030",
        format: "%-9s",
        value: "TRAN1"
      }
    ]
  end

  def data_tpi
    [
      {
        id: "TPI-010",
        format: "%-3s",
        value: "TPI"
      },
      {
        id: "TPI-020",
        format: "%-5s",
        value: "1.00"
      },
      {
        id: "TPI-030",
        format: "%-2s",
        value: "01"
      },
      {
        id: "TPI-040",
        format: "%-30s",
        value: ""
      },
      {
        id: "TPI-050",
        format: "%-1s",
        value: "N"
      }
    ]
  end

  def data_000
    [
      {
        id: "000-010",
        format: "%-3s",
        value: "000"
      },
      {
        id: "000-020",
        format: "%-3s",
        value: "1"
      },
      {
        id: "000-030",
        format: "%-5s",
        value: "3.20"
      },
      {
        id: "000-040",
        format: "%-1s",
        value: "W"
      }
    ]
  end

  def data_00a
    [
      {
        id: "00A-010",
        format: "%-3s",
        value: "00A"
      },
      {
        id: "00A-020",
        format: "%-1s",
        value: "Y"
      },
      {
        id: "00A-030",
        format: "%-1s",
        value: "Y"
      }
    ]
  end

  def data_01a
    [
      {
        id: "01A-010",
        format: "%-3s",
        value: "01A"
      },
      {
        id: "01A-020",
        format: "%-2s", # l.loan_type
        value: "01"
      },
      {
        id: "01A-030",
        format: "%-80s",
        value: ""
      },
      {
        id: "01A-040",
        format: "%-30s",
        value: ""
      },
      {
        id: "01A-050",
        format: "%-15s",
        value: ""
      },
      {
        id: "01A-060",
        format: "%15.2f",
        value: 414972.0 # l.amount
      },
      {
        id: "01A-070",
        format: "%7.3f",
        value: 3.251423 # l.interest_rate
      },
      {
        id: "01A-080",
        format: "%3s",
        value: 360 # l.num_of_months
      },
      {
        id: "01A-090",
        format: "%-2s",
        value: "05" # l.amortization_type
      },
      {
        id: "01A-100",
        format: "%-80s",
        value: ""
      },
      {
        id: "01A-110",
        format: "%-80s",
        value: ""
      }
    ]
  end

  def data_02a
    [
      {
        id: "02A-010",
        format: "%-3s",
        value: "01A"
      },
      {
        id: "02A-020",
        format: "%-50s", # l.subject_property.address.street_address
        value: "2320 Meadowmont Dr"
      },
      {
        id: "02A-030",
        format: "%-35s", # l.subject_property.address.city
        value: "San Jose"
      },
      {
        id: "02A-040",
        format: "%-2s", # l.subject_property.address.state
        value: "CA"
      },
      {
        id: "02A-050",
        format: "%5s", # l.subject_property.address.zip
        value: "95133"
      },
      {
        id: "02A-060",
        format: "%4s",
        value: ""
      },
      {
        id: "02A-070",
        format: "%3s",
        value: "1"
      },
      {
        id: "02A-080",
        format: "%-2s",
        value: "F1"
      },
      {
        id: "02A-090",
        format: "%-80s",
        value: "SEE PRELIMINARY TITLE"
      },
      {
        id: "02A-100",
        format: "%-4s", # l.subject_property.year_built
        value: "1972"
      }
    ]
  end

  def data_pai
    [
      {
        id: "PAI-010",
        format: "%-3s",
        value: "PAI"
      },
      {
        id: "PAI-020",
        format: "%-11s",
        value: ""
      },
      {
        id: "PAI-030",
        format: "%-40s",
        value: ""
      },
      {
        id: "PAI-040",
        format: "%-11s",
        value: ""
      }
    ]
  end

  def data_02b
    [
      {
        id: "02B-010",
        format: "%-3s",
        value: "02B"
      },
      {
        id: "02B-020",
        format: "%-2s",
        value: ""
      },
      {
        id: "02B-030",
        format: "%-2s",
        value: "05" # l.purpose
      },
      {
        id: "02B-040",
        format: "%-80s",
        value: ""
      },
      {
        id: "02B-050",
        format: "%-1s",
        value: "1" # l.subject_property.usage
      },
      {
        id: "02B-060",
        format: "%-60s",
        value: "To be decided in escrow"
      },
      {
        id: "02B-070",
        format: "%-1s",
        value: "1"
      },
      {
        id: "02B-080",
        format: "%-8s",
        value: ""
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

  def data_02e
    [
      {
        id: "02E-010",
        format: "%-3s",
        value: "02E"
      },
      {
        id: "02E-020",
        format: "%-2s",
        value: "H3"
      },
      {
        id: "02E-030",
        format: "%15.2f",
        value: 0.00
      },
      {
        id: "02E-040",
        format: "%-80s",
        value: ""
      }
    ]
  end

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

  #1 age 1 row
  def data_03b
    [
      {
        id: "03B-010",
        format: "%-3s",
        value: "03B"
      },
      {
        id: "03B-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "03B-030",
        format: "%3s",
        value: "3"
      }
    ]
  end

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
        value: "Mountain View"  # l.borrower.current_employment.address.city
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

  def data_04b
    [
      {
        id: "04B-010",
        format: "%-3s",
        value: "04B"
      },
      {
        id: "04B-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "04B-030",
        format: "%-35s",
        value: "Addepar" # l.borrower.previous_employment.employer_name
      },
      {
        id: "04B-040",
        format: "%-35s",
        value: "1215 Terra Bella Ave" # l.borrower.previous_employment.address.street_address
      },
      {
        id: "04B-050",
        format: "%-35s",
        value: "Mountain View"  # l.borrower.previous_employment.address.city
      },
      {
        id: "04B-060",
        format: "%-2s",
        value: "CA" # l.borrower.previous_employment.address.state
      },
      {
        id: "04B-070",
        format: "%5s",
        value: "94043" # l.borrower.previous_employment.address.zip
      },
      {
        id: "04B-080",
        format: "%4s",
        value: ""
      },
      {
        id: "04B-090",
        format: "%-1s",
        value: "N" # l.borrower.self_employed
      },
      {
        id: "04B-100",
        format: "%-1s",
        value: "N"
      },
      {
        id: "04B-110",
        format: "%-8s",
        value: "20131231"
      },
      {
        id: "04B-120",
        format: "%-8s",
        value: "20151231"
      },
      {
        id: "04B-130",
        format: "%15.2f",
        value: 12100.3123
      },
      {
        id: "04B-140",
        format: "%-25s",
        value: "Software Engineer" # l.borrower.previous_employment.job_title
      },
      {
        id: "04B-150",
        format: "%10s",
        value: "8554646268"
      }
    ]
  end

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
        value: "26"
      },
      {
        id: "05H-050",
        format: "%15.2f",
        value: "1903.95123"
      },
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
        value: "F1"
      },
      {
        id: "05I-040",
        format: "%15.2f",
        value: 100000.0223
      }
    ]
  end

  def data_06a
    [
      {
        id: "06A-010",
        format: "%-3s",
        value: "06A"
      },
      {
        id: "06A-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "06A-030",
        format: "%-35s",
        value: ""
      },
      {
        id: "06A-040",
        format: "%15.2f",
        value: 3123.231
      }
    ]
  end

  def data_06b
    [
      {
        id: "06B-010",
        format: "%-3s",
        value: "06B"
      },
      {
        id: "06B-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "06B-030",
        format: "%-30s",
        value: ""
      },
      {
        id: "06B-040",
        format: "%15.2f",
        value: 3123.231
      },
      {
        id: "06B-050",
        format: "%15.2f",
        value: 3123.231
      }
    ]
  end

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

  def data_06d
    [
      {
        id: "06D-010",
        format: "%-3s",
        value: "06D"
      },
      {
        id: "06D-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "06D-030",
        format: "%-30s",
        value: "3123"
      },
      {
        id: "06D-040",
        format: "%-4s",
        value: "2015"
      },
      {
        id: "06D-050",
        format: "%15.2f",
        value: 1231.123
      }
    ]
  end

  def data_06f
    [
      {
        id: "06F-010",
        format: "%-3s",
        value: "06F"
      },
      {
        id: "06F-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "06F-030",
        format: "%-3s",
        value: "DR"
      },
      {
        id: "06F-040",
        format: "%15.2f",
        value: 13123.12312
      },
      {
        id: "06F-050",
        format: "%3s",
        value: 360
      },
      {
        id: "06F-060",
        format: "%-60s",
        value: "sadad"
      },
    ]
  end

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

  def data_06h
    [
      {
        id: "06H-010",
        format: "%-3s",
        value: "06H"
      },
      {
        id: "06H-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "06H-030",
        format: "%-35s",
        value: "213"
      },
      {
        id: "06H-040",
        format: "%-35s",
        value: "123"
      },
      {
        id: "06H-050",
        format: "%-35s",
        value: "123"
      },
      {
        id: "06H-060",
        format: "%-15s",
        value: "123"
      },
      {
        id: "06H-070",
        format: "%-15s",
        value: "123"
      }
    ]
  end

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
        value: "I"
      },
      {
        id: "06L-040",
        format: "%-35s",
        value: "CHASE AUTO"
      },
      {
        id: "06L-050",
        format: "%-35s",
        value: "2000 MARCUS AVENUE"
      },
      {
        id: "06L-060",
        format: "%-35s",
        value: "NEW HYDE PARK"
      },
      {
        id: "06L-070",
        format: "%-2s",
        value: "NY"
      },
      {
        id: "06L-080",
        format: "%5s",
        value: "11042"
      },
      {
        id: "06L-090",
        format: "%4s",
        value: ""
      },
      {
        id: "06L-100",
        format: "%-30s",
        value: "11530520205603"
      },
      {
        id: "06L-110",
        format: "%15.2f",
        value: 468.00
      },
      {
        id: "06L-120",
        format: "%3s",
        value: 0
      },
      {
        id: "06L-130",
        format: "%15.2f",
        value: 22903.00
      },
      {
        id: "06L-140",
        format: "%-1s",
        value: "N"
      },
      {
        id: "06L-150",
        format: "%2s",
        value: ""
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
        value: ""
      },
      {
        id: "06L-190",
        format: "%-1s",
        value: ""
      }
    ]
  end

  def data_06s
    [
      {
        id: "06S-010",
        format: "%-3s",
        value: "06S"
      },
      {
        id: "06S-020",
        format: "%9s",
        value: "605593636"
      },
      {
        id: "06S-030",
        format: "%-3s",
        value: "HMB"
      },
      {
        id: "06S-040",
        format: "%15.2f",
        value: 231.01231
      }
    ]
  end
end
