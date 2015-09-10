class ChangeTypeOfIncludeOtherText < ActiveRecord::Migration
  def change
    change_column :loans, :include_other_text, :text
  end
end
