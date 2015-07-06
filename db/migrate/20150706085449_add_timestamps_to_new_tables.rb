class AddTimestampsToNewTables < ActiveRecord::Migration
  def change
    add_timestamps :templates
    add_timestamps :envelopes
    add_timestamps :signers
  end
end
