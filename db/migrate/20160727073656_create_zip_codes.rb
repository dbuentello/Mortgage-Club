class CreateZipCodes < ActiveRecord::Migration
  def change
    create_table :zip_codes, id: :uuid do |t|
      t.string :zip
      t.string :city

      t.timestamps null: false
    end
  end
end
