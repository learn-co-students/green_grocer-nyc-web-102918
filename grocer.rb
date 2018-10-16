require 'pry'

def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |item_hash|
    item_hash.each do |name, info|
      if cart_hash.key?(name)
          cart_hash[name][:count] += 1
      else 
        cart_hash[name] = info
        cart_hash[name][:count] = 1
      end
    end
  end
  cart_hash
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
  name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
    cart[name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |name, info|
    if cart[name][:clearance]
      cart[name][:price] = (cart[name][:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total_price = 0
  cart.each do |name, info|
    total_price = total_price + (cart[name][:price] * cart[name][:count])
  end
  if total_price > 100
    total_price = (total_price * 0.9).round(2)
  end
  total_price
end

