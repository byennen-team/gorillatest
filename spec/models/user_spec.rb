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

  context "#projects" do
    let(:project) { create(:project) }
    let(:user) { create(:user) }
    let!(:project_user) { create(:project_user, user: user, project: project, rights: "owner")}

    it "should return projects that user belongs to" do
      expect(user.projects).to eq [project]
    end
  end
end
