require 'rails_helper'

describe Liability, type: :model do
  context 'with invalid asset params' do
    describe 'Money amount fields exceed maximum allowed value will raise error' do
      let(:liability) { FactoryGirl.build(:liability, balance: 321456789123)}

      it 'raise StatementInvalid Error' do
        expect { raise liability.save }.to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end
end
