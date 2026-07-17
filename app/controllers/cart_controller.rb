class CartController < ApplicationController
  def show
    @cart = session[:cart] || {}
    @cart_products = []
    @total = 0

    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        subtotal = product.price * quantity
        @total += subtotal
        @cart_products << { product: product, quantity: quantity, subtotal: subtotal }
      end
    end
  end

  def add
    product = Product.find(params[:product_id])
    session[:cart] ||= {}
    session[:cart][params[:product_id].to_s] ||= 0
    session[:cart][params[:product_id].to_s] += 1
    redirect_to root_path, notice: "#{product.name} added to cart!"
  end

  def update
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i
    session[:cart] ||= {}
    if quantity <= 0
      session[:cart].delete(product_id)
    else
      session[:cart][product_id] = quantity
    end
    redirect_to cart_path, notice: "Cart updated!"
  end

  def remove
    session[:cart] ||= {}
    session[:cart].delete(params[:product_id].to_s)
    redirect_to cart_path, notice: "Item removed from cart!"
  end
end