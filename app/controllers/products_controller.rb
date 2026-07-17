class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.where(available: true).includes(:category)

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:search].present?
      @products = @products.where(
        "name LIKE ? OR description LIKE ?",
        "%#{params[:search]}%",
        "%#{params[:search]}%"
      )
    end
  end

  def show
    @product = Product.find(params[:id])
  end
end