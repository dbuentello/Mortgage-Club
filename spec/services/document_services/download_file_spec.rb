require 'rails_helper'

describe DocumentServices::DownloadFile do
  before(:each) do
    @closing_disclosure = FactoryGirl.create(:closing_disclosure)
  end

  it 'returns an url returned by the Amazon service' do
    allow(Amazon::GetUrlService).to receive(:call).and_return('https://dev-homieo.s3-us-west-2.amazonaws.com/second_w2s/b87b3e25d8f3')
    url = DocumentServices::DownloadFile.call('ClosingDisclosure', @closing_disclosure.id)
    expect(url).not_to be_nil
  end

  context 'invalid params' do
    it 'raises RecordNotFound if document does not exist' do
      expect { raise DocumentServices::DownloadFile.call('ClosingDisclosure', 'non-existent-id') }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises NameError if document class name is invalid' do
      expect { raise DocumentServices::DownloadFile.call('FakeClass', @closing_disclosure.id) }.to raise_error(NameError)
    end
  end
end
