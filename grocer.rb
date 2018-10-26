require 'pry'
def consolidate_cart(cart) # consolicate an array to a hash
  consolidate_cart = {}


  cart.each do |item_hash|
    item_hash.each do |item, item_data|
#binding.pry
      if !consolidate_cart[item].kind_of?(Hash)
        consolidate_cart[item] = {}

        consolidate_cart[item] = item_data
        consolidate_cart[item][:count] = 1  #to add [:count] key has to behind item_data.
         # binding.pry
      elsif (consolidate_cart.keys).include?(item)
        consolidate_cart[item][:count] += 1
      end

    end
  end
  consolidate_cart
end



def apply_coupons(cart, coupons)

  coupons.each do |coupon| # iternate coupons only. Adjust cart and make it the return value.
    coupon_name = coupon[:item]
    if cart[coupon_name] && cart[coupon_name][:count] >= coupon[:num] # if count < num, no need to change any.
      if cart["#{coupon_name} W/COUPON"]
        cart["#{coupon_name} W/COUPON"][:count] += 1
      else
        cart["#{coupon_name} W/COUPON"] = {:price => coupon[:cost],:count => 1} # need this to intiate the new key
        cart["#{coupon_name} W/COUPON"][:clearance] = cart[coupon_name][:clearance]
      end
      cart[coupon_name][:count] -= coupon[:num]  #reduce the items count from cart got the discount.
                                                # cart[coupon_name][:count] missed coupon name
    end
  end
  cart
end

  # apply_coupons = {}  # My code with 2 iteration not working.
  # item_with_coupon = ""
  # return cart if !coupons # if there is no coupon.
  #
  # cart.each do |cart_item, item_hash|
  #
  #   coupons.each do |each_coupon|   #for multiple coupons
  #     each_coupon.each do |coupon|
  #       if !cart.keys.include?(coupon[:item]) # have to know there is match first before runn the iteration
  #         apply_coupons[cart_item] = item_hash
  #       elsif cart_item == coupon[:item]
  #
  #         if item_hash[:count] == coupon[:num] && item_hash[:clearance] == true
  #           item_with_coupon = cart_item + " W/COUPON"
  #           apply_coupons[item_with_coupon] = item_hash
  #           apply_coupons[item_with_coupon][:price] = coupon[:cost]
  #           apply_coupons[item_with_coupon][:count] = 1  # always one "bundle" of discounted
  #
  #         # elsif item_hash[:count] < coupon[:num] && item_hash[:clearance] == true # this conditin will be no coupon to apply
  #         #   item_with_coupon = cart_item + " W/COUPON"
  #         #   apply_coupons[item_with_coupon] = item_hash
  #         #   apply_coupons[item_with_coupon][:count] = item_hash[:count] # the less number is count in item_hash
  #
  #         elsif item_hash[:count] > coupon[:num] && item_hash[:clearance] == true
  #           apply_coupons[cart_item] = item_hash
  #           apply_coupons[cart_item][:count] = item_hash[:count] - coupon[:num] #Items left without discount
  #
  #           item_with_coupon = cart_item + " W/COUPON"
  #           apply_coupons[item_with_coupon] = item_hash   # item include by coupon.
  #           apply_coupons[item_with_coupon][:price] = coupon[:cost]
  #           apply_coupons[item_with_coupon][:count] = 1   # always one "bundle" of discounted
  #           #binding.pry
  #         end
  #
  #       #else
  #         #apply_coupons[cart_item] = item_hash # no match with coupon, just add the same item to apply_coupons
  #       end
  #     end
  #   end
  # end



def apply_clearance(cart)
  cart.each do |item, data|
    data[:price] = (data[:price] * 0.8).round(2) if data[:clearance] == true # exclude the item no clearance
  end
  cart
end


def checkout(cart, coupons)
  consolicate_cart = consolidate_cart(cart)
  apply_coupons = apply_coupons(consolicate_cart, coupons)
  apply_clearance = apply_clearance(apply_coupons)

  total_cost = 0

  apply_clearance.each do |item, data|
    total_cost += data[:price] * data[:count]
  end

    total_cost = total_cost * 0.9 if total_cost > 100

  total_cost
end
