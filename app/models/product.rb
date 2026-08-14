class Product < ApplicationRecord
  belongs_to :category

  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
    attachable.variant :medium, resize_to_limit: [600, 600]
  end

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :available, inclusion: { in: [true, false] }

  def self.ransackable_attributes(auth_object = nil)
    ["available", "category_id", "created_at", "description", "id", "image", "name", "price", "updated_at", "on_sale", "sale_price"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "image_attachment", "image_blob", "product_tags", "tags"]
  end
end