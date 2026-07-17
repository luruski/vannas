class ProductsController < ApplicationController
  def index
    @products = Product.where(available: true).includes(:category)
  end

  def show
    @product = Product.find(params[:id])
  end
end