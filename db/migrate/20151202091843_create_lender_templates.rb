class CreateLenderTemplates < ActiveRecord::Migration
  def change
    create_table :lender_templates, id: :uuid do |t|
      t.string :name
      t.string :description

      t.uuid :lender_id, index: true

      t.timestamps null: false
    end
  end
end
