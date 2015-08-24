require 'rails_helper'

describe DocumentServices::UploadFile do
  let(:closing) { FactoryGirl.create(:closing) }
  let(:user) { FactoryGirl.create(:user) }

  context "valid params" do
    let(:service) do
      DocumentServices::UploadFile.new(
        {
          subject_class_name: 'Closing',
          document_klass_name: 'ClosingDisclosure',
          foreign_key_name: 'closing_id',
          foreign_key_id: closing.id,
          current_user: user,
          params: {
            file: File.new(Rails.root.join 'spec', 'files', 'sample.pdf'),
            description: "Closing Disclosure"
          }
        }
      )
    end

    it 'returns true after completing service' do
      expect(service.call).to be true
    end

    describe "uploads a new document" do
      before(:each) { service.call }

      it 'creates a new document record' do
        expect(ClosingDisclosure.count).to eq(1)
      end

      it 'uploads a document successfully' do
        expect(PDF_MINE_TYPES).to include(ClosingDisclosure.last.attachment_content_type)
        expect(ClosingDisclosure.last.description).not_to be_nil
      end
    end

    describe "updates an existing document" do
      before(:each) do
        @closing_disclosure = FactoryGirl.create(
          :closing_disclosure,
          attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'),
          closing: closing
        )
        service.call
      end

      it 'updates an attachment' do
        @closing_disclosure.reload
        expect(MWORD_MINE_TYPES).not_to include(@closing_disclosure.attachment_content_type)
        expect(PDF_MINE_TYPES).to include(@closing_disclosure.attachment_content_type)
      end
    end
  end

  context "invalid params" do
    before(:each) do
      @args = {
        subject_class_name: 'Closing',
        document_klass_name: 'ClosingDisclosure',
        foreign_key_name: 'closing_id',
        foreign_key_id: closing.id,
        current_user: user,
        params: {
          file: File.new(Rails.root.join 'spec', 'files', 'sample.pdf'),
          description: "Closing Disclosure"
        }
      }
    end

    it 'raises RecordNotFound if subject does not exist' do
      @args[:foreign_key_id] = 'non-existent-id'
      expect { raise DocumentServices::UploadFile.new(@args).call }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises NameError if document class name is invalid' do
      @args[:document_klass_name] = 'FakeClass'
      expect { raise DocumentServices::UploadFile.new(@args).call }.to raise_error(NameError)
    end

    it 'raises StatementInvalid if foreign key name is invalid' do
      @args[:foreign_key_name] = 'fake-foreign-key-name'
      expect { raise DocumentServices::UploadFile.new(@args).call }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end
end
