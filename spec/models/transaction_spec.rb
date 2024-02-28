require "rails_helper"

RSpec.describe Transaction, type: :model do
  before(:each) do
    @user = User.create(actual_balance: 0, email: 'mail@mail.com', password: 'bocajuniors12ñ')
    @balance = Balance.create(amount: 0)
    @sale = Sale.create(user: @user, total_amount: Random.rand(100..1000))
    @purchase = Purchase.create(user: @user, total_amount: Random.rand(100..1000))
  end

  after(:each) do
    Transaction.destroy_all
    Balance.destroy_all
    Sale.destroy_all
    Purchase.destroy_all
    User.destroy_all
  end

  it "base case transaction with income" do
    # Act
    transaction = Transaction.create(amount: 100, transaction_type: 2, user: @user)

    # Reload the user and balance instances to get the updated data
    @user.reload
    @balance.reload

    # Assert
    expect(@user.actual_balance).to eq(100)
    expect(@balance.amount).to eq(100)
  end

  it "base case transaction with outgoing" do
    # Act
    transaction = Transaction.create(amount: 100, transaction_type: 3, user: @user)

    # Reload the user and balance instances to get the updated data
    @user.reload
    @balance.reload

    # Assert
    expect(@user.actual_balance).to eq(-100)
    expect(@balance.amount).to eq(-100)
  end

  it "base case transaction with sale payment" do
    # Arrange
    num = Random.rand(1..100)

    # Act
    sale_payment = SalePayment.create(amount: num, sale: @sale, user: @user, date: Time.now)

    # Reload the user and balance instances to get the updated data
    @user.reload
    @balance.reload

    # Assert
    expect(@user.actual_balance).to eq(num)
    expect(@balance.amount).to eq(num)
  end

  it "base case transaction with purchase payment" do
    # Arrange
    num = Random.rand(1..100)

    # Act
    purchase_payment = PurchasePayment.create(amount: num, purchase: @purchase, user: @user, date: Time.now)

    # Reload the user and balance instances to get the updated data
    @user.reload
    @balance.reload

    # Assert
    expect(@user.actual_balance).to eq(-num)
    expect(@balance.amount).to eq(-num)
  end

  it "inductive case of transaction with income" do
    # Arrange
    num = Random.rand(1..100)
    @balance.amount = num
    @balance.save!
    @user.update_actual_balance(num)

    # Act
    transaction = Transaction.create(amount: 1000, transaction_type: 2, user: @user)

    # Reload the user and balance instances to get the updated data
    @user.reload
    @balance.reload

    # Assert
    expect(@user.actual_balance).to eq(num + 1000)
    expect(@balance.amount).to eq(num + 1000)
  end

  it "inductive case of transaction with outgoing" do
    # Arrange
    num = Random.rand(1..100)
    @balance.amount = num
    @balance.save!
    @user.update_actual_balance(num)

    # Act
    transaction = Transaction.create(amount: 1000, transaction_type: 3, user: @user)

    # Reload the user and balance instances to get the updated data
    @user.reload
    @balance.reload

    # Assert
    expect(@user.actual_balance).to eq(num - 1000)
    expect(@balance.amount).to eq(num - 1000)
  end

  it "inductive case of transaction with sale payment" do
    # Arrange
    num = Random.rand(1..100)
    num2 = Random.rand(1..100)
    @balance.amount = num
    @balance.save!
    @user.actual_balance = num
    @user.save!

    # Act
    sale_payment = SalePayment.create(amount: num2, sale: @sale, user: @user, date: Time.now)

    # Reload the user and balance instances to get the updated data
    @user.reload
    @balance.reload

    # Assert
    expect(@user.actual_balance).to eq(num + num2)
    expect(@balance.amount).to eq(num + num2)
  end

  it "inductive case of transaction with purchase payment" do
    # Arrange
    num = Random.rand(1..100)
    num2 = Random.rand(1..100)
    @balance.amount = num
    @balance.save!
    @user.actual_balance = num
    @user.save!

    # Act
    purchase_payment = PurchasePayment.create(amount: num2, purchase: @purchase, user: @user, date: Time.now)

    # Reload the user and balance instances to get the updated data
    @user.reload
    @balance.reload

    # Assert
    expect(@user.actual_balance).to eq(num - num2)
    expect(@balance.amount).to eq(num - num2)
  end
end
