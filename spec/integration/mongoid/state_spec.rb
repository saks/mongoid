require_relative "../../spec_helper"

describe Mongoid::State do

  before do
    Site.collection.remove
  end

  after do
    Site.collection.remove
  end


  context "model state" do
    it 'return valid state during model building' do
      lambda do
        Site.new :url => 'http://test.url.com'
      end.should_not raise_exception(Site::InvalidState)
    end
  end

end

