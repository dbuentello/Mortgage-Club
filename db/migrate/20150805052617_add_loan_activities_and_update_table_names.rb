class AddLoanActivitiesAndUpdateTableNames < ActiveRecord::Migration
  def change
    rename_table :team_members, :loan_members
    rename_table :loans_members, :loans_members_associations

    create_table :loan_activities do |t|
      t.string :name
      t.integer :activity_type, default: 0, null: false
      t.integer :activity_status, default: 0, null: false
      t.boolean :user_visible, default: false, null: false

      t.integer :loan_id
      t.integer :loan_member_id
      t.timestamps
    end

    add_index :loan_activities, :loan_id
    add_index :loan_activities, :loan_member_id
  end
end
