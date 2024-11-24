# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer 'user_id'
      t.date 'purchase_date'

      t.timestamps
    end
  end
end
