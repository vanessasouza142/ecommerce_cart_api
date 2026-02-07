class CartProduct < ApplicationRecord
  validates_numericality_of :quantity, only_integer: true, greater_than: 0

  belongs_to :cart
  belongs_to :product

  def total_price
    product.price * quantity
  end
end
