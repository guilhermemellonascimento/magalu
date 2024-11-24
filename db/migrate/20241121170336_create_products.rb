# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :product_id
      t.decimal :value

      t.timestamps
    end
  end
end
