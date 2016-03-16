require 'rails_helper'

describe Liability, type: :model do
  context 'with invalid asset params' do
    describe 'Money amount fields exceed maximum allowed value will raise error' do
      let(:liability1) { FactoryGirl.build(:liability, balance: 321456789123) }
      let(:liability2) { FactoryGirl.build(:liability, payment: 123456789123) }

      it 'raise StatementInvalid Error' do
        expect { raise liability1.save }.to raise_error(ActiveRecord::StatementInvalid)
        expect { raise liability2.save }.to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end
end
