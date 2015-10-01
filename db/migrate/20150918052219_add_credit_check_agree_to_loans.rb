class AddCreditCheckAgreeToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :credit_check_agree, :boolean, default: false
  end
end
