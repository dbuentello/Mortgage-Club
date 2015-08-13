class CreateTemplates < ActiveRecord::Migration
  def change
    enable_extension "hstore"

    create_table :templates, id: :uuid do |t|
      t.string :name
      t.string :state
      t.string :description
      t.string :email_subject
      t.string :email_body
      t.string :docusign_id
      t.uuid :creator_id
    end
  end
end
