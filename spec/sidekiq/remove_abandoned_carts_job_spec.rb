require 'rails_helper'
RSpec.describe RemoveAbandonedCartsJob, type: :job do
  describe '#perform' do
    let!(:old_abandoned_cart) { create(:cart, :old_abandoned_cart) }
    let!(:recent_abandoned_cart) { create(:cart, :recent_abandoned_cart) }
    let!(:active_cart) { create(:cart) }

    it 'removes only carts abandoned for more than 7 days' do
      expect { described_class.new.perform }.to change { Cart.count }.by(-1)

      expect(Cart.exists?(old_abandoned_cart.id)).to be(false)
      expect(Cart.exists?(recent_abandoned_cart.id)).to be(true)
      expect(Cart.exists?(active_cart.id)).to be(true)
    end
  end
end
