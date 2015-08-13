class CreateComments < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :comments, id: :uuid do |t|
      t.string :author
      t.text :text

      t.timestamps null: false
    end
  end
end
