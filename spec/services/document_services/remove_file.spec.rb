require 'rails_helper'

describe DocumentServices::RemoveFile do
  let(:closing_disclosure) { FactoryGirl.create(:closing_disclosure) }

  it 'destroys an attachment successfully' do
    DocumentServices::RemoveFile.call('ClosingDisclosure', closing_disclosure.id)
    expect(ClosingDisclosure.count).to eq(0)
  end

  it 'returns true after completing service' do
    expect(DocumentServices::RemoveFile.call('ClosingDisclosure', closing_disclosure.id)).to be true
  end

  context 'invalid params' do
    it 'raises RecordNotFound if document does not exist' do
      expect { raise DocumentServices::RemoveFile.call('ClosingDisclosure', 'non-existent-id') }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises NameError if document class name is invalid' do
      expect { raise DocumentServices::RemoveFile.call('FakeClass', closing_disclosure.id) }.to raise_error(NameError)
    end
  end
end
