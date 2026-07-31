class OrdersController < ApplicationController
  before_action :require_login

  def show
    @order = current_customer.orders.find(params[:id])
  end

  def index
    @orders = current_customer.orders.order(created_at: :desc)
  end

  private

  def require_login
    unless current_customer
      redirect_to new_user_session_path, alert: "Please sign in to view orders."
    end
  end
end
