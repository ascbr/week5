class Purchase < ApplicationRecord
  belongs_to :user, optional: true
  has_many :orders
  has_many :products, through: :orders

  scope :find_by_current_user_completed, -> { where(user_id: current_user.id, state: 'completed') } 
end
