class Documents::EnvelopeDoc < Document
  # NOTE: someday when more class has documents inside, we should use polymorphic approuch instead
  belongs_to :envelope, inverse_of: :documents, class_name: "Envelope", foreign_key: 'owner_id'

end
