class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists, id: :uuid do |t|
      t.string :name
      t.text :description
      t.text :question
      t.text :answer
      t.datetime :due_date
      t.string :status, default: 'pending'
      t.string :type
      t.string :document_type
      t.uuid :template_id
      t.references :user, index: true, foreign_key: true, type: :uuid
      t.references :loan, index: true, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
