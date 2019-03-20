class Purchase < ApplicationRecord
  belongs_to :user, optional: true
  has_many :orders
  has_many :products, through: :orders

  scope :find_by_user_completed, ->(user) { where(user_id: user.id, state: 'completed') }
  scope :find_by_user_in_progress, ->(user) { where(user_id: user.id, state: 'in_progress') } 
end
