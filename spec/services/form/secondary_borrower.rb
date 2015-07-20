require 'rails_helper'

describe Form::SecondaryBorrower do
  before :each do
    user = FactoryGirl.build(:user, email: 'test1@gmail.com', password: '12345678',
      password_confirmation: '12345678')
    user.skip_confirmation!
    user.save

    # create loan base on user
    loan = FactoryGirl.create(:loan_with_property, user: user)

    user = FactoryGirl.build(:user, email: 'test2@gmail.com', password: '12345678',
      password_confirmation: '12345678')
    user.skip_confirmation!
    user.save
  end

  it 'should return true if the email has been existed' do
    email = 'test1@gmail.com'
    current_user = User.where(email: 'test2@gmail.com').first

    expect(Form::SecondaryBorrower.check_existing_borrower(current_user, email)).to eq(true)
  end

  it 'should return false if the email has been existed but it is the same with the email of current user' do
    email = 'test1@gmail.com'
    current_user = User.where(email: email).first

    expect(Form::SecondaryBorrower.check_existing_borrower(current_user, email)).to eq(false)
  end

  it 'should return false if the email has not been existed' do
    email = '***@gmail.com'
    current_user = User.where(email: email).first

    expect(Form::SecondaryBorrower.check_existing_borrower(current_user, email)).to eq(false)
  end

end
