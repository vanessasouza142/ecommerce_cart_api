class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products

  def total_price
    cart_products.includes(:product).sum do |cart_product|
      cart_product.total_price
    end
  end

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado
end
