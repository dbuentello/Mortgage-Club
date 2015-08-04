# see this for reference: https://en.wikipedia.org/wiki/Internet_media_type#List_of_common_media_types
ALLOWED_MIME_TYPES = [
  'image/jpg',
  'image/jpeg',
  'image/pjpeg',
  'image/gif',
  'image/png',
  'image/x-png',
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

if Rails.env.test?
  PAPERCLIP = {
    default_path: ":rails_root/public/uploads/:class/:token/:filename",
    default_url: "/uploads/:class/:token/:filename"
  }
else
  PAPERCLIP = {
    default_path: ':class/:token/:filename'
  }
end
