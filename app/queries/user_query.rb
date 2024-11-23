# frozen_string_literal: true

class UserQuery
  attr_reader :filters

  def initialize(filters)
    @filters = filters
  end

  def call
    query = User.includes(orders: :products)
    query = apply_filters(query)
    query = apply_filters(query)

    apply_kaminari(query)
  end

  private

  def apply_filters(query)
    filters = [
      ->(users) { filter_by_order_id(users) },
      ->(users) { filter_by_date_range(users) }
    ]

    filters.reduce(query) { |result, filter| filter.call(result) }
  end

  def apply_kaminari(query)
    query.page(filters[:page]).per(filters[:per_page])
  end

  def filter_by_order_id(users)
    return users if filters[:order_id].blank?

    users.joins(:orders).where(orders: { id: filters[:order_id] })
  end

  def filter_by_date_range(users)
    return users if filters[:start_date].blank? || filters[:end_date].blank?

    start_date = Date.parse(filters[:start_date])
    end_date = Date.parse(filters[:end_date])

    users.joins(:orders).where(orders: { purchase_date: start_date..end_date })
  end
end
