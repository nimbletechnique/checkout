require 'rubygems'
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

    def squeeze(input)
      input.split("\n").inject([]) { |result, string|
        result << string.strip
        result
      }.join("\n").strip
    end

    it "Should load valid pricing data" do
      @checkout.should have(5).pricings
    end
    
    it "should pass scenario #1" do
      @checkout.shop("a a b a").should eql(squeeze(%{ 
        A 3 1.20
        B 1 0.30
        TOTAL 1.50
      }))
    end
    
    it "should pass scenario #2" do
      @checkout.shop("c c a c a c b c c a b a b").should eql(squeeze(%{ 
        A 4 1.70
        B 3 0.90
        C 6 25.00
        TOTAL 27.60
      }))
    end 
    
    it "should pass scenario #3" do
      @checkout.shop("b c c").should eql(squeeze(%{
        C 2 10.00
        B 1 0.60
        TOTAL 10.60        
      }))
    end
    
  end 

end