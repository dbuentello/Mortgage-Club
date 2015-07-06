class Documents::Envelope < Document
  belongs_to :envelope, inverse_of: :documents

end
