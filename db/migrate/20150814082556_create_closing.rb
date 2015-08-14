class CreateClosing < ActiveRecord::Migration
  def change
    create_table :closings, id: :uuid do |t|
      t.string :name
      t.references :loan, index: true, foreign_key: true, type: :uuid
    end
  end
end
