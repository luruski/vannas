class Province < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, uniqueness: true
  validates :gst_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_rate, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[abbreviation created_at gst_rate hst_rate id name pst_rate updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['users']
  end
end
