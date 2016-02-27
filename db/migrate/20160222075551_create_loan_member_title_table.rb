class CreateLoanMemberTitleTable < ActiveRecord::Migration
  def change
    create_table :loan_members_titles, id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
      t.string :title
      t.timestamps null: false
    end
  end
end
