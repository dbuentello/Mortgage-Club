require 'rails_helper'

describe Rate do
  context "convert_text_to_boolean" do
    it "should convert correctly" do
      expect(Rate.convert_text_to_boolean('False')).to eq(false)
      expect(Rate.convert_text_to_boolean('True')).to eq(true)
    end
  end

end