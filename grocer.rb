require "pry"

def consolidate_cart(cart)
  # code here
  groceries = {}
  
  cart.each do |item_data|
    item_data.each do |item, data|
      groceries[item] = data
      groceries[item][:count] = 0
    end 
  end
  
  cart.each do |item_data|
    item_data.each do |item, data|
      if item == item_data.key(data)
        groceries[item][:count] += 1
      end 
    end 
  end
  
  groceries
  
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name =  coupon[:item]
    if cart.has_key?(item_name) && cart[item_name][:count] >= coupon[:num]
      cart[item_name][:count] = cart[item_name][:count] - coupon[:num]
      item_coupon_name = "#{item_name} W/COUPON"
      if !(cart.has_key?(item_coupon_name))
        cart[item_coupon_name] = {
          :price => coupon[:cost], 
          :clearance => cart[item_name][:clearance], 
          :count => 1
        }
      else 
        cart[item_coupon_name][:count] += 1
      end
    end
  end
  
  cart
end 

def apply_clearance(cart)
  # code here
  cart.each do |item, data|
    if data[:clearance] == true
      float_price = data[:price].to_f 
      raw_clearance_price = data[:price].to_f - (data[:price].to_f * 0.2)
      clearance_price = raw_clearance_price.round(2)
      data[:price] = clearance_price
    end
  end 
  
  cart
end

def checkout(cart, coupons)
  # code here
  cart_total = 0.00
  
  consolidated_cart = consolidate_cart(cart)
  apply_coupons(consolidated_cart, coupons)
  apply_clearance(consolidated_cart)
  
  consolidated_cart.each do |item, data|
    cart_total += (data[:price] * data[:count])
  end 
  
  if cart_total > 100.00
    discounted_cart_total = cart_total - (cart_total * 0.1)
    cart_total = discounted_cart_total
  end 
  
  cart_total
end
