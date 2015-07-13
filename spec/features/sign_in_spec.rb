require 'rails_helper'

describe "the signin process", :type => :feature do
  before :each do
    user = FactoryGirl.create(:user, email: 'user@example.com', password: 'password', password_confirmation: 'password')
    user.skip_confirmation!
    user.save
  end

  it "signs me in" do
    visit '/auth/login'
    within("#new_user") do
      fill_in 'user[email]', :with => 'user@example.com'
      fill_in 'user[password]', :with => 'password'
    end
    click_button 'Log in'

    expect(current_path).to eq(new_loan_path)
  end
end