# frozen_string_literal: true

# class product
class Product < ApplicationRecord

  belongs_to :category
  has_many :orders
  has_many :purchases, through: :orders
  has_many :product_tags
  has_many :tags, through: :product_tags
  has_many :likes
  has_many :users, through: :likes
  has_one_attached :image
  has_many :comments, as: :commentable

  validates :sku, uniqueness: true
  validates :name, uniqueness: true
  validates :stock, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 0 }

  scope :order_by_name, -> { order(name: :asc) }
  scope :order_by, ->(criteria) { order(criteria) }
  scope :find_by_status1, -> { where(status: 1) }
  scope :find_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
  scope :find_by_category_id, ->(category_id) { where(category_id: category_id) }
  
  def thumb
    image.variant(resize: '220x220!')
  end
end
