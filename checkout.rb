class Checkout

  attr_reader :pricings
  
  def initialize(pricing_data)
    load_pricings(pricing_data)
  end

  def shop(shopping_data)
    load_sku_data shopping_data
    make_purchases
    output
  end

  private

  def output
    lines = @sku_data.keys.sort.map do |sku|
      sku_data = @sku_data[sku]
      sku = sku.upcase
      quantity = sku_data[:quantity_bought]
      total = sprintf("%0.02f", sku_data[:total])
      "#{sku} #{quantity} #{total}"
    end
    total_cost = @sku_data.values.inject(0) { |sum, sku_data| sum + sku_data[:total] }
    lines << "TOTAL " + sprintf("%0.02f", total_cost)
    lines.join("\n")
  end

  # figure out all of the most optimal purchases
  def make_purchases
    @sku_data.keys.each { |sku| make_purchase @sku_data[sku] }
  end

  # figure out the optimal purchases for a particular sku
  # each sku_data has sku, quantity, and total
  def make_purchase(sku_data)
    pricings = optimal_pricings_for(sku_data[:sku])
    while sku_data[:quantity] > 0
      return unless pricing = pricings.detect { |pricing| pricing.quantity <= sku_data[:quantity] } 
      sku_data[:quantity_bought] += pricing.quantity
      sku_data[:quantity] -= pricing.quantity
      sku_data[:total] += pricing.price
    end
  end
  
  # returns the pricings for a particular sku sorted by the most affordable
  # to the least
  def optimal_pricings_for(sku)
    pricings = @pricings.select { |pricing| pricing.sku == sku }
    pricings.sort { |a,b| a.price_per_unit <=> b.price_per_unit }
  end

  def load_sku_data(shopping_data)
    @sku_data = {}
    shopping_data.split(/\s+/).each do |sku|
      @sku_data[sku] ||= { :sku => sku, :quantity => 0, :total => 0, :quantity_bought => 0 }
      @sku_data[sku][:quantity] += 1
    end
  end
  
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
  attr_reader :sku, :quantity, :price, :price_per_unit
  
  def initialize(sku, quantity, price)
    raise ArgumentError unless sku and quantity and price
    @sku = sku
    @quantity = quantity.to_i
    @price = price.to_f
    @price_per_unit = @price.to_f / @quantity
  end
  
end

class String
  def blank?
    self =~ /^\s+$/
  end
end