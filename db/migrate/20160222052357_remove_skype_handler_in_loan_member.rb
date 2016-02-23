class RemoveSkypeHandlerInLoanMember < ActiveRecord::Migration
  def change
    remove_column :loan_members, :skype_handle
  end
end
