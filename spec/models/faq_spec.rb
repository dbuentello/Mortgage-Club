require "rails_helper"

describe Faq do
  it "has a valid faq" do
    expect(FactoryGirl.build(:faq)).to be_valid
  end

  it "is invalid without question" do
    faq = Faq.new(answer: "<p>Answer</p>")
    faq.valid?
    expect(faq.errors[:question]).to include("can't be blank")
  end

  it "is invalid without answer" do
    faq = Faq.new(question: "Question")
    faq.valid?
    expect(faq.errors[:answer]).to include("can't be blank")
  end
end
