class HomepageFaqType < ActiveRecord::Base
  has_many :homepage_faqs

  validates :name, presence: true
end
