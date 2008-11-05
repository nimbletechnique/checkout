require 'rubygems'
require 'active_support'
require 'checkout'
require 'spec'

describe Checkout do

  it "should accept nil input" do
    lambda { Checkout.new(nil) }.should_not raise_error
  end
  
  it "should accept blank input" do
    lambda { Checkout.new("") }.should_not raise_error
  end

  describe "Business Rules" do
    
    before :each do
      @pricing_data = File.read(File.dirname(__FILE__) + "/pricings.txt")
      @checkout = Checkout.new(@pricing_data)
    end

    it "Should load valid pricing data" do
      @checkout.should have(5).pricings
    end
    
  end  

end