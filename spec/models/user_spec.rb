require 'spec_helper'

describe User do

  let(:user) {create(:user)}

  it "#name returns user's full name" do
    user.name.should eq user.first_name + " " + user.last_name
  end

  it "#gravatar_url returns correct gravatar image url" do
    hash = Digest::MD5.hexdigest(user.email.downcase)
    expect(user.gravatar_url(16)).to eq "https://www.gravatar.com/avatar/#{hash}?s=16"
  end

  context "projects" do
    let(:project) { create(:project) }
    let(:user) { create(:user) }
    let!(:project_user) { create(:project_user, user: user, project: project, rights: "owner")}

    it "#projects returns projects that user belongs to" do
      expect(user.projects).to eq [project]
    end

    it "#owned_projects returns projects where user is owner" do
      expect(user.owned_projects).to eq [project]
    end
  end

  context "invitations" do
    let(:invited_user) { create(:user) }
    let(:mailer) { stub(:deliver) }
    let(:project) { create(:project) }

    it "sends invitation" do
      InvitationMailer.expects(:send_invitation).with(invited_user.id, user.id).returns(mailer)
      invited_user.send_invitation(user.id)
    end

    it "sends project invitation" do
      InvitationMailer.expects(:send_project_invitation).with(invited_user.id, user.id, project.id).returns(mailer)
      invited_user.send_project_invitation(user.id, project.id)
    end
  end

  describe "omniauth" do
    let(:unsaved_user) { build(:user) }
    let(:auth_data) do
      OmniAuth::AuthHash.new({
        provider: 'google',
        uid: '123456',
        info: {
          first_name: unsaved_user.first_name,
          last_name: unsaved_user.last_name,
          email: unsaved_user.email
        }
      })
    end
    context "new user" do
      let(:user) { User.from_omniauth(auth_data) }

      it "returns a new record" do
        expect(user.new_record?).to be_true
      end

      it "returns correct first_name" do
        expect(user.first_name).to eq unsaved_user.first_name
      end

      it "returns correct last_name" do
        expect(user.last_name).to eq unsaved_user.last_name
      end

      it "assigns correct provider" do
        expect(user.provider).to eq "google"
      end

      it "assigns auth uid" do
        expect(user.uid).to eq "123456"
      end
    end

    context "existing user" do
      let!(:existing_user) { create(:user, email: unsaved_user.email)}
      let(:authenticated_user) { User.from_omniauth(auth_data) }

      it "returns an existing user" do
        expect(authenticated_user.new_record?).to be_false
      end

      it "assigns correct provider" do
        expect(authenticated_user.provider).to eq "google"
      end

      it "assigns auth uid" do
        expect(authenticated_user.uid).to eq "123456"
      end
    end

    context "set password" do
      before do
        @user = User.from_omniauth(auth_data)
        @user.company_name = "Company"
        @user.save
      end

      it "sets password for omniauth authenticated user after create" do
        expect(@user.encrypted_password).to_not be_blank
      end
    end
  end

end
