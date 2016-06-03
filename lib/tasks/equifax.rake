namespace :equifax do
  task get_output: :environment do
    inputs = [
      {
        first_name: "BILL",
        last_name: "RBPTMORTGAGE",
        ssn: "333333628",
        street_address: "4650 N 75th",
        city: "Milwaukee",
        state: "WI",
        zipcode: "53218"
      },
      {
        first_name: "BILLTWO",
        last_name: "RBPTMORTGAGE",
        ssn: "333333617",
        street_address: "304 Argonne",
        city: "Birmingham",
        state: "AL",
        zipcode: "35215"
      },
      {
        first_name: "BILLTHREE",
        last_name: "RBPTMORTGAGE",
        ssn: "333333618",
        street_address: "304 Argonne",
        city: "Birmingham",
        state: "AL",
        zipcode: "35215"
      },
      {
        first_name: "NEIL",
        last_name: "RBPTMORTGAGE",
        ssn: "727000001",
        street_address: "4650 N 75th St",
        city: "Milwaukee",
        state: "WI",
        zipcode: "53218"
      },
      {
        first_name: "BILLABC",
        last_name: "RBPTMORTGAGE",
        ssn: "727000002",
        street_address: "304 Argonne",
        city: "Birmingham",
        state: "AL",
        zipcode: "35215"
      },
      {
        first_name: "BILLXYZ",
        last_name: "RBPTMORTGAGE",
        ssn: "727000003",
        street_address: "304 Argonne",
        city: "Birmingham",
        state: "AL",
        zipcode: "35215"
      },
      {
        first_name: "DALE",
        last_name: "RBPTMORTGAGE",
        ssn: "727000004",
        street_address: "4650 N 75th",
        city: "Milwaukee",
        state: "WI",
        zipcode: "53218"
      },
      {
        first_name: "",
        last_name: "RBPTMORTGAGE",
        ssn: "727000005",
        street_address: "304 Argonne",
        city: "Birmingham",
        state: "AL",
        zipcode: "35215"
      },
      {
        first_name: "BILLUCB",
        last_name: "RBPTMORTGAGE",
        ssn: "727000006",
        street_address: "304 Argonne",
        city: "Birmingham",
        state: "AL",
        zipcode: "35215"
      },
      {
        first_name: "DIAL",
        last_name: "RBPTMORTGAGE",
        ssn: "727000007",
        street_address: "4650 N 75th",
        city: "Milwaukee",
        state: "WI",
        zipcode: "53218"
      },
      {
        first_name: "ALADEEN",
        last_name: "RBPTMORTGAGE",
        ssn: "727000008",
        street_address: "304 Argonne",
        city: "Birmingham",
        state: "AL",
        zipcode: "35215"
      },
      {
        first_name: "JASMINE",
        last_name: "RBPTMORTGAGE",
        ssn: "727000009",
        street_address: "304 Argonne",
        city: "Birmingham",
        state: "AL",
        zipcode: "35215"
      },
      {
        first_name: "POLOA",
        last_name: "LOAN",
        ssn: "727000010",
        street_address: "5708 Annanadale LN",
        city: "Birmingham",
        state: "AL",
        zipcode: "35215"
      },
      {
        first_name: "POLOB",
        last_name: "LOAN",
        ssn: "727000011",
        street_address: "5708 Annanadale LN",
        city: "Birmingham",
        state: "AL",
        zipcode: "35215"
      },
      {
        first_name: "POLOC",
        last_name: "RBPTMORTGAGE",
        ssn: "727000012",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLOD",
        last_name: "RBPTMORTGAGE",
        ssn: "727000013",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLOE",
        last_name: "RBPTMORTGAGE",
        ssn: "727000014",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLOF",
        last_name: "RBPTMORTGAGE",
        ssn: "727000015",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLOG",
        last_name: "RBPTMORTGAGE",
        ssn: "727000016",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLOH",
        last_name: "RBPTMORTGAGE",
        ssn: "727000017",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLOI",
        last_name: "RBPTMORTGAGE",
        ssn: "727000018",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLOJ",
        last_name: "RBPTMORTGAGE",
        ssn: "727000019",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLOK",
        last_name: "RBPTMORTGAGE",
        ssn: "727000020",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLOL",
        last_name: "RBPTMORTGAGE",
        ssn: "727000021",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLOM",
        last_name: "RBPTMORTGAGE",
        ssn: "727000022",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLON",
        last_name: "RBPTMORTGAGE",
        ssn: "727000023",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLOP",
        last_name: "RBPTMORTGAGE",
        ssn: "727000024",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "POLOQ",
        last_name: "RBPTMORTGAGE",
        ssn: "727000025",
        street_address: "5708 Annanadale LN",
        city: "Irondale",
        state: "AL",
        zipcode: "35210"
      },
      {
        first_name: "WAYNE",
        last_name: "CCORALTREE",
        ssn: "517921852",
        street_address: "123 Main St",
        city: "Atlanta",
        state: "Ga",
        zipcode: "30318"
      },
      {
        first_name: "PITT",
        last_name: "ROCK JR",
        ssn: "666006666",
        street_address: "208 ELM ST",
        city: "Decatur",
        state: "Ga",
        zipcode: "30283"
      },
      {
        first_name: "BRIGHAM",
        last_name: "CARMILLA",
        ssn: "899659351",
        street_address: "123 Main St",
        city: "Atlanta",
        state: "Ga",
        zipcode: "30318"
      },
    ]

    inputs.each.with_index(1) do |input, index|
      response = CreditReportServices::GetReport.new(
        borrower_id: index,
        first_name: input[:first_name],
        last_name: input[:last_name],
        ssn: input[:ssn],
        street_address: input[:street_address],
        city: input[:city],
        state: input[:state],
        zipcode: input[:zipcode]
      ).call

      file = File.new("equifax_result/#{input[:first_name]}_#{input[:last_name]}_#{input[:street_address]}.xml", "wb")
      file.write(response)
      file.close
      p "#{index} DONE: #{input[:first_name]}_#{input[:last_name]}.xml"
    end
  end
end
