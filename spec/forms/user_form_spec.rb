require "rails_helper"


describe UserForm do
  before(:each) do
    @params = {
      user: {
        first_name: "Cuong",
        last_name: "Vu",
        middle_name: "Manh",
        suffix: "Mr",
        email: "cuong@gmail.com",
        password: "this-is-password",
        password_confirmation: "this-is-password"
      }
    }
    @form = UserForm.new(params: @params, skip_confirmation: true)
  end

  describe "#assign_value_to_attributes" do
    it "assigns value to user's attributes" do
      @form.assign_value_to_attributes

      expect(@form.user.first_name).to eq("Cuong")
      expect(@form.user.last_name).to eq("Vu")
      expect(@form.user.middle_name).to eq("Manh")
      expect(@form.user.suffix).to eq("Mr")
      expect(@form.user.email).to eq("cuong@gmail.com")
    end
  end

  describe "#do_not_send_confirmation" do
    context "skip confirmation" do
      before(:each) { @form.skip_confirmation = true }

      it "calls do_not_send_confirmation method" do
        expect(@form).to receive(:do_not_send_confirmation)
        @form.assign_value_to_attributes
      end

      it "does not send any email" do
        @form.assign_value_to_attributes

        expect(@form.user.confirmed_at).not_to be_nil
      end
    end

    context "confirmation" do
      it "sends confirmation email" do
        @form.skip_confirmation = false
        @form.assign_value_to_attributes

        expect(@form.user.confirmed_at).to be_nil
      end
    end
  end

  describe "#save" do
    it "calls assign_value_to_attributes method" do
      expect(@form).to receive(:assign_value_to_attributes)
      @form.save
    end

    context "valid params" do
      it "returns true" do
        expect(@form.save).to be_truthy
      end

      it "creates a new user successfully" do
        @form.save

        expect(@form.user.persisted?).to be_truthy
        expect(@form.user.first_name).to eq("Cuong")
        expect(@form.user.last_name).to eq("Vu")
        expect(@form.user.middle_name).to eq("Manh")
        expect(@form.user.suffix).to eq("Mr")
        expect(@form.user.email).to eq("cuong@gmail.com")
      end
    end

    context "invalid params" do
      before(:each) do
        @form.params[:user][:first_name] = nil
        @form.params[:user][:last_name] = nil
        @form.params[:user][:email] = "invalid-email@fake"
      end

      it "returns false" do
        expect(@form.save).to be_falsey
      end

      it "stores error's messages" do
        @form.save
        expect(@form.errors.full_messages).to eq(["Email is invalid", "Email is invalid", "First name can't be blank", "Last name can't be blank"])
      end
    end
  end
end