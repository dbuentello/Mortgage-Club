# == Schema Information
#
# Table name: assets
#
#  id                   :uuid             not null, primary key
#  institution_name     :string
#  asset_type           :integer
#  current_balance      :decimal(11,2)
#

class Asset < ActiveRecord::Base
  belongs_to :borrower

  validates_presence_of :institution_name, :asset_type, :current_balance

  enum asset_type: [:checkings, :savings, :investment, :retirement, :other]

  PERMITTED_ATTRS = [
    :institution_name,
    :asset_type,
    :current_balance
  ]

  def self.bulk_update(borrower, asset_params)
    asset_params ||= []

    self.transaction do
      asset_ids = []
      asset_params.each do |asset_param|
        asset_id = asset_param[:id]

        if asset_id.nil? # New asset
          asset = borrower.assets.create!(asset_param)
          asset_id = asset.id
        else
          asset = borrower.assets.find(asset_id)
          asset.update!(asset_param)
        end

        asset_ids << asset_id
      end

      borrower.assets.where.not(id: asset_ids).destroy_all
    end
  end
end
