class CartProduct < ApplicationRecord
  validates_numericality_of :quantity, only_integer: true, greater_than: 0

  belongs_to :cart
  belongs_to :product

  after_save :update_cart_total_price
  after_destroy :update_cart_total_price

  def total_price
    product.price * quantity
  end

  private

  def update_cart_total_price
    cart.update!(total_price: cart.total_price)
  end
end
