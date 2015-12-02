# == Schema Information
#
# Table name: lenders
#
#  id                         :uuid             not null, primary key
#

class Lender < ActiveRecord::Base
  PERMITTED_ATTRS = [
    :name,
    :website,
    :rate_sheet,
    :lock_rate_email,
    :docs_email,
    :contact_email,
    :contact_name,
    :contact_phone
  ]
end
