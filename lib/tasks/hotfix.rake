namespace :hotfix do

  task :issue_99 => :environment do
    User.all.to_a.each do |user|
      if user.borrower.nil? && user.loan_member.present?
        user.add_role :loan_member
      else
        user.add_role :borrower
      end
    end
  end

end