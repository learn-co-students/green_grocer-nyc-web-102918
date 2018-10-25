require 'pry'

def consolidate_cart(cart)
  # code here
  hash = {}
  cart.each do |cart_element|
    cart_element.each do |k, v_hash|
      if hash.has_key?(k) == false
        hash[k] = v_hash
        hash[k][:count] = 1
      else
        hash[k][:count] += 1
      end
    end
  end
  hash
end

def apply_coupons(cart, coupons)
  new_cart = cart
  coupons.each do |object|
    if cart.has_key?(object[:item]) && cart[object[:item]][:count] >= object[:num]
      new_cart[object[:item]][:count] -= object[:num]
      if new_cart.has_key?("#{object[:item]} W/COUPON") == false
        new_cart["#{object[:item]} W/COUPON"] = {price: object[:cost], clearance: cart[object[:item]][:clearance], count: 1}
      else
        new_cart["#{object[:item]} W/COUPON"][:count] += 1
      end
    end
  end
  new_cart
end

def apply_clearance(cart)
  cart.each do |item, item_info|
    if item_info[:clearance] == true
      item_info[:price] = (item_info[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  clearance_cart.each do |item, item_info|
    total += (item_info[:price] * item_info[:count])
  end
  if total > 100
    total * 0.9
  else
    total
  end
end
