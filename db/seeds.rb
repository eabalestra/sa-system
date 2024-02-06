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

# Create clients
10.times do
  Client.create(
    name: Faker::Name.name,
    phone: Faker::PhoneNumber.phone_number,
    dir: Faker::Address.street_address,
    email: Faker::Internet.email,
    city: Faker::Address.city
  )
end

# Create suppliers
10.times do
  Supplier.create(
    name: Faker::Company.name,
    phone: Faker::PhoneNumber.phone_number,
    dir: Faker::Address.street_address,
    email: Faker::Internet.email,
    city: Faker::Address.city,
    website: Faker::Internet.url
  )
end

# Create products
10.times do
  Product.create(
    cod: Faker::Number.number(digits: 10),
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    existence: Faker::Number.between(from: 1, to: 100),
    unit_cost: Faker::Commerce.price,
    selling_unit_price: Faker::Commerce.price,
    supplier_id: Supplier.order(Arel.sql('RANDOM()')).first.id,
    iva_amount: Faker::Number.decimal(l_digits: 2),
    profit_margin: Faker::Number.decimal(l_digits: 2),
    last_stock_update_date: Faker::Date.between(from: 100.days.ago, to: 2.days.ago),
    last_price_update_date: Faker::Date.between(from: 100.days.ago, to: 2.days.ago)
  )
end

# Create sales
10.times do
  sale = Sale.create(
    total_amount: Faker::Commerce.price,
    user_id: User.order(Arel.sql('RANDOM()')).first.id,
    client_id: Client.order(Arel.sql('RANDOM()')).first.id,
    payment_status: 0
  )

  # Create sale details
  3.times do
    SaleDetail.create(
      quantity: Faker::Number.between(from: 1, to: 10),
      product_id: Product.order(Arel.sql('RANDOM()')).first.id,
      sale_id: sale.id,
      price_at_sale: Faker::Commerce.price
    )
  end
end
