class AddTimestampsToNewTables < ActiveRecord::Migration
  def change
    add_timestamps :templates, null: false
    add_timestamps :envelopes, null: false
    add_timestamps :signers, null: false
  end
end
