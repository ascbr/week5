class Product < ApplicationRecord
  belongs_to :category
  has_many :orders
  has_many :purchases, through: :orders
  has_many :product_tags
  has_many :tags, through: :product_tags
  has_many :likes
  has_many :users, through: :likes
  validates :sku, uniqueness: true
  validates :name, uniqueness: true

  has_one_attached :image
  def thumb
   return self.image.variant(resize: '220x220')
  
  end
end
