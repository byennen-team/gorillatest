require 'spec_helper'

describe Feature do

  it { should embed_many(:scenarios) }

end
