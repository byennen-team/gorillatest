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
end
