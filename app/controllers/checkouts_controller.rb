class CheckoutsController < ApplicationController
  before_action :require_login
  before_action :ensure_cart_not_empty, only: %i[show create]

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
      @logged_in_user.update(
        province_id: params[:province_id],
        phone: params[:phone],
        address: params[:address],
        city: params[:city]
      )
    end

    @province = @logged_in_user&.province_id ? Province.find_by(id: @logged_in_user.province_id) : nil
    calculate_taxes(@total, @province)

    order = Order.new(
      user: @logged_in_user,
      status: 'pending',
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

      session[:pending_order_id] = order.id

      stripe_session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'cad',
            product_data: {
              name: "Vannas Bakery Order ##{order.id}"
            },
            unit_amount: (@grand_total * 100).to_i
          },
          quantity: 1
        }],
        mode: 'payment',
        success_url: "#{success_checkout_url}?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: cancel_checkout_url
      )

      redirect_to stripe_session.url, allow_other_host: true
    else
      render :show
    end
  end

  def success
    order = Order.find_by(id: session[:pending_order_id])

    if order && params[:session_id].present?
      stripe_session = Stripe::Checkout::Session.retrieve(params[:session_id])
      order.update(
        status: 'paid',
        stripe_payment_id: stripe_session.payment_intent
      )
      session.delete(:pending_order_id)
      session[:cart] = {}
      redirect_to order_path(order), notice: 'Payment successful! Your order has been placed.'
    else
      redirect_to root_path, alert: 'Something went wrong with your payment.'
    end
  end

  def cancel
    order = Order.find_by(id: session[:pending_order_id])
    order&.update(status: 'cancelled')
    session.delete(:pending_order_id)
    redirect_to cart_path, alert: 'Payment was cancelled. Your cart is still saved.'
  end

  private

  def require_login
    return if current_customer

    redirect_to new_user_session_path, alert: 'Please sign in to checkout.'
  end

  def ensure_cart_not_empty
    return unless session[:cart].blank?

    redirect_to root_path, alert: 'Your cart is empty.'
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
