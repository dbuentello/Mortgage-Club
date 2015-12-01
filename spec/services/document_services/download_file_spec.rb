require 'rails_helper'

describe DocumentServices::DownloadFile do
  let!(:document) { FactoryGirl.create(:property_document) }

  it 'returns an url returned by the Amazon service' do
    allow(Amazon::GetUrlService).to receive(:call).and_return('https://dev-homieo.s3-us-west-2.amazonaws.com/second_w2s/b87b3e25d8f3')
    url = DocumentServices::DownloadFile.call(document.id)
    expect(url).not_to be_nil
  end

  context 'invalid params' do
    it 'raises RecordNotFound if document does not exist' do
      expect { raise DocumentServices::DownloadFile.call('non-existent-id') }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
