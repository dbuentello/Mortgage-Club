require 'rails_helper'

describe Invite do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:invite)).to be_valid
  end

  it "raises an error with an invalid email" do
    expect do
      raise Invite.new(
        email: "abc"
      ).valid?
    end.to raise_error(TypeError)
  end

  it "is invalid without a loan member" do
    invite = Invite.new(name: "abc", phone: "0123456789")
    invite.valid?
    expect(invite.errors[:email]).to include("can't be blank")
  end
end
