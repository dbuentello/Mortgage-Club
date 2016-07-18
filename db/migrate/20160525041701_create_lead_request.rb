class CreateLeadRequest < ActiveRecord::Migration
  def change
    create_table :lead_requests, id: :uuid do |t|
      t.uuid   :loan_id
      t.uuid   :loan_member_id
      t.integer :status, default: 0
    end

    add_index :lead_requests, :loan_member_id
    add_index :lead_requests, :loan_id
  end
end
