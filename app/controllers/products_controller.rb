class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.where(available: true).includes(:category).order(:name)

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

    if params[:filter] == "on_sale"
      @products = @products.where(on_sale: true)
    elsif params[:filter] == "new"
      @products = @products.where("products.created_at >= ?", 3.days.ago)
    elsif params[:filter] == "recently_updated"
      @products = @products.where("products.updated_at >= ?", 3.days.ago)
                           .where("products.created_at < ?", 3.days.ago)
    end

    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
  end
end