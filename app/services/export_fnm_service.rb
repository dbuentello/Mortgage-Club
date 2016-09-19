# rubocop:disable ClassLength
# rubocop:disable MethodLength
class ExportFnmService
  attr_accessor :loan, :subject_property, :credit_report, :loan_member, :assets, :loan_values, :borrower_values, :co_borrower_values, :current_employment_values, :previous_employment_values, :declaration_values, :relationship_manager_values, :subject_property_values, :primary_property_values

  def initialize(loan)
    # loan = Loan.find("5454f139-cdaa-49ea-8ccb-050df2b98d38")
    @loan = loan
    @subject_property = loan.subject_property
    @primary_property = loan.primary_property
    @credit_report = loan.borrower.credit_report
    @loan_values = loan.fnm_values
    @borrower_values = loan.borrower.fnm_values
    @co_borrower_values = loan.secondary_borrower ? loan.secondary_borrower.fnm_values : {}
    @current_employment_values = loan.borrower.current_employment.fnm_values
    @previous_employment_values = loan.borrower.previous_employment ? loan.borrower.previous_employment.fnm_values : {}
    @declaration_values = loan.borrower.declaration.fnm_values
    @relationship_manager_values = loan.relationship_manager.fnm_values
    @subject_property_values = loan.subject_property.subject_property_fnm
    @primary_property_values = loan.primary_property.primary_property_fnm
  end

  def call
    export_fnm = ExportFnmService.new(nil)
    array = export_fnm.methods.select { |a| a.to_s.match(/data_/) }

    out_file = File.new("1003.fnm", "w")
    out_file.puts build_data(data_eh).strip
    out_file.puts build_data(data_th).strip
    out_file.puts build_data(data_tpi).strip
    out_file.puts build_data(data_000_file).strip
    out_file.puts build_data(data_00a).strip
    out_file.puts build_data(data_01a).strip
    out_file.puts build_data(data_02a).strip
    # out_file.puts build_data(data_pai).strip
    out_file.puts build_data(data_02b).strip
    out_file.puts build_data(data_02c).strip

    if loan.purchase?
      out_file.puts build_data(data_02e).strip
    else
      out_file.puts build_data(data_02d).strip
    end

    out_file.puts build_data(data_03a_borrower).strip
    out_file.puts build_data(data_03a_co_borrower).strip

    if borrower_values[:dependent_ages].size > 0
      borrower_values[:dependent_ages].each do |age|
        out_file.puts build_data(data_03b(borrower_values[:ssn], age)).strip
      end
    end

    if co_borrower_values[:dependent_ages].size > 0
      co_borrower_values[:dependent_ages].each do |age|
        out_file.puts build_data(data_03b(co_borrower_values[:ssn], age)).strip
      end
    end

    out_file.puts build_data(data_03c).strip
    out_file.puts build_data(data_04a).strip
    out_file.puts build_data(data_04b).strip
    out_file.puts build_data(data_05h_first_mortgage).strip
    out_file.puts build_data(data_05h_hazard_insurance).strip
    out_file.puts build_data(data_05h_estate_tax).strip
    out_file.puts build_data(data_05h_mortgage_insurance).strip
    out_file.puts build_data(data_05h_homeowner).strip
    out_file.puts build_data(data_05i).strip

    loan.borrower.assets.each do |asset|
      out_file.puts build_data(data_06c(asset.fnm_values)).strip
    end

    out_file.puts build_data(data_06g).strip
    out_file.puts build_data(data_06l).strip

    out_file.puts build_data(data_07a).strip
    out_file.puts build_data(data_08a).strip
    out_file.puts build_data(data_08b).strip
    out_file.puts build_data(data_09a).strip
    out_file.puts build_data(data_10a).strip
    out_file.puts build_data(data_10b).strip
    out_file.puts build_data(data_10r).strip
    # out_file.puts build_data(data_000_additional_case).strip
    out_file.puts build_data(data_ads_1).strip
    out_file.puts build_data(data_ads_2).strip
    out_file.puts build_data(data_ads_4).strip
    out_file.puts build_data(data_000_product).strip
    out_file.puts build_data(data_lnc).strip
    out_file.puts build_data(data_pid).strip
    out_file.puts build_data(data_pch).strip

    out_file.puts build_data(data_paj).strip
    out_file.puts build_data(data_god).strip
    out_file.puts build_data(data_tt).strip
    out_file.puts build_data(data_et).strip

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
        value: loan_values[:amortization_type] # MAPPED
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
        value: "02A" # FIXED
      },
      {
        id: "02A-020",
        format: "%-50s",
        value: subject_property_values[:street_address] # MAPPED
      },
      {
        id: "02A-030",
        format: "%-35s",
        value: subject_property_values[:city] # MAPPED
      },
      {
        id: "02A-040",
        format: "%-2s",
        value: subject_property_values[:state] # MAPPED
      },
      {
        id: "02A-050",
        format: "%5s",
        value: subject_property_values[:zip] # MAPPED
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
        value: subject_property_values[:year_built] # MAPPED
      }
    ]
  end

  def data_pai
    [
      {
        id: "PAI-010",
        format: "%-3s",
        value: "PAI" # FIXED
      },
      {
        id: "PAI-020",
        format: "%-11s",
        value: "" # TODO
      },
      {
        id: "PAI-030",
        format: "%-40s",
        value: "" # TODO
      },
      {
        id: "PAI-040",
        format: "%-11s",
        value: "" # TODO
      }
    ]
  end

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
        value: subject_property_values[:usage] # MAPPED
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
        value: "02C" # FIXED
      },
      {
        id: "02C-020",
        format: "%-60s",
        value: "Thang B Dinh" # TODO
      }
    ]
  end

  def data_02d
    [
      {
        id: "02D-010",
        format: "%-3s",
        value: "02D" # FIXED
      },
      {
        id: "02D-020",
        format: "%-4s",
        value: "2015" # TODO
      },
      {
        id: "02D-030",
        format: "%15.2f",
        value: subject_property_values[:original_purchase_price] # MAPPED
      },
      {
        id: "02D-040",
        format: "%15.2f",
        value: 415000.00 # TODO
      },
      {
        id: "02D-050",
        format: "%15.2f",
        value: 0.00 # TODO
      },
      {
        id: "02D-060",
        format: "%15.2f",
        value: 0.00 # TODO
      },
      {
        id: "02D-070",
        format: "%-2s",
        value: "F1" # TODO
      },
      {
        id: "02D-080",
        format: "%-80s",
        value: "" # TODO
      },
      {
        id: "02D-090",
        format: "%-1s",
        value: "" # TODO
      },
      {
        id: "02D-100",
        format: "%15.2f",
        value: 0.00 # TODO
      }
    ]
  end

  def data_02e
    [
      {
        id: "02E-010",
        format: "%-3s",
        value: "02E" # FIXED
      },
      {
        id: "02E-020",
        format: "%-2s",
        value: "H3" # TODO
      },
      {
        id: "02E-030",
        format: "%15.2f",
        value: loan_values[:down_payment] # MAPPED
      },
      {
        id: "02E-040",
        format: "%-80s",
        value: "" # TODO
      }
    ]
  end

  def data_03a_borrower
    [
      {
        id: "03A-010",
        format: "%-3s",
        value: "03A"
      },
      {
        id: "03A-020",
        format: "%-2s",
        value: "BW"
      },
      {
        id: "03A-030",
        format: "%-9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "03A-040",
        format: "%-35s",
        value: borrower_values[:first_name] # MAPPED
      },
      {
        id: "03A-050",
        format: "%-35s",
        value: borrower_values[:middle_name] # MAPPED
      },
      {
        id: "03A-060",
        format: "%-35s",
        value: borrower_values[:last_name] # MAPPED
      },
      {
        id: "03A-070",
        format: "%-4s",
        value: borrower_values[:suffix] # MAPPED
      },
      {
        id: "03A-080",
        format: "%-10s",
        value: borrower_values[:phone] # MAPPED
      },
      {
        id: "03A-090",
        format: "%3s",
        value: borrower_values[:age] # MAPPED
      },
      {
        id: "03A-100",
        format: "%2s",
        value: borrower_values[:years_in_school] # MAPPED
      },
      {
        id: "03A-110",
        format: "%-1s",
        value: borrower_values[:marital_status] # MAPPED
      },
      {
        id: "03A-120",
        format: "%2s",
        value: borrower_values[:dependent_count] # MAPPED
      },
      {
        id: "03A-130",
        format: "%-1s",
        value: borrower_values[:is_file_taxes_jointly] #MAPPED
      },
      {
        id: "03A-140",
        format: "%9s",
        value: "" # TODO
      },
      {
        id: "03A-150",
        format: "%-8s",
        value: borrower_values[:dob] # MAPPED
      },
      {
        id: "03A-160",
        format: "%-80s",
        value: borrower_values[:email] # MAPPED
      }
    ]
  end

  def data_03a_co_borrower
    if co_borrower_values.present?
      [
        {
          id: "03A-010",
          format: "%-3s",
          value: "03A"
        },
        {
          id: "03A-020",
          format: "%-2s",
          value: "QZ"
        },
        {
          id: "03A-030",
          format: "%-9s",
          value: co_borrower_values[:ssn] # MAPPED
        },
        {
          id: "03A-040",
          format: "%-35s",
          value: co_borrower_values[:first_name] # MAPPED
        },
        {
          id: "03A-050",
          format: "%-35s",
          value: co_borrower_values[:middle_name] # MAPPED
        },
        {
          id: "03A-060",
          format: "%-35s",
          value: co_borrower_values[:last_name] # MAPPED
        },
        {
          id: "03A-070",
          format: "%-4s",
          value: co_borrower_values[:suffix] # MAPPED
        },
        {
          id: "03A-080",
          format: "%-10s",
          value: co_borrower_values[:phone] # MAPPED
        },
        {
          id: "03A-090",
          format: "%3s",
          value: co_borrower_values[:age] # MAPPED
        },
        {
          id: "03A-100",
          format: "%2s",
          value: co_borrower_values[:years_in_school] # MAPPED
        },
        {
          id: "03A-110",
          format: "%-1s",
          value: co_borrower_values[:marital_status] # MAPPED
        },
        {
          id: "03A-120",
          format: "%2s",
          value: co_borrower_values[:dependent_count] # MAPPED
        },
        {
          id: "03A-130",
          format: "%-1s",
          value: co_borrower_values[:is_file_taxes_jointly] #MAPPED
        },
        {
          id: "03A-140",
          format: "%9s",
          value: "" # TODO
        },
        {
          id: "03A-150",
          format: "%-8s",
          value: co_borrower_values[:dob] # MAPPED
        },
        {
          id: "03A-160",
          format: "%-80s",
          value: co_borrower_values[:email] # MAPPED
        }
      ]
    else
      []
    end
  end

  def data_03b(ssn, age)
    [
      {
        id: "03B-010",
        format: "%-3s",
        value: "03B" # FIXED
      },
      {
        id: "03B-020",
        format: "%9s",
        value: ssn # MAPPED
      },
      {
        id: "03B-030",
        format: "%3s",
        value: age # MAPPED
      }
    ]
  end

  def data_03c
    [
      {
        id: "03C-010",
        format: "%-3s",
        value: "03C" # FIXED
      },
      {
        id: "03C-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "03C-030",
        format: "%-2s",
        value: "ZG" # TODO
      },
      {
        id: "03C-040",
        format: "%-50s",
        value: primary_property_values[:street_address] # MAPPED
      },
      {
        id: "03C-050",
        format: "%-35s",
        value: primary_property_values[:city] # MAPPED
      },
      {
        id: "03C-060",
        format: "%-2s",
        value: primary_property_values[:state] # MAPPED
      },
      {
        id: "03C-070",
        format: "%5s",
        value: primary_property_values[:zip] # MAPPED
      },
      {
        id: "03C-080",
        format: "%4s",
        value: "" # TODO
      },
      {
        id: "03C-010",
        format: "%-1s",
        value: "O" # TODO
      },
      {
        id: "03C-010",
        format: "%2s",
        value: 2 # TODO
      },
      {
        id: "03C-010",
        format: "%2s",
        value: "" # TODO
      },
      {
        id: "03C-010",
        format: "%-50s",
        value: "" # TODO
      }
    ]
  end

  def data_04a
    [
      {
        id: "04A-010",
        format: "%-3s",
        value: "04A" # FIXED
      },
      {
        id: "04A-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "04A-030",
        format: "%-35s",
        value: current_employment_values[:employer_name] # MAPPED
      },
      {
        id: "04A-040",
        format: "%-35s",
        value: current_employment_values[:street_address] # MAPPED
      },
      {
        id: "04A-050",
        format: "%-35s",
        value: current_employment_values[:city] # MAPPED
      },
      {
        id: "04A-060",
        format: "%-2s",
        value: current_employment_values[:state] # MAPPED
      },
      {
        id: "04A-070",
        format: "%5s",
        value: current_employment_values[:zip] # MAPPED
      },
      {
        id: "04A-080",
        format: "%4s",
        value: "" # TODO
      },
      {
        id: "04A-090",
        format: "%-1s",
        value: borrower_values[:self_employed] # MAPPED
      },
      {
        id: "04A-100",
        format: "%2s",
        value: current_employment_values[:duration] # MAPPED
      },
      {
        id: "04A-110",
        format: "%2s",
        value: "" # TODO
      },
      {
        id: "04A-120",
        format: "%2s",
        value: "10" # TODO
      },
      {
        id: "04A-130",
        format: "%-25s",
        value: current_employment_values[:job_title] # MAPPED
      },
      {
        id: "04A-140",
        format: "%10s",
        value: "8554646268" # TODO
      }
    ]
  end

  def data_04b
    if previous_employment_values.present?
      [
        {
          id: "04B-010",
          format: "%-3s",
          value: "04B" # FIXED
        },
        {
          id: "04B-020",
          format: "%9s",
          value: borrower_values[:ssn] # MAPPED
        },
        {
          id: "04B-030",
          format: "%-35s",
          value: previous_employment_values[:employer_name] # MAPPED
        },
        {
          id: "04B-040",
          format: "%-35s",
          value: previous_employment_values[:street_address] # MAPPED
        },
        {
          id: "04B-050",
          format: "%-35s",
          value: previous_employment_values[:city] # MAPPED
        },
        {
          id: "04B-060",
          format: "%-2s",
          value: previous_employment_values[:state] # MAPPED
        },
        {
          id: "04B-070",
          format: "%5s",
          value: previous_employment_values[:zip] # MAPPED
        },
        {
          id: "04B-080",
          format: "%4s",
          value: "" # TODO
        },
        {
          id: "04B-090",
          format: "%-1s",
          value: borrower_values[:self_employed] # MAPPED
        },
        {
          id: "04B-100",
          format: "%-1s",
          value: "N" # FIXED
        },
        {
          id: "04B-110",
          format: "%-8s",
          value: "20131231" # TODO
        },
        {
          id: "04B-120",
          format: "%-8s",
          value: "20151231" # TODO
        },
        {
          id: "04B-130",
          format: "%15.2f",
          value: previous_employment_values[:current_salary] # MAPPED
        },
        {
          id: "04B-140",
          format: "%-25s",
          value: previous_employment_values[:job_title] # MAPPED
        },
        {
          id: "04B-150",
          format: "%10s",
          value: "8554646268" # TODO
        }
      ]
    else
      []
    end
  end

  def data_05h_first_mortgage
    [
      {
        id: "05H-010",
        format: "%-3s",
        value: "05H" # FIXED
      },
      {
        id: "05H-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "05H-030",
        format: "%-1s",
        value: "2" # MAPPED
      },
      {
        id: "05H-040",
        format: "%-2s",
        value: "26" # MAPPED
      },
      {
        id: "05H-050",
        format: "%15.2f",
        value: loan_values[:monthly_payment] # MAPPED
      }
    ]
  end

  def data_05h_hazard_insurance
    [
      {
        id: "05H-010",
        format: "%-3s",
        value: "05H" # FIXED
      },
      {
        id: "05H-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "05H-030",
        format: "%-1s",
        value: "2" # MAPPED
      },
      {
        id: "05H-040",
        format: "%-2s",
        value: "01" # MAPPED
      },
      {
        id: "05H-050",
        format: "%15.2f",
        value: subject_property_values[:estimated_hazard_insurance] # MAPPED
      }
    ]
  end

  def data_05h_estate_tax
    [
      {
        id: "05H-010",
        format: "%-3s",
        value: "05H" # FIXED
      },
      {
        id: "05H-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "05H-030",
        format: "%-1s",
        value: "2" # MAPPED
      },
      {
        id: "05H-040",
        format: "%-2s",
        value: "14" # MAPPED
      },
      {
        id: "05H-050",
        format: "%15.2f",
        value: subject_property_values[:estimated_property_tax] # MAPPED
      }
    ]
  end

  def data_05h_mortgage_insurance
    [
      {
        id: "05H-010",
        format: "%-3s",
        value: "05H" # FIXED
      },
      {
        id: "05H-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "05H-030",
        format: "%-1s",
        value: "2" # MAPPED
      },
      {
        id: "05H-040",
        format: "%-2s",
        value: "02" # MAPPED
      },
      {
        id: "05H-050",
        format: "%15.2f",
        value: loan_values[:pmi_monthly_premium_amount] # MAPPED
      }
    ]
  end

  def data_05h_homeowner
    [
      {
        id: "05H-010",
        format: "%-3s",
        value: "05H" # FIXED
      },
      {
        id: "05H-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "05H-030",
        format: "%-1s",
        value: "2" # MAPPED
      },
      {
        id: "05H-040",
        format: "%-2s",
        value: "06" # MAPPED
      },
      {
        id: "05H-050",
        format: "%15.2f",
        value: subject_property_values[:hoa_due] # MAPPED
      }
    ]
  end

  def data_05i
    [
      {
        id: "05I-010",
        format: "%-3s",
        value: "05I" # FIXED
      },
      {
        id: "05I-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "05I-030",
        format: "%-2s",
        value: "20" # TODO
      },
      {
        id: "05I-040",
        format: "%15.2f",
        value: current_employment_values[:current_salary] # MAPPED
      }
    ]
  end

  def data_06a
    [
      {
        id: "06A-010",
        format: "%-3s",
        value: "06A" # FIXED
      },
      {
        id: "06A-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "06A-030",
        format: "%-35s",
        value: "" # TODO
      },
      {
        id: "06A-040",
        format: "%15.2f",
        value: 3123.231 # TODO
      }
    ]
  end

  def data_06b
    [
      {
        id: "06B-010",
        format: "%-3s",
        value: "06B" # FIXED
      },
      {
        id: "06B-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "06B-030",
        format: "%-30s",
        value: "" # TODO
      },
      {
        id: "06B-040",
        format: "%15.2f",
        value: 3123.231 # TODO
      },
      {
        id: "06B-050",
        format: "%15.2f",
        value: 3123.231 # TODO
      }
    ]
  end

  def data_06c(asset)
    [
      {
        id: "06C-010",
        format: "%-3s",
        value: "06C" # FIXED
      },
      {
        id: "06C-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "06C-030",
        format: "%-3s",
        value: asset[:asset_type] # MAPPED
      },
      {
        id: "06C-040",
        format: "%-35s",
        value: asset[:institution_name] # MAPPED
      },
      {
        id: "06C-050",
        format: "%-35s",
        value: "" # TODO
      },
      {
        id: "06C-060",
        format: "%-35s",
        value: "" # TODO
      },
      {
        id: "06C-070",
        format: "%-2s",
        value: "" # TODO
      },
      {
        id: "06C-080",
        format: "%5s",
        value: "" # TODO
      },
      {
        id: "06C-090",
        format: "%4s",
        value: "" # TODO
      },
      {
        id: "06C-100",
        format: "%-30s",
        value: "" # TODO
      },
      {
        id: "06C-110",
        format: "%15.2f",
        value: asset[:current_balance] # MAPPED
      },
      {
        id: "06C-120",
        format: "%7s",
        value: "" # TODO
      },
      {
        id: "06C-130",
        format: "%-80s",
        value: "" # TODO
      },
      {
        id: "06C-140",
        format: "%-1s",
        value: "" # TODO
      },
      {
        id: "06C-150",
        format: "%-2s",
        value: "" # TODO
      }
    ]
  end

  def data_06d
    [
      {
        id: "06D-010",
        format: "%-3s",
        value: "06D" # FIXED
      },
      {
        id: "06D-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "06D-030",
        format: "%-30s",
        value: "3123" # TODO
      },
      {
        id: "06D-040",
        format: "%-4s",
        value: "2015" # TODO
      },
      {
        id: "06D-050",
        format: "%15.2f",
        value: 1231.123 # TODO
      }
    ]
  end

  # need to improve
  # def data_06f
  #   [
  #     {
  #       id: "06F-010",
  #       format: "%-3s",
  #       value: "06F" # FIXED
  #     },
  #     {
  #       id: "06F-020",
  #       format: "%9s",
  #       value: borrower_values[:ssn] # MAPPED
  #     },
  #     {
  #       id: "06F-030",
  #       format: "%-3s",
  #       value: "DR" # TODO
  #     },
  #     {
  #       id: "06F-040",
  #       format: "%15.2f",
  #       value: 13123.12312 # TODO
  #     },
  #     {
  #       id: "06F-050",
  #       format: "%3s",
  #       value: 360 # TODO
  #     },
  #     {
  #       id: "06F-060",
  #       format: "%-60s",
  #       value: "sadad" # TODO
  #     }
  #   ]
  # end

  def data_06g
    [
      {
        id: "06G-010",
        format: "%-3s",
        value: "06G" # FIXED
      },
      {
        id: "06G-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "06G-030",
        format: "%-35s",
        value: "2320 Meadowmont Dr" # TODO
      },
      {
        id: "06G-040",
        format: "%-35s",
        value: "San Jose" # TODO
      },
      {
        id: "06G-050",
        format: "%-2s",
        value: "CA" # TODO
      },
      {
        id: "06G-060",
        format: "%5s",
        value: "95133" # TODO
      },
      {
        id: "06G-070",
        format: "%4s",
        value: "" # TODO
      },
      {
        id: "06G-080",
        format: "%-1s",
        value: "H" # TODO
      },
      {
        id: "06G-090",
        format: "%-2s",
        value: "14" # TODO
      },
      {
        id: "06G-100",
        format: "%15.2f",
        value: 625000.00 # TODO
      },
      {
        id: "06G-110",
        format: "%15.2f",
        value: 414972.00 # TODO
      },
      {
        id: "06G-120",
        format: "%15.2f",
        value: 0.00 # TODO
      },
      {
        id: "06G-130",
        format: "%15.2f",
        value: 1903.00 # TODO
      },
      {
        id: "06G-140",
        format: "%15.2f",
        value: 617.00 # TODO
      },
      {
        id: "06G-150",
        format: "%15.2f",
        value: 0.00 # TODO
      },
      {
        id: "06G-160",
        format: "%-1s",
        value: "Y" # TODO
      },
      {
        id: "06G-170",
        format: "%-1s",
        value: "Y" # TODO
      },
      {
        id: "06G-180",
        format: "%-2s",
        value: "1" # TODO
      },
      {
        id: "06G-190",
        format: "%-15s",
        value: "" # TODO
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
        value: "06L" # FIXED
      },
      {
        id: "06L-020",
        format: "%9s",
        value: borrower_values[:ssn] # MAPPED
      },
      {
        id: "06L-030",
        format: "%-2s",
        value: "M" # TODO
      },
      {
        id: "06L-040",
        format: "%-35s",
        value: "WFHM" # TODO
      },
      {
        id: "06L-050",
        format: "%-35s",
        value: "PO BOX 10335" # TODO
      },
      {
        id: "06L-060",
        format: "%-35s",
        value: "DES MOINES" # TODO
      },
      {
        id: "06L-070",
        format: "%-2s",
        value: "IA" # TODO
      },
      {
        id: "06L-080",
        format: "%5s",
        value: "50306" # TODO
      },
      {
        id: "06L-090",
        format: "%4s",
        value: "" # TODO
      },
      {
        id: "06L-100",
        format: "%-30s",
        value: "9360500931597" # TODO
      },
      {
        id: "06L-110",
        format: "%15.2f",
        value: 1903.0 # TODO
      },
      {
        id: "06L-120",
        format: "%3s",
        value: 0 # TODO
      },
      {
        id: "06L-130",
        format: "%15.2f",
        value: 414972 # TODO
      },
      {
        id: "06L-140",
        format: "%-1s",
        value: "Y" # TODO
      },
      {
        id: "06L-150",
        format: "%-2s",
        value: "1" # TODO
      },
      {
        id: "06L-160",
        format: "%-1s",
        value: "N" # TODO
      },
      {
        id: "06L-170",
        format: "%-1s",
        value: "N" # TODO
      },
      {
        id: "06L-180",
        format: "%-1s",
        value: "Y" # TODO
      },
      {
        id: "06L-190",
        format: "%-1s",
        value: "N" # TODO
      }
    ]
  end

  # def data_06s
  #   [
  #     {
  #       id: "06S-010",
  #       format: "%-3s",
  #       value: "06S" # FIXED
  #     },
  #     {
  #       id: "06S-020",
  #       format: "%9s",
  #       value: borrower_values[:ssn] # MAPPED
  #     },
  #     {
  #       id: "06S-030",
  #       format: "%-3s",
  #       value: "HMB" # TODO
  #     },
  #     {
  #       id: "06S-040",
  #       format: "%15.2f",
  #       value: 231.01231 # TODO
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
        value: @subject_property_values[:purchase_price]
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
        value: @loan_values[:amount]
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
        value: @loan_values[:discount_pts]
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
       value: borrower_values[:ssn] # MAPPED
     },
     {
       id: "08A-030",
       format: "%-1s",
       value: declaration_values[:outstanding_judgment] # MAPPED
     },
     {
       id: "08A-040",
       format: "%-1s",
       value: declaration_values[:bankrupt] # MAPPED
     },
     {
       id: "08A-050",
       format: "%-1s",
       value: declaration_values[:loan_foreclosure] # MAPPED
     },
     {
       id: "08A-060",
       format: "%-1s",
       value: declaration_values[:party_to_lawsuit] # MAPPED
     },
     {
       id: "08A-070",
       format: "%-1s",
       value: "N" # TODO
     },
     {
       id: "08A-080",
       format: "%-1s",
       value: declaration_values[:present_delinquent_loan] # MAPPED
     },
     {
       id: "08A-090",
       format: "%-1s",
       value: "N" # TODO
     },
     {
       id: "08A-100",
       format: "%-1s",
       value: declaration_values[:down_payment_borrowed] # MAPPED
     },
     {
       id: "08A-110",
       format: "%-1s",
       value: declaration_values[:co_maker_or_endorser] # MAPPED
     },
     {
       id: "08A-120",
       format: "%-2s",
       value: declaration_values[:citizen_status] # MAPPED
     },
     {
       id: "08A-130",
       format: "%-1s",
       value: "Y" # TODO
     },
     {
       id: "08A-140",
       format: "%-1s",
       value: declaration_values[:ownership_interest] # MAPPED
     },
     {
       id: "08A-150",
       format: "%-1s",
       value: subject_property_values[:usage] # property.usage
     },
     {
       id: "08A-160",
       format: "%-2s",
       value: "25" # TODO
     }]
  end

  def data_08b
    [{
        id: "08B-010",
        format: "%-3s",
        value: "08B"
    },
    {
        id: "08B-020",
        format: "%-9s",
        value: borrower_values[:ssn] #borrower.ssn
    },
    {
        id: "08B-030",
        format: "%-2s",
        value: "91" #borrower.declaration explanations
    },
    {
        id: "08B-040",
        format: "%-255s",
        value: "asdasdasdasd  ASSDASDW"
    }]
  end

  def data_09a
    [{
        id: "09A-010",
        format: "%-3s",
        value: "09A"
    },
    {
        id: "09A-020",
        format: "%-9s",
        value: borrower_values[:ssn] #borrower.ssn
    },
    {
        id: "09A-030",
        format: "%-8s",
        value: "CCYYMMDD" #Current date : CCYYMMDD
    }]
  end

  def data_10a
    [{
      id: "10A-010",
      format: "%-3s",
      value: "10A"
    },
     {
       id: "10A-020",
       format: "%-9s",
       value: borrower_values[:ssn] # borrower.ssn
     },
     {
       id: "10A-030",
       format: "%-1s",
       value: "N"
     },
     {
       id: "10A-040",
       format: "%-1s",
       value: declaration_values[:is_hispanic_or_latino] # is_hispanic_or_latino
     },
     {
       id: "10A-050",
       format: "%-30s",
       value: ""
     },
     {
       id: "10A-060",
       format: "%-1s",
       value: declaration_values[:gender_type] # gender_type
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
       value: relationship_manager_values[:name] # l.relationship_manager.user.first_name and last_name
     },
     {
       id: "10B-040",
       format: "%-8s",
       value: "" # Interview Date
     },
     {
       id: "10B-050",
       format: "%-10s",
       value: relationship_manager_values[:phone_number] # l.relationship_manager.phone_number
     },
     {
       id: "10B-060",
       format: "%-35s",
       value: relationship_manager_values[:company_name] # l.relationship_manager.company_name
     },
     {
       id: "10B-070",
       format: "%-35s",
       value: relationship_manager_values[:company_address] # l.relationship_manager.company_address
     },
     {
       id: "10B-080",
       format: "%-35s",
       value: ""
     },
     {
       id: "10B-090",
       format: "%-35s",
       value: ""
     },
     {
       id: "10B-100",
       format: "%-2s",
       value: ""
     },
     {
       id: "10B-110",
       format: "%5s",
       value: "94105" # zip code
     },
     {
       id: "10B-120",
       format: "%4s",
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
       value: borrower_values[:ssn] # borrower.ssn
     },
     {
       id: "10R-030",
       format: "%-2s",
       value: declaration_values[:race_type]
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
       value: relationship_manager_values[:nmls_id]
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
       value: relationship_manager_values[:company_nmls]
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
       value: borrower_values[:years_in_school_bool]
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
       value: loan_values[:amortization_type] # l.amortization_type
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

  def data_paj
    [{
        id: "PAJ-010",
        format: "%-3s",
        value: "PAJ"
    },
    {
        id: "PAJ-020",
        format: "%4s",
        value: ""
    },
    {
        id: "PAJ-030",
        format: "%3s",
        value: loan_values[:num_of_months]
    },
    {
        id: "PAJ-040",
        format: "%3s",
        value: "12"
    },
    {
        id: "PAJ-050",
        format: "%-1s",
        value: "1"
    },
    {
        id: "PAJ-060",
        format: "%7.3f",
        value: "1"
    },
    {
        id: "PAJ-070",
        format: "%15.2f",
        value: "1"
    },
    {
        id: "PAJ-080",
        format: "%7.3f",
        value: "1"
    },
    {
        id: "PAJ-090",
        format: "%15.2f",
        value: "1"
    },
    {
        id: "PAJ-100",
        format: "%3s",
        value: ""
    }]
  end

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

  def data_god
    [{
        id: "GOD-010",
        format: "%-3s",
        value: "GOD"
    },
    {
        id: "GOD-020",
        format: "%9s",
        value: borrower_values[:ssn]
    },
    {
        id: "GOD-030",
        format: "%15.2f",
        value: "1"
    },
    {
        id: "GOD-040",
        format: "%15.2f",
        value: "1"
    },
    {
        id: "GOD-050",
        format: "%15.2f",
        value: "1"
    },
    {
        id: "GOD-060",
        format: "%15.2f",
        value: "1"
    },
    {
        id: "GOD-070",
        format: "%15.2f",
        value: "1"
    },
    {
        id: "GOD-080",
        format: "%15.2f",
        value: "1"
    },
    {
        id: "GOD-090",
        format: "%15.2f",
        value: "1"
    },
    {
        id: "GOD-100",
        format: "%15.2f",
        value: "1"
    }]
  end

  def data_goe
    [{
        id: "GOE-010",
        format: "%-3s",
        value: "GOE"
    },
    {
        id: "GOE-020",
        format: "%9s",
        value: borrower_values[:ssn]
    },
    {
        id: "GOE-030",
        format: "%-10s",
        value: ""
    },
    {
        id: "GOE-040",
        format: "%-3s",
        value: ""
    },
    {
        id: "GOE-050",
        format: "%-3s",
        value: ""
    },
    {
        id: "GOE-060",
        format: "%-3s",
        value: ""
    },
    {
        id: "GOE-070",
        format: "%-1s",
        value: "A"
    }]
  end

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
