class Ocr < ActiveRecord::Base
  belongs_to :borrower, foreign_key: 'borrower_id'

end