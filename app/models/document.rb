class Document < ActiveRecord::Base
  
  ALLOWED_MIME_TYPES = [
   'image/jpg',
   'image/jpeg',
   'image/pjpeg',
   'image/gif',
   'image/png',
   'image/x-png',
   'image/tiff',
   'image/x-tiff',
   'image/tiff',
   'image/x-tiff',
   'image/vnd.adobe.photoshop',
   'application/pdf',
   'application/octet-stream',
   'application/x-photoshop',
   'application/msword',
   'application/vnd.ms-office',
   'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
   'application/excel',
   'application/vnd.ms-excel',
   'application/x-excel',
   'application/x-msexcel',
   'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
   'application/mspowerpoint',
   'application/powerpoint',
   'application/vnd.ms-powerpoint',
   'application/x-mspowerpoint',
   'application/vnd.openxmlformats-officedocument.presentationml.presentation',
   'application/rtf',
   'application/x-rtf',
   'application/zip', # file --mime-type spec/files/sample.xlsx => spec/files/sample.xlsx: application/zip
   'text/richtext',
   'text/rtf',
   'text/plain',
   'inode/x-empty'
 ]

 belongs_to :borrower, foreign_key: 'borrower_id'

 has_attached_file    :attachment
 validates_attachment :attachment,
                      presence: true,
                      content_type: {
                        content_type: Document::ALLOWED_MIME_TYPES,
                        message: ' allows MS Excel, MS Documents, MS Powerpoint, Rich Text, Text File and Images'
                      },
                      size: { less_than_or_equal_to: 50.megabytes, message: ' must be less than or equal to 50MB' }

 PERMITTED_ATTRS = [
   :type,
   :attachment
 ]
end
