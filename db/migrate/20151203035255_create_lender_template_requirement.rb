class CreateLenderTemplateRequirement < ActiveRecord::Migration
  def change
    create_table :lender_template_requirements, id: :uuid do |t|
      t.belongs_to :lender, index: true, type: :uuid
      t.belongs_to :lender_template, index: true, type: :uuid
      t.timestamps null: false
    end
  end
end
