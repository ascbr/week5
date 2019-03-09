# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
require 'securerandom'

Role.create(name: :admin)
Role.create(name: :client)
user3 = User.create(username: 'Adilio',
	email: 'adilio.scbr@gmail.com',
	password: '123456',
	password_confirmation: '123456')
user3.add_role(:admin)

user1 = User.create(username: 'Nicole',
								    email: 'admin@gmail.com',
								    password: 'password1234',
								    password_confirmation: 'password1234')
user1.add_role(:admin)
user2 = User.create(username: 'Bruce',
								    email: 'client@gmail.com',
								    password: 'password1234',
								    password_confirmation: 'password1234')
user2.add_role(:client)

cat = []
10.times do |i| 
	cat[i] = Category.create(name: Faker::Games::Pokemon.name)  
end

products = []
random_num = Random.new
50.times do |i|
	products[i] = Product.create( name: Faker::Food.fruits,
								  price: random_num.rand(0.35..5.75),
								  category: cat[random_num.rand(0..9)],
								  stock: random_num.rand(50..200),
								  sku: SecureRandom.uuid)
end