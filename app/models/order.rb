class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true

  def total
    order_items.sum { |item| item.price_at_purchase * item.quantity }
  end

  def tax_total
    gst_amount.to_f + pst_amount.to_f + hst_amount.to_f
  end

  def grand_total
    total + tax_total
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gst_amount", "hst_amount", "id", "notes", "pickup_date", "pst_amount", "status", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order_items", "products", "user"]
  end
end