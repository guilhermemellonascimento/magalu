# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  attribute :id, key: :order_id
  attribute :total
  attribute :purchase_date, key: :date
  has_many :products

  def total
    format('%.2f', object.total_value)
  end

  def purchase_date
    object.purchase_date.strftime('%Y-%m-%d')
  end
end
