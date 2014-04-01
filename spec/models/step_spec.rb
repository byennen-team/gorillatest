require 'spec_helper'

describe Step do

  describe 'relations' do

    it { should be_embedded_in(:scenario) }

  end

  describe 'methods' do


    describe 'to_s' do

      let(:scenario) { create(:scenario) }

      context 'event_type is setElementText' do

        let(:step) { create(:step, scenario: scenario, event_type: 'setElementText', text: "Input1", locator_value: "name") }

        it "should have a to_s of Set input value  for element #name" do
          expect(step.to_s).to eq("Set input value Input1 for element #name")
        end

      end

      context 'event_type is setElementSelected' do

        let(:step) { create(:step, scenario: scenario, event_type: 'setElementText', text: "Input1", locator_value: "name") }

      end

      context 'event_type is clickElement' do

        let(:step) { create(:step, scenario: scenario, event_type: 'setElementText', text: "Input1", locator_value: "name") }

      end

      context 'event_type is submitElement' do

        let(:step) { create(:step, scenario: scenario, event_type: 'setElementText', text: "Input1", locator_value: "name") }

      end

      context 'event_type is waitForCurrentUrl' do

        let(:step) { create(:step, scenario: scenario, event_type: 'setElementText', text: "Input1", locator_value: "name") }

      end

      context 'event_type is verifyText' do

        let(:step) { create(:step, scenario: scenario, event_type: 'setElementText', text: "Input1", locator_value: "name") }


      end

      context 'event_type is verifyElementPresent' do

        let(:step) { create(:step, scenario: scenario, event_type: 'setElementText', text: "Input1", locator_value: "name") }

      end

      context 'event_type is get' do
        let(:step) { create(:step, scenario: scenario, event_type: 'setElementText', text: "Input1", locator_value: "name") }

      end

      context 'event_type is assertConfirmation' do

        let(:step) { create(:step, scenario: scenario, event_type: 'setElementText', text: "Input1", locator_value: "name") }

      end

      context 'event_type is chooseCancelOnNextConfirmation' do

        let(:step) { create(:step, scenario: scenario, event_type: 'setElementText', text: "Input1", locator_value: "name") }

      end

      context 'event_type is chooseAcceptOnNextConfirmation' do

        let(:step) { create(:step, scenario: scenario, event_type: 'setElementText', text: "Input1", locator_value: "name") }

      end


    end
  end

  describe "http basic auth on project" do
    let!(:project) { create(:project, basic_auth_username: "username", basic_auth_password: "password")}
    let!(:scenario) { project.scenarios.create(name: "Testing", window_x: 720, window_y: 1030)}

    context "get URL" do
      let(:get_step) { scenario.steps.create(event_type: "get", text: "http://www.factor75.com")}

      it "auth gets added" do
        expect(get_step.text).to eq "http://username:password@www.factor75.com"
      end
    end

    context "non url related steps" do
      let(:click_step) { scenario.steps.create(event_type: "clickElement", text: "shopping cart")}

      it "returns raw step text" do
        expect(click_step.text).to eq "shopping cart"
      end
    end

    context "url related step with no auth" do
      let(:no_auth_step) {scenario.steps.create(event_type: "waitForCurrentUrl", text: "http://www.factor75.com/about")}

      before do
        project.update_attributes(basic_auth_password: nil, basic_auth_username: nil)
      end

      it "returns original url" do
        expect(no_auth_step.text).to eq "http://www.factor75.com/about"
      end
    end
  end
end
