class AddReferenceToLiability < ActiveRecord::Migration
  def change
    add_reference :liabilities, :property, index: true, foreign_key: true, type: :uuid
  end
end
