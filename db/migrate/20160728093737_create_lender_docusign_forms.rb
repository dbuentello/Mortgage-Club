class CreateLenderDocusignForms < ActiveRecord::Migration
  def change
    create_table :lender_docusign_forms do |t|
      t.string :description
      t.string :sign_position
      t.references :lender, index: true, foreign_key: true, type: :uuid

      t.timestamps null: false
    end

    add_attachment :lender_docusign_forms, :attachment

  end
end
