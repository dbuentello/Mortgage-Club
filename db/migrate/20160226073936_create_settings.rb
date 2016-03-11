class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :ocr

      t.timestamps null: false
    end
  end
end
