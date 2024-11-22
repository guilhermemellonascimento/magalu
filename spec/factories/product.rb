# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    value { Faker::Commerce.price(range: 10..1000.0) }
  end
end
