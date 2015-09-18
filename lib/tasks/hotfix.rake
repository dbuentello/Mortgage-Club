namespace :hotfix do
  task :test => :environment do
    RateServices::GetLenderRates.call(Loan.last.property.address.zip)
  end
end