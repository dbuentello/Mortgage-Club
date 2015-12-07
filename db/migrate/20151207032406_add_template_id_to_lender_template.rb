class AddTemplateIdToLenderTemplate < ActiveRecord::Migration
  def change
    add_column :lender_templates, :template_id, :uuid
  end
end
