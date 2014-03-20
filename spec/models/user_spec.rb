require 'spec_helper'

describe User do

  it { should belong_to(:plan) }
  it { should have_many(:credit_cards) }

  let!(:plan) { create(:plan, stripe_id: "free", name: "Free") }
  let(:user) {create(:user)}
  let!(:stripe_plan) { Stripe::Plan.create(amount: 0,
                                           interval: 'month',
                                           name: 'Free',
                                           currency: 'usd',
                                           id: 'free')}

  specify { expect(user.name).to eq(user.first_name + " " + user.last_name) }
  specify { expect(user.plan).to_not be_nil }

  it "#gravatar_url returns correct gravatar image url" do
    hash = Digest::MD5.hexdigest(user.email.downcase)
    expect(user.gravatar_url(16)).to eq "https://www.gravatar.com/avatar/#{hash}?s=16"
  end

  describe "validations" do
    context "email" do
      let!(:user) { create(:user) }
      let(:same_email_user) { build(:user, email: user.email)}
      let(:user_without_email) { build(:user, email: nil)}

      it "uniqueness" do
        expect(same_email_user).to_not be_valid
      end

      it "is required field" do
        expect(user_without_email).to_not be_valid
      end
    end

    context "email validation scope" do
      let!(:user) { create(:user) }
      let(:same_email_user) { build(:user, email: user.email)}

      before do
        user.destroy
      end

      it "does not scope deleted users" do
        expect(same_email_user).to be_valid
      end
    end
  end

  context "projects" do

    let(:project) { create(:project) }
    let(:user) { create(:user) }
    let!(:project_user) { create(:project_user, user: user, project: project, rights: "owner")}

    specify { expect(user.projects).to eq [project] }
    specify { expect(user.owned_projects).to eq [project] }

  end

  describe "credit cards" do

    let(:stripe_card_token)    { StripeMock.generate_card_token(last4: "4242",
                                                                exp_month: Time.now.month,
                                                                exp_year: (Time.now+1.year).year,
                                                                name: "Donald Duck",
                                                                type: "Visa") }
    let!(:credit_card1) { user.credit_cards.create(stripe_token: stripe_card_token) }
    let!(:credit_card2) { user.credit_cards.create(stripe_token: stripe_card_token) }

    specify { expect(user.credit_cards.default).to eq(credit_card2) }
    specify { expect(user.credit_cards.non_default).to eq([credit_card1]) }

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
      InvitationMailer.expects(:send_project_invitation_new_user).with(invited_user.id, user.id, project.id).returns(mailer)
      invited_user.send_project_invitation_new_user(user.id, project.id)
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
    let(:user) { create(:user, plan: plan) }

    context "with available minutes" do
      let!(:testing_allowance) { create(:testing_allowance, timeable: user) }

      it "#has_minutes_available? returns true" do
        expect(user.has_minutes_available?).to eq true
      end

      it "#used_minutes" do
        expect(user.used_minutes).to eq 0
      end

      it "#available_minutes" do
        expect(user.available_minutes).to eq (plan.minutes_available - user.used_minutes)
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

  end

  describe '#create_demo_project' do

    let!(:demo_project) { create(:project, name: "Demo Project", url: "http://test.io") }
    let!(:user) { create(:user) }

    subject { user.projects.first }

    specify { expect(subject.name).to eq(demo_project.name) }

  end
end
