require 'rails_helper'

describe Asset, type: :model do
  context 'with invalid asset params' do
    describe 'Money amount fields exceed maximum allowed value will raise error' do
      let(:asset) { FactoryGirl.build(:asset, current_balance: 123123123123)}

      it 'raise StatementInvalid Error' do
        expect { raise asset.save }.to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end

  describe '#bulk_update' do
    let(:borrower) { FactoryGirl.create :borrower }
    let(:asset_params) do
      [
        {
          institution_name: Faker::Name.name,
          asset_type: :checkings,
          current_balance: 18.84
        },
        {
          institution_name: Faker::Name.name,
          asset_type: :savings,
          current_balance: 11.35
        }
      ]
    end

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
