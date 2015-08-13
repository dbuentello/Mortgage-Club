class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members, id: :uuid do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :middle_name
      t.string  :phone_number
      t.string  :skype_handle
      t.string  :email
      t.uuid    :user_id
      t.integer :employee_id
      t.integer :nmls_id
      t.timestamps null: false
    end

    add_index(:team_members, :user_id)
  end
end
