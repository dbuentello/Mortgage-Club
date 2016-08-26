class AddActivityTypeToActivityName < ActiveRecord::Migration
  def change
    add_reference :activity_names, :activity_type, index: true, foreign_key: true, type: :uuid
  end
end
