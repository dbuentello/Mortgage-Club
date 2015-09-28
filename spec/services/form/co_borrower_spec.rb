require 'rails_helper'

describe Form::CoBorrower do
  before :all do
    user = FactoryGirl.build(:borrower_user, email: 'test1@gmail.com', password: '12345678',
      password_confirmation: '12345678')
    user.skip_confirmation!
    user.save

    # create loan base on user
    loan = FactoryGirl.create(:loan_with_properties, user: user)

    user = FactoryGirl.build(:borrower_user, email: 'test2@gmail.com', password: '12345678',
      password_confirmation: '12345678')
    user.skip_confirmation!
    user.save
  end

  it 'returns true if the email has been existed' do
    email = 'test1@gmail.com'
    current_user = User.where(email: 'test2@gmail.com').first

    expect(Form::CoBorrower.check_existing_borrower(current_user, email)).to eq(true)
  end

  it 'returns false if the email has been existed but it is the same with the email of current user' do
    email = 'test1@gmail.com'
    current_user = User.where(email: email).first

    expect(Form::CoBorrower.check_existing_borrower(current_user, email)).to eq(false)
  end

  it 'returns false if the email has not been existed' do
    email = '***@gmail.com'
    current_user = User.where(email: email).first

    expect(Form::CoBorrower.check_existing_borrower(current_user, email)).to eq(false)
  end

  after :all do
    User.destroy_all
  end

end
