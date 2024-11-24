# frozen_string_literal: true

class LineParser
  def parse(line)
    {
      user_id: line[0..9].to_i,
      name: line[10..54].strip,
      order_id: line[55..64].to_i,
      product_id: line[65..74].to_i,
      product_value: line[75..86].to_f,
      purchase_date: Date.strptime(line[87..94], '%Y%m%d')
    }
  end
end
