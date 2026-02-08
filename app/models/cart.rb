class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products

  def total_price
    cart_products.includes(:product).sum do |cart_product|
      cart_product.total_price
    end
  end

  def mark_as_abandoned
    return if abandoned?
    return unless updated_at < 3.hours.ago 

    update!(abandoned: true, abandoned_at: Time.current)
  end

  def remove_if_abandoned
    return unless abandoned?
    return unless abandoned_at < 7.days.ago

    destroy
  end

  def abandoned?
    abandoned
  end
end
