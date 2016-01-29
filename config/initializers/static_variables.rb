# see this for reference: https://en.wikipedia.org/wiki/Internet_media_type#List_of_common_media_types
IMAGE_MINE_TYPES = [
  'image/jpg',
  'image/jpeg',
  'image/pjpeg',
  'image/gif',
  'image/png',
  'image/x-png',
  'image/tiff',
  'image/x-tiff',
  'image/vnd.adobe.photoshop'
]

PDF_MINE_TYPES = [
  'application/pdf'
]

MWORD_MINE_TYPES = [
  'application/msword',
  'application/vnd.ms-office',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
]

EXCEL_MINE_TYPES = [
  'application/excel',
  'application/vnd.ms-excel',
  'application/x-excel',
  'application/x-msexcel',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
]

POWERPOINT_MINE_TYPES = [
  'application/mspowerpoint',
  'application/powerpoint',
  'application/vnd.ms-powerpoint',
  'application/x-mspowerpoint',
  'application/vnd.openxmlformats-officedocument.presentationml.presentation'
]

OTHER_MINE_TYPES = [
  'application/octet-stream',
  'application/x-photoshop',
  'application/rtf',
  'application/x-rtf',
  'application/zip', # file --mime-type spec/files/sample.xlsx => spec/files/sample.xlsx: application/zip
  'text/richtext',
  'text/rtf',
  'text/plain',
  'inode/x-empty'
]

ZILLOW_PROPERTY_TYPE_MAPPING = {
  'SingleFamily' => 'Single Family Home',
  'Duplex' => 'Duplex',
  'Triplex' => 'Triplex',
  'Quadruplex' => 'Fourplex',
  'Condominium' => 'Condo'
}

ALLOWED_MIME_TYPES = IMAGE_MINE_TYPES + PDF_MINE_TYPES + MWORD_MINE_TYPES +
                     EXCEL_MINE_TYPES + POWERPOINT_MINE_TYPES + OTHER_MINE_TYPES

if Rails.env.test?
  PAPERCLIP = {
    default_path: ":rails_root/public/uploads/:class/:token/:filename",
    potential_user_document_path: ":rails_root/public/uploads/:class/:id/:filename"
  }
else
  PAPERCLIP = {
    default_path: ':class/:token/:filename',
    potential_user_document_path: ':class/:id/:filename'
  }
end
