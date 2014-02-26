require 'spec_helper'

describe Project do

  describe 'relations' do

    it { should have_many(:project_users) }
    it { should have_many(:features) }
    it { should belong_to(:user) }
    it { should have_many(:test_runs) }
    it { should validate_uniqueness_of(:name) }

  end

  describe "validations" do

    it { should validate_presence_of :name }

    context "with valid URL" do

      let(:project) { Project.new({name: "test", url: "http://autotest.io"}) }

      it "should be valid" do
        expect(project.valid?).to eq(true)
      end

    end

    context "with invalid URL" do

      let(:project) { Project.new({name: "test", url: "autoo"}) }

      it "should not be valid" do
        expect(project.valid?).to eq(false)
      end

    end

  end

  describe "before_create" do

    let(:project) { Project.create({name: "test", url: "http://autotest.io"}) }

    it "should have an api key" do
      expect(project.api_key.blank?).to eq(false)
    end

  end

  context "slug id" do
    let(:project) { create(:project, name: "Factor 75 Autotest") }

    it "gets created for user friendly id using project name" do
      expect(project.slug).to eq "factor-75-autotest"
    end

    it "can be used to find project" do
      expect(Project.find(project.slug)).to eq project
    end
  end

  it "returns base url of project" do
    project = create(:project, url: "http://factor75.com/menu")
    expect(project.base_url('http')).to eq "http://factor75.com"
  end

  describe 'users' do

    describe 'owners' do

      let(:user)    { create(:user) }
      let(:project) { create(:project) }
      let!(:project_user) { create(:project_user, project: project, user: user, rights: 'owner') }

      subject { project }

      it "should have many users" do
        expect(subject.users).to eq([user])
      end

      it "should have many owners" do
        expect(subject.owners).to eq([user])
      end

      it "should respond to true w/ owner" do
        expect(subject.owner?(user)).to be_true
      end

    end

  end

  describe 'script methods' do

    let(:project) { create(:project) }

    context 'with script present' do

      before do
        project.stubs(:search_for_script).returns(true)
      end

      it "should have a script_present? of true" do
        expect(project.script_present?).to be_true
      end
    end

    context 'without script present' do

      before do
        project.stubs(:search_for_script).returns(false)
      end

      it "should have a script_present? of false" do
        expect(project.script_present?).to be_false
      end

    end

  end

  # describe 'project script valid' do

  #   let!(:project) { create(:project) }

  #   context 'with valid attributes' do

  #     before do
  #       Script = Struct.new(:project) do
  #         def attributes
  #           {"data-auth" => project.api_key, "data-project-id" => project.id}
  #         end
  #       end
  #       @script = Script.new(project)
  #       puts @script.inspect
  #     end

  #     it "should return true" do
  #       expect(project.project_script_valid?(@script)).to be_true
  #     end

  #   end

  # end

end
