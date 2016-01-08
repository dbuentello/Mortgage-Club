namespace :scheduler do
  desc "Crawl lowest rates for displaying at homepage"
  task crawl_rates_for_homepage: :environment do
    puts "Crawling rates"

    rates = MortgageRateServices::GetMortgageAprs.delay.call(true)

    puts "done."
  end

  task test: :environment do
    puts "#{Time.now}"
    Crawler::LendaRates.new({}).call
    puts "#{Time.now}"
  end

  task debug: :environment do
    loan = Loan.find("cd70d96b-3902-44dd-a840-9ef762aa96a2")
    borrower = User.where(email:"borrower@gmail.com").last.borrower
    RatesComparisonServices::Base.new(loan, loan.subject_property, borrower).call
  end
end
