class CreateOcr < ActiveRecord::Migration
  def change
    create_table :ocrs do |t|
      t.string :borrower_id
      t.text :employer_name_1
      t.text :employer_name_2
      t.text :address_first_line_1
      t.text :address_first_line_2
      t.text :address_second_line_1
      t.text :address_second_line_2
      t.datetime :period_beginning_1
      t.datetime :period_beginning_2
      t.datetime :period_ending_1
      t.datetime :period_ending_2
      t.decimal :current_salary_1, :precision => 11, :scale => 2
      t.decimal :current_salary_2, :precision => 11, :scale => 2
      t.decimal :ytd_salary_1, :precision => 11, :scale => 2
      t.decimal :ytd_salary_2, :precision => 11, :scale => 2
      t.decimal :current_earnings_1, :precision => 11, :scale => 2
      t.decimal :current_earnings_2, :precision => 11, :scale => 2
    end
  end
end
