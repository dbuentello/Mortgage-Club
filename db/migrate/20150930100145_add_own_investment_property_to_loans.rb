class AddOwnInvestmentPropertyToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :own_investment_property, :boolean, default: false
  end
end
