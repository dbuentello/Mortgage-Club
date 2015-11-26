namespace :db do
  task :clean_all_documents => :environment do
    Documents::FirstW2.destroy_all
    Documents::SecondW2.destroy_all
    Documents::FirstPaystub.destroy_all
    Documents::SecondPaystub.destroy_all
    Documents::FirstBankStatement.destroy_all
    Documents::SecondBankStatement.destroy_all
    Documents::FirstBusinessTaxReturn.destroy_all
    Documents::SecondBusinessTaxReturn.destroy_all
    Documents::FirstPersonalTaxReturn.destroy_all
    Documents::SecondPersonalTaxReturn.destroy_all
    Documents::FirstFederalTaxReturn.destroy_all
    Documents::SecondFederalTaxReturn.destroy_all
  end

  namespace :migrate do
    task :all do
      system("rake db:migrate RAILS_ENV=development")
      system("rake db:migrate RAILS_ENV=test")
    end
  end

  namespace :rollback do
    task :all do
      system("rake db:rollback RAILS_ENV=development")
      system("rake db:rollback RAILS_ENV=test")
    end
  end

  namespace :test do
    task :reset do
      system("rake db:drop RAILS_ENV=test")
      system("rake db:create RAILS_ENV=test")
      system("rake db:migrate RAILS_ENV=test")
    end
  end
end