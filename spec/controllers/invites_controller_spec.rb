require "rails_helper"

describe Users::InvitesController do
  include_context "signed in as borrower user of loan"

  let(:invite) { FactoryGirl.create(:invite) }
  let(:user) { FactoryGirl.create(:user) }

  describe "POST #create invite" do
    describe 'with valid attributes' do
      it '3 invites' do
        expect { post :create, invite: {email: ["abc@gmail.com", "def@gmail.com", "123@gmail.com"], name: ["", "", ""], phone: ["", "", ""]}, format: :json }.to change{Invite.count}.by(3)
      end

      it '2 invites' do
        expect { post :create, invite: {email: ["abc@gmail.com", "def@gmail.com"], name: ["", ""], phone: ["", ""]}, format: :json }.to change{Invite.count}.by(2)
      end

      it '1 invite' do
        expect { post :create, invite: {email: ["abc@gmail.com"], name: [""], phone: [""]}, format: :json }.to change{Invite.count}.by(1)
      end

      it "response success" do
        post :create, invite: {email: ["abc@gmail.com"], name: [""], phone: [""]}, format: :json
        expect(response.status).to eq(200)
        expect(response.body).not_to eq("{\"success\":false,\"message\":\"Error, the email is already invited or not valid!\"}")
      end
    end

    context "with invalid attributes" do
      it '1 invite' do
        expect { post :create, invite: {email: ["abc"], name: ["a"], phone: ["b"]}, format: :json }.to change{Invite.count}.by(0)
      end

      it '2 invites' do
        expect { post :create, invite: {email: ["abc@gmail.com", "def"], name: ["", ""], phone: ["", ""]}, format: :json }.to change{Invite.count}.by(1)
      end

      it 'response failure' do
        post :create, invite: {email: ["abc"], name: [""], phone: [""]}, format: :json
        expect(response.status).to eq(200)
        expect(response.body).to eq("{\"success\":false,\"message\":\"Error, the email is already invited or not valid!\"}")
      end

      it 'already invited' do
        invite = Invite.create(email: "abc@gmail.com", name: [""], phone: [""])
        post :create, invite: {email: ["abc@gmail.com"], name: [""], phone: [""]}, format: :json
        expect(response.status).to eq(200)
        expect(response.body).to eq("{\"success\":false,\"message\":\"Error, the email is already invited or not valid!\"}")
      end

      it 'user exists' do
        user = User.new(
          email: 'abc@gmail.com', first_name: 'AB', last_name: 'C',
          password: '12345678', password_confirmation: '12345678'
        )
        user.skip_confirmation!
        user.save
        post :create, invite: {email: ["abc@gmail.com"], name: [""], phone: [""]}, format: :json
        expect(response.status).to eq(200)
        expect(response.body).to eq("{\"success\":false,\"message\":\"Error, the email is already invited or not valid!\"}")
      end
    end
  end
end
