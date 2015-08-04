class CreateLoansMembers < ActiveRecord::Migration
  def change
    create_table :loans_members do |t|
      t.integer :loan_id
      t.integer :team_member_id
    end

    add_index(:loans_members, :loan_id)
    add_index(:loans_members, :team_member_id)
  end
end
