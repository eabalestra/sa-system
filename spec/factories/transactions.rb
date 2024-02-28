
FactoryBot.define do
  factory :transaction do
    amount { 100 }
    transaction_type { :income }
  end
end
