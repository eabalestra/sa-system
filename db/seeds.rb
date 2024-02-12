require 'faker'

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a default user
User.create(email:"agusbalestra0@gmail.com", password: "TtyQQ96k6v5u!")

5.times do
  Supplier.create(
    name: Faker::Company.name,
    phone: Faker::PhoneNumber.phone_number,
    dir: Faker::Address.street_address,
    email: Faker::Internet.email,
    city: Faker::Address.city,
    website: Faker::Internet.url
  )
end

# Create some clients
10.times do
  Client.create(
    name: Faker::Name.name,
    phone: Faker::PhoneNumber.phone_number,
    dir: Faker::Address.street_address,
    email: Faker::Internet.email,
    city: Faker::Address.city
  )
end

# Create some products
30.times do
  Product.create(
    cod: Faker::Code.unique.asin,
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence(word_count: 10),
    existence: rand(1..100),
    last_price_update_date: Faker::Date.between(from: 2.days.ago, to: Date.today),
    last_stock_update_date: Faker::Date.between(from: 2.days.ago, to: Date.today),
    unit_cost: Faker::Commerce.price(range: 0..100.0),
    selling_unit_price: Faker::Commerce.price(range: 100..200.0),
    supplier_id: Supplier.order(Arel.sql('RANDOM()')).first.id,
    iva_amount: Faker::Commerce.price(range: 0..20.0),
    profit_margin: Faker::Commerce.price(range: 0..20.0)
  )
end
