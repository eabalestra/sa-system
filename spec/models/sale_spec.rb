require 'rails_helper'

RSpec.describe Sale, type: :model do

  before(:context) do
    @user = FactoryBot.create(:user)
  end

  after(:context) do
    @user.destroy
  end

  it "is valid with valid attributes" do
    expect(User.find(@user.id)).to be_present
    sale = Sale.new(user: @user, total_amount: 0.0)

    expect(sale).to be_valid
  end

  it "is not valid without a total_amount" do
    sale = Sale.new(total_amount: nil)
    expect(sale).to_not be_valid
  end

  it "is not valid without a user_id" do
    sale = Sale.new(user_id: nil)
    expect(sale).to_not be_valid
  end

  it "is not valid without a client_id" do
    sale = Sale.new(client_id: nil)
    expect(sale).to_not be_valid
  end

  it "is not valid without a payment_status" do
    sale = Sale.new(payment_status: nil)
    expect(sale).to_not be_valid
  end

  it "is not valid without a created_at" do
    sale = Sale.new(created_at: nil)
    expect(sale).to_not be_valid
  end

  it "is not valid without a updated_at" do
    sale = Sale.new(updated_at: nil)
    expect(sale).to_not be_valid
  end

  it "is not valid without a user_id" do
    sale = Sale.new(user_id: nil)
    expect(sale).to_not be_valid
  end

  it "is not valid without a client_id" do
    sale = Sale.new(client_id: nil)
    expect(sale).to_not be_valid
  end

  it "is not valid without a payment_status" do
    sale = Sale.new(payment_status: nil)
    expect(sale).to_not be_valid
  end

  it "is not valid without a created_at" do
    sale = Sale.new(created_at: nil)
    expect(sale).to_not be_valid
  end

  it "is not valid without a updated_at" do
    sale = Sale.new(updated_at: nil)
    expect(sale).to_not be_valid
  end
end
