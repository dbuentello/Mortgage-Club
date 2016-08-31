# rubocop:disable ClassLength
# rubocop:disable MethodLength
class ExportFnmServicePart
  attr_accessor :loan, :subject_property, :credit_report, :loan_member, :assets, :subject_property_fnm, :loan_values

  def initialize(loan)
    loan = Loan.find("70a6e6bd-7622-4b3e-acdd-da3c824ee878")
    @loan = loan
    @subject_property = loan.subject_property
    @primary_property = loan.primary_property
    @credit_report = loan.borrower.credit_report
    @loan_values = loan.fnm_values
    # @borrower_values = loan.borrower.fnm_values
    # @co_borrower_values = loan.secondary_borrower ? loan.secondary_borrower.fnm_values : {}
    # @current_employment_values = loan.borrower.current_employment.fnm_values
    # @previous_employment_values = loan.borrower.previous_employment ? loan.borrower.previous_employment.fnm_values : {}
    # @declaration_values = loan.borrower.declaration.fnm_values
    @subject_property_fnm = loan.subject_property.subject_property_fnm

  end

  def call
    export_fnm = ExportFnmServicePart.new(nil)
    array = export_fnm.methods.select { |a| a.to_s.match(/data_/) }

    out_file = File.new("1003.fnm", "w")
    array.each do |method|
      line = build_data(export_fnm.send(method.to_s)).strip
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
    build_data(data_02d)
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
        value: subject_property_fnm[:year_built] # MAPPED
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
        value: subject_property_fnm[:usage] # MAPPED
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
        value: subject_property_fnm[:original_purchase_price] # l.subject_property_original_purchase_price
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
end

# rubocop:enable ClassLength
# rubocop:enable MethodLength
