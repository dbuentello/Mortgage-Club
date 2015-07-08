class AddNewFieldsToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :loan_type, :string
    add_column :loans, :prepayment_penalty, :boolean
    add_column :loans, :balloon_payment, :boolean

    add_column :loans, :monthly_payment, :decimal, :precision => 11, :scale => 2
    add_column :loans, :prepayment_penalty_amount, :decimal, :precision => 11, :scale => 2
    add_column :loans, :pmi, :decimal, :precision => 11, :scale => 2
  end
end
