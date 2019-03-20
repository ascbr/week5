# frozen_string_literal: true

# category.rb

# Class category
class Category < ApplicationRecord
  has_many :products
  validates :name, uniqueness: true

  scope :order_by_name, -> { order(name: :ASC) }
end
