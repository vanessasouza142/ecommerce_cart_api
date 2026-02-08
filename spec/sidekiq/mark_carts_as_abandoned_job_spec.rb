require 'rails_helper'
RSpec.describe MarkCartsAsAbandonedJob, type: :job do
  describe '#perform' do
    let!(:abandoned_cart) { create(:cart, :inactive) }
    let!(:active_cart) { create(:cart, :active) }

    it 'marks only carts inactive for more than 3 hours as abandoned' do
      described_class.new.perform

      expect(abandoned_cart.reload.abandoned?).to be(true)
      expect(active_cart.reload.abandoned?).to be(false)
    end
  end
end
