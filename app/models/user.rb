class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :likes
  has_many :products, through: :likes
  has_many :comments, as: :commentable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  :username
  
  def admin?
    has_role?(:admin)
  end
  
  def client?
    has_role?(:client)
  end

end
