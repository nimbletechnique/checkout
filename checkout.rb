class Checkout

  attr_reader :pricings
  
  def initialize(pricing_data)
    load_pricings(pricing_data)
  end

  private
  
  def load_pricings(data)
    @pricings = []
    if data
      data.split("\n").each do |line|
        next if line.blank?
        sku, quantity, price = *line.split(" ")
        @pricings << Pricing.new(sku, quantity, price)
      end
    end
  end
  
end

class Pricing
  attr_accessor :sku, :quantity, :price
  
  def initialize(sku, quantity, price)
    @sku = sku
    @quantity = quantity
    @price = price
  end
  
end