def consolidate_cart(cart)
  consolidation = {}
  cart.each do |items|
    items.each do |key, value|
      if consolidation[key] == nil
        consolidation[key] = {price: value[:price], clearance: value[:clearance], count: 1}
      else
        consolidation[key][:count] += 1
      end
    end
  end
  return consolidation
end

def apply_coupons(cart, coupons)
  discounted = {}
  cart.each do |items, data|
    coupons.each do |coupon|
      if items == coupon[:item] && data[:count] >= coupon[:num]
        cart[items][:count] = cart[items][:count] - coupon[:num]
        if discounted[items + " W/COUPON"]
          discounted[items + " W/COUPON"][:count] += 1
        else
          discounted[items + " W/COUPON"] = {:price => coupon[:cost], :clearance => cart[items][:clearance], :count => 1}
        end
      end
    end
    discounted[items] = data
  end
  discounted
end

def apply_clearance(cart)
  cart.each do |items, prices|
    if prices[:clearance] == true
      prices[:price] = (prices[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  cart = consolidate_cart(cart)
  if cart.length == 1
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    if cart_clearance.length > 1
      cart_clearance.each do |items, data|
        if data[:count] >=1
          total += (data[:price]*data[:count])
        end
      end
    else
    cart_clearance.each do |items, data|
      total += (data[:price]*data[:count])
      end
    end
  else
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    cart_clearance.each do |items, data|
      total += (data[:price]*data[:count])
    end
  end
  if total > 100
    total = total*(0.90)
  end
  total
end
