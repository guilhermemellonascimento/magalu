class OrderImporter
  def initialize(file_path)
    @file_path = file_path
  end

  def call
    File.foreach(@file_path).with_index do |line, index|
      next if line.strip.empty?

      # parse the line into a hash
      attributes = parse_line(line)

      # create user, order, and products
      user = find_or_create_user(attributes[:user_id], attributes[:name])
      order = find_or_create_order(user, attributes[:order_id], attributes[:purchase_date])
      create_product(order, attributes[:product_id], attributes[:product_value])
    end
  end

  private

  # parse the line and return a hash of attributes
  def parse_line(line)
    {
      user_id:       line[0..9].to_i,
      name:          line[10..54].strip,
      order_id:      line[55..64].to_i,
      product_id:    line[65..74].to_i,
      product_value: line[75..86].to_f,
      purchase_date: Date.strptime(line[87..94], '%Y%m%d')
    }
  end

  # find/create a user by user_id
  def find_or_create_user(user_id, name)
    User.find_or_create_by(id: user_id) do |user|
      user.name = name
    end
  end

  # find/create an order for the given user
  def find_or_create_order(user, order_id, purchase_date)
    user.orders.find_or_create_by(id: order_id) do |order|
      order.purchase_date = purchase_date
    end
  end

  # create a product associated with the order
  def create_product(order, product_id, product_value)
    order.products.find_or_create_by(product_id: product_id) do |product|
      product.value = product_value
    end
  end
end
