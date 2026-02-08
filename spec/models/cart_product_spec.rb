require 'rails_helper'

RSpec.describe CartProduct, type: :model do
  context 'when validating' do
    it 'validates numericality of quantity' do
      cart_product = described_class.new(quantity: -1)
      expect(cart_product.valid?).to be_falsey
      expect(cart_product.errors[:quantity]).to include("must be greater than 0")
    end

    it 'validates numericality of quantity' do
      cart_product = described_class.new(quantity: "a")
      expect(cart_product.valid?).to be_falsey
      expect(cart_product.errors[:quantity]).to include("is not a number")
    end
  end
end
