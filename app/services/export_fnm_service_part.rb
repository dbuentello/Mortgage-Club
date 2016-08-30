class ExportFnmServicePart
  attr_accessor :loan, :borrower, :subject_property, :credit_report, :loan_member, :assets, :co_borrower

  def initialize
  end

  def call
  end

  def build_data(inputs)
    line = StringIO.new

    inputs.each do |d|
      line << format(d[:format], d[:value])
    end

    line.string
  end

  def build_07a
    build_data(data_07a)
  end

  def data_07a
    [{
        id: "07A-010",
        format: "%-3s",
        value: "07A"
    },
    {
        id: "07A-020",
        format: "%15.2f",
        value: "150000"
    },
    {
        id: "07A-030",
        format: "%15.2f",
        value: "150000"
    },
    {
        id: "07A-040",
        format: "%15.2f",
        value: "150000"
    },
    {
        id: "07A-050",
        format: "%15.2f",
        value: "150000"
    },
    {
        id: "07A-060",
        format: "%15.2f",
        value: "150000"
    },
    {
        id: "07A-070",
        format: "%15.2f",
        value: "150000"
    },
    {
        id: "07A-080",
        format: "%15.2f",
        value: "150000"
    },
    {
        id: "07A-090",
        format: "%15.2f",
        value: "150000"
    },
    {
        id: "07A-100",
        format: "%15.2f",
        value: "150000"
    },
    {
        id: "07A-110",
        format: "%15.2f",
        value: "150000"
    },
    {
        id: "07A-120",
        format: "%15.2f",
        value: "150000"
    }
    ]
  end



  def build_07b
    build_data(data_07b)
  end

  def data_07b
    [{
        id: "07B-010",
        format: "%-3s",
        value: "07B"
    },
    {
        id: "07B-020",
        format: "%-2s",
        value: "01"
    },
    {
        id: "07B-030",
        format: "%15.2f",
        value: "150000"
    }
    ]

  end

  def data_08a
    [{
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    },
        id: "08A-010",
        format: "%-3s",
        value: "07B"
    }]
  end



end
