class ProductTag < ApplicationRecord
  belongs_to :product
  belongs_to :tag

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id product_id tag_id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[product tag]
  end
end
