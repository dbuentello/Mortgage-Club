namespace :hotfix do
  task :test => :environment do
    ZillowService::GetMortgageRate.delay.call(Loan.last.property.address.zip)
  end
end