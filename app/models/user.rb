class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders

  validates :email, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at email id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['orders']
  end
end
