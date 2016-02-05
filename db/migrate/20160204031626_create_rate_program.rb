class CreateRateProgram < ActiveRecord::Migration
  def change
    create_table :rate_programs, id: :uuid do |t|
      t.string :lender_name
      t.string :rate_value
      t.string :program
      t.timestamps null: false
    end
  end
end
