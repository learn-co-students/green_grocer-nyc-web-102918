def consolidate_cart(cart)
  new_hash = {}
  cart.each do |grocery|
  ##for every item in the cart array(which are 3 hashes)
  ##we are going to 
    grocery.each do |key, value|
    ##create a new key in the new_hash
      if new_hash[key]
      ##if that key is already in the new hash
        new_hash[key][:count] += 1
      ##then we will add to the count value
      else
        new_hash[key] = value
        ##create a new key value pair
        new_hash[key][:count] = 1
        ##create a new count
      end
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
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

# def apply_clearance(cart)
#   clearance_cart = {}
#   cart.each do |food, info|
#     clearance_cart[food] = {}
#     if info[:clearance] == true
#       clearance_cart[food][:price] = info[:price] * 4 / 5
#     else
#       clearance_cart[food][:price] = info[:price]
#     end
#     clearance_cart[food][:clearance] = info[:clearance]
#     clearance_cart[food][:count] = info[:count]
#   end
#   clearance_cart
# end	

def apply_clearance(cart)
  cart.each do |item, price_hash|
    if price_hash[:clearance] == true
      price_hash[:price] = (price_hash[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(items, coupons)
  cart = consolidate_cart(items)
  cart1 = apply_coupons(cart, coupons)
  cart2 = apply_clearance(cart1)
  
  total = 0
  
  cart2.each do |name, price_hash|
    total += price_hash[:price] * price_hash[:count]
  end
  
  total > 100 ? total * 0.9 : total
  
end