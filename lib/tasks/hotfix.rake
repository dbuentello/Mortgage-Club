namespace :hotfix do
  task :test => :environment do
    ZillowService::GetMortgageRate.call(Loan.last.property.address.zip)
  end
end