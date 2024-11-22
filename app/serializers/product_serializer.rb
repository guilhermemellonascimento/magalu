# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  attributes :product_id, :value

  def value
    format('%.2f', object.value)
  end
end
