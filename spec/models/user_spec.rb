require 'rails_helper'

RSpec.describe User, type: :model do

  before(:each) do
    @user = FactoryBot.create(:user)
  end

  after(:each) do
    User.destroy_all
  end

  it "update balance with negative amount" do
    # Arrange
    num = Random.rand(1..10000000)
    num2 = Random.rand(1..10000000)
    @user.actual_balance = num.to_d
    # Act
    @user.update_actual_balance(num2 * -1)
    # Assert
    expect(@user.actual_balance.to_f).to eq(num - num2)
  end

  it "update balance with positive amount" do
    # Arrange
    num = Random.rand(1..10000000)
    num2 = Random.rand(1..10000000)
    @user.actual_balance = num
    # Act
    @user.update_actual_balance(num2)
    # Assert
    expect(@user.actual_balance.to_f).to eq(num + num2)
  end

  it "update initial balance with negative amount" do
    # Arrange
    num = Random.rand(1.0..10000000.0)
    # Act
    @user.update_actual_balance(num * -1)
    # Assert
    expect(@user.actual_balance).to eq(num * -1)
  end

  it "update initial balance with positive amount" do
    # Arrange
    num = Random.rand(1.0..10000000.0)
    # Act
    @user.update_actual_balance(num)
    # Assert
    expect(@user.actual_balance).to eq(num)
  end

  it "update balance without float" do
    # Arrange
    num = "not a decimal"
    # Act & Assert
    expect { @user.update_actual_balance(num) }.to raise_error(ArgumentError, "El monto debe ser un número decimal")
  end


end
