# Require asposecloudsdk
require 'asposecloud'

class AsposeOcr
  def self.get_recognized_text
    app_sid = ENV['ASPOSE_APP_SID']
    app_key = ENV['ASPOSE_APP_KEY']

    Aspose::Cloud::Common::AsposeApp.app_key = app_key
    Aspose::Cloud::Common::AsposeApp.app_sid = app_sid
    Aspose::Cloud::Common::AsposeApp.output_location = '/Users/hoangle'
    Aspose::Cloud::Common::Product.set_base_product_uri('http://api.aspose.com/v1.1')

    # Upload file
    # file = "#{Rails.root}/vendor/files/Sample paycheck.pdf"
    # folder = Aspose::Cloud::AsposeStorage::Folder.new
    # folder.upload_file file

    # document = Aspose::Cloud::Pdf::Document.new("Sample paycheck.pdf")
    # result = document.get_document_properties()

    # text_editor = Aspose::Cloud::Pdf::TextEditor.new('Sample paycheck.pdf')
    # result = text_editor.get_text()

    document = Aspose::Cloud::Pdf::Document.new('Sample paycheck.pdf')
    result = document.get_form_fields()

    ap result
  end
end