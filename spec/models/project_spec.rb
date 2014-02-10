require 'spec_helper'

describe Project do

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

  it "returns base url of project" do
    project = create(:project, url: "http://factor75.com/menu")
    expect(project.base_url).to eq "http://factor75.com"
  end

end
