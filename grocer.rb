def consolidate_cart(cart)
 newHash = {}
  cart.each do |food, info|
      food.each do |a,b|
        if newHash[a]== nil
          newHash[a]={price: b[:price], clearance: b[:clearance], count: 1}
        else
          newHash[a][:count]+=1
        end
      end
  end
  return newHash
end


def apply_coupons(cart, coupons)
   new_cart = {}
  cart.each do |grocery, info|
    coupons.each do |coupon|
      if grocery == coupon[:item] && info[:count] >= coupon[:num]
        cart[grocery][:count] = cart[grocery][:count] - coupon[:num]
        if new_cart[grocery + " W/COUPON"]
          new_cart[grocery + " W/COUPON"][:count] += 1
        else
          new_cart[grocery + " W/COUPON"] = {:price => coupon[:cost], :clearance => cart[grocery][:clearance], :count => 1}
        end
      end
    end
    new_cart[grocery] = info

  end
  new_cart
end


def apply_clearance(cart)
 	 cart.each do |item_name, item_hash|
    if item_hash[:clearance] == true
      clearance_price = item_hash[:price] - (item_hash[:price] * 0.2)
      item_hash[:price] = clearance_price
    end
  end
  cart
end

def checkout(cart, coupons)
  cart: []
  coupons: []
total = 0
  cart = consolidate_cart(cart)
  
  if cart.length == 1
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    if cart_clearance.length > 1
      cart_clearance.each do |item, details|
        if details[:count] >=1
          total += (details[:price]*details[:count])
        end
      end
    else
      cart_clearance.each do |item, details|
        total += (details[:price]*details[:count])
      end
    end
  else
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    cart_clearance.each do |item, details|
      total += (details[:price]*details[:count])
    end
  end
  

  if total > 100
    total = total*(0.90)
  end
  total
end
