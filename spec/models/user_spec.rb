require 'spec_helper'

describe User do

  it { should belong_to(:plan) }
  it { should have_one(:credit_card) }

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

  describe "testing allowance" do
    let(:free_plan) { create(:plan) }
    let(:user) { create(:user, plan: free_plan) }

    context "with available minutes" do
      let!(:testing_allowance) { create(:testing_allowance, timeable: user) }

      it "#has_minutes_available? returns true" do
        expect(user.has_minutes_available?).to eq true
      end

      it "#used_minutes" do
        expect(user.used_minutes).to eq 0
      end

      it "#available_minutes" do
        expect(user.available_minutes).to eq (free_plan.minutes_available - user.used_minutes)
      end
    end

    context "without available minutes" do
      let!(:testing_allowance) { create(:testing_allowance, seconds_used: 3600, timeable: user)}

      it "#has_minutes_available? returns false" do
        expect(user.has_minutes_available?).to eq false
      end

      it "#used_minutes" do
        expect(user.used_minutes).to eq 60
      end

      it "#available_minutes" do
        expect(user.available_minutes).to eq 0
      end
    end

    describe 'creating stripe customer' do

      let(:user) { create(:user) }
      let(:stripe_customer_token) {"12344555"}
      let(:customer) {stub('customer', {description: "#{user.first_name} #{user.last_name}",
                                                                        email: user.email,
                                                                        id: stripe_customer_token})}
      context 'without being a current stripe customer' do
        before do
          Stripe::Customer.expects(:create).with(email: user.email, description: "#{user.first_name} #{user.last_name}").returns(customer)
        end

        it "should create and return stripe user" do
          stripe_customer = user.create_or_retrieve_stripe_customer
          stripe_customer.should == customer
          user.reload.stripe_customer_token.should_not be_nil
        end

      end

      context 'with being a current stripe customer' do
        before do
          user.update_attribute(:stripe_customer_token, stripe_customer_token)
          Stripe::Customer.expects(:retrieve).with(stripe_customer_token).returns(customer)
        end

        it "should return stripe user" do
          stripe_customer = user.create_or_retrieve_stripe_customer
          stripe_customer.should == customer
        end
      end

    end

  end

end
