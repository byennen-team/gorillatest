require 'spec_helper'

describe Message do

  describe 'relationships' do

    it { should belong_to(:user) }

  end


end
