class CreateLoansMembers < ActiveRecord::Migration
  def change
    create_table :loans_members, id: :uuid do |t|
      t.uuid :loan_id
      t.uuid :team_member_id
    end

    add_index(:loans_members, :loan_id)
    add_index(:loans_members, :team_member_id)
  end
end
