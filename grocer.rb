
def consolidate_cart(cart)
  new_cart = {}
  cart.each do |items|
    items.each do |veggie_name, info|
      if new_cart[veggie_name]
        new_cart[veggie_name][:count] += 1
      else
        info[:count] = 1
        new_cart[veggie_name] = info
      end
    end
  end

  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do  |coupon|
    if cart["#{coupon[:item]} W/COUPON"] && cart[coupon[:item]][:count] >= coupon[:num]
      cart[coupon[:item]][:count] -= coupon[:num]
      cart["#{coupon[:item]} W/COUPON"][:count] += 1
    elsif cart[coupon[:item]] &&  cart[coupon[:item]][:count] >= coupon[:num]
      cart["#{coupon[:item]} W/COUPON"] = {}
      cart[coupon[:item]][:count] -= coupon[:num]
      cart["#{coupon[:item]} W/COUPON"][:count] = 1
      cart["#{coupon[:item]} W/COUPON"][:price] = coupon[:cost]
      cart["#{coupon[:item]} W/COUPON"][:clearance] = cart[coupon[:item]][:clearance]
    end
  end

  cart
end

def apply_clearance(cart)
  cart.each_value do|info|
    info[:clearance] ? info[:price]= (0.8 * info[:price]).round(2) : info[:price]
  end
end

def checkout(cart, coupons)
  total = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  cart.each_value do |info|
    total += (info[:price] * info[:count])
  end

  if total > 100
    total = (total * 0.9).round(2)
  end

  total


end
