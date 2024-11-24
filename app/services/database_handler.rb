# frozen_string_literal: true

class DatabaseHandler
  def persist(attributes)
    user = find_or_create_user(attributes[:user_id], attributes[:name])
    order = find_or_initialize_order(user, attributes[:purchase_date], attributes[:order_id])
    create_product(order, attributes[:product_id], attributes[:product_value])
  end

  private

  def find_or_create_user(user_id, name)
    User.find_or_create_by(id: user_id) { |user| user.name = name }
  end

  def find_or_initialize_order(user, purchase_date, order_id)
    # find or initialize an order by order_id. If not found, initialize and set purchase_date.
    order = user.orders.find_or_initialize_by(id: order_id)
    order.purchase_date ||= purchase_date
    order.save if order.new_record?
    order
  end

  def create_product(order, product_id, product_value)
    order.products.find_or_create_by(product_id: product_id) { |product| product.value = product_value }
  end
end
