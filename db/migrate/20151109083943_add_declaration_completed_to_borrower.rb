class AddDeclarationCompletedToBorrower < ActiveRecord::Migration
  def change
    add_column :borrowers, :declaration_completed, :boolean, default: false
  end
end
