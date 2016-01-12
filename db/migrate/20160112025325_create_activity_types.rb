class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.text :type
      t.text :type_name_mapping, array: true, default: []

      t.timestamps null: false
    end
  end
end
