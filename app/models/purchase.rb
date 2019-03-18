class Purchase < ApplicationRecord
  belongs_to :user, optional: true
  has_many :orders
  has_many :products, through: :orders
end
