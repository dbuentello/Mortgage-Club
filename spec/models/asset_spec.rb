require 'rails_helper'

describe Asset, type: :model do
  describe '#bulk_update' do
    let(:borrower) { FactoryGirl.create :borrower }
    let(:asset_params) {
      [{
         institution_name: Faker::Name.name,
         asset_type: :checkings,
         current_balance: 18.84},
       {
         institution_name: Faker::Name.name,
         asset_type: :savings,
         current_balance: 11.35}]
    }

    context 'with new assets only' do
      it 'should add new assets' do
        Asset.bulk_update(borrower, asset_params)
        expect(borrower.assets.count).to eq(2)
      end
    end

    context 'with removed assets' do
      it 'should remove assets' do
        Asset.bulk_update(borrower, asset_params)
        asset_params.delete_at(0)
        Asset.bulk_update(borrower, asset_params)

        expect(borrower.assets.count).to eq(1)
      end
    end
  end
end
