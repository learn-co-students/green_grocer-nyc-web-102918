def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item|
    item.each do |food, info|
      if new_cart[food]
        new_cart[food][:count] += 1
      else
        new_cart[food] = info
        new_cart[food][:count] = 1
      end
    end
  end
new_cart
end

def apply_coupons(cart,coupons)
result = {}
  cart.each do |food, info|
    coupons.each do |coupon|
      if food == coupon[:item] && info[:count] >= coupon[:num]
        info[:count] =  info[:count] - coupon[:num]
        if result["#{food} W/COUPON"]
          result["#{food} W/COUPON"][:count] += 1
        else
          result["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => info[:clearance], :count => 1}
        end
      end
    end
    result[food] = info
  end
  result
end

def apply_clearance(cart)
  clearance_cart = {}
  cart.each do |food, info|
    clearance_cart[food] = {}
    if info[:clearance] == true
      clearance_cart[food][:price] = info[:price] * 4 / 5
    else
      clearance_cart[food][:price] = info[:price]
    end
    clearance_cart[food][:clearance] = info[:clearance]
    clearance_cart[food][:count] = info[:count]
  end
  clearance_cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart,coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |item_name, item_data|
    total += (item_data[:price] * item_data[:count])
  end
   if total > 100
    0.9 * total
  else
    total
  end
end
