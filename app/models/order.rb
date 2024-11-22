# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy

  def total_value
    products.sum(:value)
  end
end
