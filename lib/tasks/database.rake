namespace :database do

  task :clean_all_documents => :environment do
    Documents::FirstW2.destroy_all
    Documents::SecondW2.destroy_all
    Documents::FirstPaystub.destroy_all
    Documents::SecondPaystub.destroy_all
    Documents::FirstBankStatement.destroy_all
    Documents::SecondBankStatement.destroy_all
  end

end