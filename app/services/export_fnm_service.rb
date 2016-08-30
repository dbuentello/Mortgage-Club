class ExportFnmService
  attr_accessor :loan, :borrower, :subject_property, :credit_report, :loan_member, :assets, :co_borrower

  def initialize
  end

  def call
  end

  def build_eh
    line = StringIO.new
    line << format("%-3s", "EH")
    line << format("%-6s", "")
    line << format("%-25s", "")
    line << format("%-11s", "20160808")
    line << format("%-9s", "ENV1")

    line.string
  end

  def build_th
    line = StringIO.new
    line << format("%-3s", "TH")
    line << format("%-11s", "T100099-002")
    line << format("%-9s", "TRAN1")

    line.string
  end

  def build_tpi
    line = StringIO.new
    line << format("%-3s", "TPI")
    line << format("%-5s", "1.00")
    line << format("%-2s", "01")
    line << format("%-30s", "")
    line << format("%-1s", "N")

    line.string
  end
end
