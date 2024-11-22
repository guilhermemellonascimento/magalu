# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    purchase_date { Faker::Date.backward(days: 30) }
  end
end
