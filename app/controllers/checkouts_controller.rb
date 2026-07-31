class CheckoutsController < ApplicationController
  before_action :require_login
  before_action :ensure_cart_not_empty

  def show
    @cart = session[:cart] || {}
    @cart_products = build_cart_products(@cart)
    @total = @cart_products.sum { |item| item[:subtotal] }
    @logged_in_user = current_customer
    @province = @logged_in_user&.province_id ? Province.find_by(id: @logged_in_user.province_id) : nil
    calculate_taxes(@total, @province)
  end

  def create
    @cart = session[:cart] || {}
    @cart_products = build_cart_products(@cart)
    @total = @cart_products.sum { |item| item[:subtotal] }
    @logged_in_user = current_customer

    if params[:province_id].present?
      @logged_in_user.update(province_id: params[:province_id])
    end

    @province = @logged_in_user&.province_id ? Province.find_by(id: @logged_in_user.province_id) : nil
    calculate_taxes(@total, @province)

    order = Order.new(
      user: @logged_in_user,
      status: "pending",
      pickup_date: params[:pickup_date],
      notes: params[:notes],
      gst_amount: @gst_amount,
      pst_amount: @pst_amount,
      hst_amount: @hst_amount
    )

    if order.save
      @cart_products.each do |item|
        order.order_items.create!(
          product: item[:product],
          quantity: item[:quantity],
          price_at_purchase: item[:product].price
        )
      end
      session[:cart] = {}
      redirect_to order_path(order), notice: "Order placed successfully!"
    else
      render :show
    end
  end

  private

  def require_login
    unless current_customer
      redirect_to new_user_session_path, alert: "Please sign in to checkout."
    end
  end

  def ensure_cart_not_empty
    if session[:cart].blank?
      redirect_to root_path, alert: "Your cart is empty."
    end
  end

  def build_cart_products(cart)
    cart_products = []
    cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        subtotal = product.price * quantity
        cart_products << { product: product, quantity: quantity, subtotal: subtotal }
      end
    end
    cart_products
  end

  def calculate_taxes(total, province)
    if province
      @gst_amount = (total * province.gst_rate).round(2)
      @pst_amount = (total * province.pst_rate).round(2)
      @hst_amount = (total * province.hst_rate).round(2)
    else
      @gst_amount = 0
      @pst_amount = 0
      @hst_amount = 0
    end
    @tax_total = @gst_amount + @pst_amount + @hst_amount
    @grand_total = total + @tax_total
  end
end
