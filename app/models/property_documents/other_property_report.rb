class OtherPropertyReport < PropertyDocument
  belongs_to :property, inverse_of: :other_property_report, foreign_key: 'property_id'
  belongs_to :owner, polymorphic: true
end
