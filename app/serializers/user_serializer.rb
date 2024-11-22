# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attribute :id, key: :user_id
  attribute :name
  has_many :orders
end
