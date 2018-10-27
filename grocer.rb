require "pry"

def consolidate_cart(cart)
  cart_items = []
  consolidated_cart = {}
  cart.each do |item|
    item.each do |name, info|
     if !cart_items.include?(name)
       cart_items << name
       info[:count] = 1
       consolidated_cart[name] = info
     elsif cart_items.include?(name)
       consolidated_cart[name][:count] += 1
     end
    end
  end
  #binding.pry
consolidated_cart
end

def apply_coupons(cart, coupons)
  updated_cart = cart
  cart_items = cart.keys
  coupons.each do |coupon|
   if cart_items.include?(coupon[:item]) && updated_cart[coupon[:item]][:count] >= coupon[:num]
     updated_cart[coupon[:item]][:count] -= coupon[:num]
     updated_cart["#{coupon[:item]} W/COUPON"] = { :price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :count => 1 }
    #if updated_cart[coupon[:item]][:count] == 0
    #  updated_cart.delete(coupon[:item])
    if updated_cart[coupon[:item]][:count] >= coupon[:num]
      updated_cart[coupon[:item]][:count] -= coupon[:num]
      updated_cart["#{coupon[:item]} W/COUPON"][:count] += 1
    end
   end
  end
  updated_cart
end

def apply_clearance(cart)
  updated_cart = cart
  updated_cart.each do |item, info|
      if info[:clearance] == true
        info[:price] -= info[:price] * 0.2
      end
  end
  updated_cart
end

def checkout(cart, coupons)
  total_price = 0.0
  consolidated_cart = consolidate_cart(cart)
  updated_cart_after_coupons = apply_coupons(consolidated_cart, coupons)
  cart_after_clearance = apply_clearance(updated_cart_after_coupons)
  cart_after_clearance.each do |item, info|
    total_price += info[:price] * info[:count]
  end
  if total_price > 100.0
    total_price -= total_price * 0.1
  end
  total_price
end
